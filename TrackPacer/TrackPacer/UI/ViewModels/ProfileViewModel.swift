//
//  ProfileViewModel.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 09/06/2024.
//

import Foundation

enum ProfileValidity { case OK, TooFast, TooSlow }

struct ProfileWaypoint {
  let name: String
  let dist: Double

  let refPace: Double
  let scaleFactor: Double

  let timeSecs: Double
  let timeStr: String
  let roundTime: Bool

  let waitTime: Int64
  let waitTimeStr: String

  var offset: CGFloat
  var prevOffset: CGFloat

  init(name: String, dist: Double, waitTime: Int64, refPace: Double, offset: CGFloat, prevOffset: CGFloat, roundTime: Bool = true) {
    self.name     = name
    self.dist     = dist

    self.waitTime = waitTime
    self.refPace  = refPace

    self.offset     = offset
    self.prevOffset = prevOffset

    switch(self.offset) {
    case ...sectionHeight2:
      let range = 1.5 - 1.0
      scaleFactor = 1.0 + range*(1.0 - self.offset/sectionHeight2)

    default:
      let oneThird = 1.0/3.0
      let range    = 1.0 - oneThird
      scaleFactor = oneThird + range*((sectionHeight - self.offset)/sectionHeight2)
    }

    let time = ((refPace*dist)/(scaleFactor*1000.0))
    self.timeSecs  = (roundTime) ? time.roundedToFifth() : time
    self.timeStr   = String(format: "%.1f", self.timeSecs)
    self.roundTime = roundTime

    if(waitTime == 0) {
      waitTimeStr = "--->"
    } else {
      let waitTimeMin = timeToMinuteString2(timeInMS: waitTime)
      waitTimeStr = "🛑 \(waitTimeMin) --->"
    }
  }

  init(other: ProfileWaypoint, offset: CGFloat, roundTime: Bool)
  { self.init(name: other.name, dist: other.dist, waitTime: other.waitTime, refPace: other.refPace, offset: offset, prevOffset: other.prevOffset, roundTime: roundTime) }

  init(other: ProfileWaypoint, prevOffset: CGFloat)
  { self.init(name: other.name, dist: other.dist, waitTime: other.waitTime, refPace: other.refPace, offset: other.offset, prevOffset: prevOffset, roundTime: other.roundTime) }

  init(other: ProfileWaypoint, waitTime: Int64, offset: CGFloat, roundTime: Bool)
  { self.init(name: other.name, dist: other.dist, waitTime: waitTime, refPace: other.refPace, offset: offset, prevOffset: other.prevOffset, roundTime: roundTime) }
}

@MainActor class ProfileViewModel : ObservableObject {
  unowned var mainViewModel: MainViewModel!

  var refDist = 0.0
  var refTime = 0.0
  var refPace = 0.0
  var refTimeStr = ""

  var wpEdit = WaypointEdit()
  var wpTimeRange = 0...10 { didSet
    {
      wpTimeMinStr = wpTimeRange.lowerBound.toString()
      wpTimeMaxStr = wpTimeRange.upperBound.toString()

      let timeMinIndex = wpTimeMinStr.index(wpTimeMinStr.endIndex, offsetBy: -2)
      wpTimeMinStr.insert(".", at: timeMinIndex)

      let timeMaxIndex = wpTimeMaxStr.index(wpTimeMaxStr.endIndex, offsetBy: -2)
      wpTimeMaxStr.insert(".", at: timeMaxIndex)
    } }

  @Published var wpTimeMinStr = ""
  @Published var wpTimeMaxStr = ""

  var profDist  = ""

  @Published var profName  = ""
  @Published var profDesc  = ""
  @Published var profIntvl = Intvl.i50m
  @Published var newProf = true

  @Published var profTime = ""
  @Published var profPace = ""
  @Published var profWait = ""
  @Published var profValidity: ProfileValidity = .OK

  var profData: [WaypointData] = []
  @Published var profList: [ProfileWaypoint] = []

  func setMain(mainViewModel: MainViewModel) {
    self.mainViewModel = mainViewModel
  }

  func timeForOffset(_ offset: CGFloat, forDist dist: Double) -> Double {
    let oneThird = 1.0/3.0
    let offsetClamped = clamped(offset, 0.0...sectionHeight)

    let scaleFactor: Double
    switch(offsetClamped) {
      case 0.0...sectionHeight2:
        let range = 1.5 - 1.0
        scaleFactor = 1.0 + range*(1.0 - offsetClamped/sectionHeight2)

      default:
        let range    = 1.0 - oneThird
        scaleFactor = oneThird + range*((sectionHeight - offsetClamped)/sectionHeight2)
    }

    let time = (refPace*dist)/(scaleFactor*1000.0)
    return time.roundedToFifth()
  }

  func offsetForTime(_ time: Double, forDist dist: Double) -> CGFloat {
    let scaleFactor = (refPace*dist) / (time*1000.0)

    let offset: CGFloat
    switch(scaleFactor) {
    case 1.0...:
      let range = 0.5
      offset = sectionHeight2 - sectionHeight2*((scaleFactor - 1.0)/range)

    default:
      let oneThird = 1.0/3.0
      let range    = 1.0 - oneThird
      offset = sectionHeight2 + sectionHeight2*((1.0 - scaleFactor)/range)
    }

    return offset
  }

  func snapTo(_ y: CGFloat, forDist dist: Double) -> CGFloat {
    let time = timeForOffset(y, forDist: dist)
    return offsetForTime(time, forDist: dist)
  }

  func updateProfileData(_ intvl: Intvl, _ baseData: [WaypointData], _ waypoints: [ProfileWaypoint]) -> [WaypointData]
  {
    let insertCount: Int
    switch intvl {
    case Intvl.i50m, Intvl.i1200m, Intvl.i1500m, Intvl.i3000m, Intvl.i4000m, Intvl.i10000m, Intvl.i10km, Intvl.i1mile:
      return baseData

    case Intvl.i100m:
      insertCount = 1

    case Intvl.i200m:
      insertCount = 3

    case Intvl.i400m:
      insertCount = 7

    case Intvl.i800m:
      insertCount = 15

    case Intvl.i1000m, Intvl.i1km:
      insertCount = 19

    case Intvl.i2000m, Intvl.i2km:
      insertCount = 39

    case Intvl.i5000m, Intvl.i5km:
      insertCount = 99
    }

    var srcIndex = 0
    let updateLimit = baseData.count - 1
    var updatedWaypoints: [WaypointData] = [WaypointData(scaleFactor: waypoints[0].scaleFactor)]
    repeat {
      srcIndex += 1
      let srcWaypoint = waypoints[srcIndex]

      for _ in 0..<insertCount {
        updatedWaypoints.append(WaypointData(scaleFactor: srcWaypoint.scaleFactor))
        if(updatedWaypoints.count == updateLimit) {
          updatedWaypoints.append(WaypointData(scaleFactor: srcWaypoint.scaleFactor, waitTime: srcWaypoint.waitTime))
          return updatedWaypoints
        }
      }

      updatedWaypoints.append(WaypointData(scaleFactor: srcWaypoint.scaleFactor, waitTime: srcWaypoint.waitTime))
    } while true
  }

  func saveProfile() {
    if(profName.isEmpty) {
      mainViewModel.showInfoDialog(title: "Profile name not set",
      message:
      "Please enter a name for the profile before saving your changes.",
      width: 342, height: 240)

      return
    }
    else if(profValidity != .OK) {
      mainViewModel.showInfoDialog(title: "Profile time invalid",
      message:
      "The reference time for the profile must remain the same. " +
      "If you have made one section faster, you must make another section slower to compensate.",
      width: 342, height: 240)

      return
    }

    let updatedData = updateProfileData(profIntvl, profData, profList)
    mainViewModel.saveProfile(profDist, profIntvl, profName, updatedData)
  }

  func deleteProfile() {
    if(profName == "Fixed pace") {
      mainViewModel.showInfoDialog(title: "Profile cannot be deleted",
        message:
        "The built-in Fixed pace profile cannot be deleted. Only user created profiles can be deleted.",
        width: 342, height: 240)

      return
    }

    mainViewModel.deleteProfile(profDist, profIntvl, profName)
  }

  func setProfileOptions(_ baseDist: String, _ runStart: String, _ runIntvl: Intvl, _ waypointData: [WaypointData], _ refPaceStr: String) {
    setProfileOptions(baseDist, runStart, runIntvl, "", waypointData, refPaceStr, true);
  }

  func setProfileOptions(_ baseDist: String, _ runStart: String, _ runIntvl: Intvl, _ runProf: String, _ runData: [WaypointData], _ refPaceStr: String, _ createProf: Bool = false) {
    profList.clear()

    profName  = runProf
    profIntvl = runIntvl

    profData = runData
    newProf  = createProf

    profDist = baseDist
    profDesc = baseDist + " (\(stringFromIntvl(runIntvl))) "

    let refPaceSplit = refPaceStr.split(separator: ":")
    let mins = try! refPaceSplit[0].toInt()
    let secs = try! refPaceSplit[1].toInt()
    refPace = Double(mins*60 + secs)

    refDist = distanceFor(baseDist, 1)
    refTime = (refDist*refPace) / 1000.0
    refTimeStr = timeToAlmostFullString(timeInMS: ((refTime*10.0).toLongRounded()*100))

    let distAndStart = baseDist + " (" + runStart + ")"
    let wpIndexList = waypointsFor(distAndStart, runIntvl)
    let wpDist      = waypointDistances[baseDist]!

    var lastI = 0
    var prevOffset = sectionHeight
    for (i, wpIndex) in wpIndexList.enumerated() {
      if(i == 0) {
        profList.append(ProfileWaypoint(name: waypointNames[wpIndex], dist: 0.0, waitTime: 0, refPace: refPace, offset: prevOffset, prevOffset: prevOffset))
        continue
      }

      if(wpIndex == sl) {
        continue
      }

      let dist = wpDist[i] - wpDist[lastI]
      let time = (dist*refPace) / (1000.0*runData[i].scaleFactor)

      let offset = offsetForTime(time, forDist: dist)
      profList.append(ProfileWaypoint(name: waypointNames[wpIndex], dist: dist, waitTime: runData[i].waitTime, refPace: refPace, offset: offset, prevOffset: prevOffset, roundTime: false))

      prevOffset = offset
      lastI = i
    }

    updateTimes()
  }

  func updateTimes() {
    let movingTime   = profList.dropFirst().reduce(0.0) { $0 + $1.timeSecs }.rounded(toPlaces: 1)
    profTime      = timeToAlmostFullString(timeInMS: ((movingTime*10.0).toLongRounded()*100))

    if(profTime == refTimeStr) {
      profValidity = .OK
    } else if(movingTime < refTime) {
      profValidity = .TooFast
    } else {
      profValidity = .TooSlow
    }

    let paceM   = movingTime / (refDist/50.0)
    let paceKM  = movingTime / (refDist/1000.0)
    profPace = String(format: "(%.1f/50m, %@/km)", paceM, timeToMinuteString2(timeInMS: (paceKM.toLongRounded()*1000)))

    let restTimeMS   = profList.dropLast().reduce(0)    { $0 + $1.waitTime }
    profWait      = timeToMinuteString2(timeInMS: restTimeMS)
  }

  func validateWaypointTime(_ secsStr: String, _ hthsStr: String) -> Bool {
    if(secsStr.count > 2)  { return false }
    if(hthsStr.count != 2) { return false }

    let secs, hths: Int
    do {
      secs = try secsStr.toInt()
      hths = try hthsStr.toInt()
    } catch { return false }

    let val = secs*100 + hths
    return wpTimeRange.contains(val)
  }

  func validateMinsSecs(_ minsStr: String, _ secsStr: String, _ secsRange: ClosedRange<Int>) -> Bool {
    if(minsStr.count > 2)  { return false }
    if(secsStr.count != 2) { return false }

    do {
      let mins = try minsStr.toInt()
      let secs = try secsStr.toInt()
      if(secs > 59) { return false }

      let val = mins*60 + secs
      if((val == 0) || secsRange.contains(val)) { return true }
    } catch { }

    return false
  }

  func editWaypoint(_ i: Int, _ atEnd: Bool) {
    wpEdit.waypointIndex = i
    wpEdit.atEnd = atEnd

    let waypoint = profList[i]
    wpEdit.name = waypoint.name

    let secs = waypoint.timeSecs.toInt()
    let hths = ((waypoint.timeSecs - secs.toDouble())*100.0).rounded().toInt()
    wpEdit.waypointTimeSS = String(secs)
    wpEdit.waypointTimeHH = String(format: "%02d", hths)

    let waitTime = waypoint.waitTime / 1000
    let waitMins = waitTime / 60
    wpEdit.waypointWaitMM = String(format: "%d", waitMins)

    let waitSecs = waitTime - waitMins*60
    wpEdit.waypointWaitSS = String(format: "%02d", waitSecs)

    let dist = waypoint.dist
    let timeMin = ((refPace*dist)/(1.5*1000.0)).roundedToFifth()
    let timeMinHths = (timeMin*100.0).rounded().toInt()

    let timeMax = ((refPace*dist*3.0)/1000.0).roundedToFifth()
    let timeMaxHths = (timeMax*100.0).rounded().toInt()
    wpTimeRange = timeMinHths...timeMaxHths

    mainViewModel.showEditWaypointDialog(width: 342, height: 260)
  }

  func saveWaypoint() {
    let iMax = profList.size
    let i = wpEdit.waypointIndex
    let oldWaypoint1 = profList[i]
    let oldWaypoint2 = ((i+1) < iMax) ? profList[i+1] : profList[0]

    let secs = try! wpEdit.waypointTimeSS.toInt()
    let hths = try! wpEdit.waypointTimeHH.toInt()
    let time = Double(secs) + Double(hths)/100.0
    let offset = offsetForTime(time, forDist: oldWaypoint1.dist)

    let waitMins = try! wpEdit.waypointWaitMM.toInt64()
    let waitSecs = try! wpEdit.waypointWaitSS.toInt64()
    let waitTime = (waitMins*60 + waitSecs)*1000

    profList[i]   = ProfileWaypoint(other: oldWaypoint1, waitTime: waitTime, offset: offset, roundTime: false)
    if((i+1) < iMax) { profList[i+1] = ProfileWaypoint(other: oldWaypoint2, prevOffset: offset) }

    updateTimes()
  }
}
