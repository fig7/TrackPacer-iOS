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
    self.timeStr   = String(format: "%.1fs", self.timeSecs)
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

  var waypointEdit = WaypointEdit()
  var waypointTimeRange = 0...10 { didSet
    {
      waypointTimeMinStr = waypointTimeRange.lowerBound.toString()
      waypointTimeMaxStr = waypointTimeRange.upperBound.toString()

      let timeMinIndex = waypointTimeMinStr.index(waypointTimeMinStr.endIndex, offsetBy: -2)
      waypointTimeMinStr.insert(".", at: timeMinIndex)

      let timeMaxIndex = waypointTimeMaxStr.index(waypointTimeMaxStr.endIndex, offsetBy: -2)
      waypointTimeMaxStr.insert(".", at: timeMaxIndex)
    } }

  @Published var waypointTimeMinStr = ""
  @Published var waypointTimeMaxStr = ""

  @Published var profileDesc = ""
  @Published var profileName = ""

  @Published var profileTime = ""
  @Published var profilePace = ""
  @Published var profileWait = ""
  @Published var profileValidity: ProfileValidity = .OK

  @Published var waypointList: [ProfileWaypoint] = []

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

  func saveProfile() {
    mainViewModel.saveProfile()
  }

  func finishProfile() {
    mainViewModel.finishProfile()
  }

  func setProfileOptions(_ runDist: String, _ alternateStart: Bool, _ runProfile: String, _ refPaceStr: String) {
    waypointList.clear()

    profileDesc = runDist + " profile" + (alternateStart ? " (AS)" : "")
    profileName = runProfile

    let refPaceSplit = refPaceStr.split(separator: ":")
    let mins = try! refPaceSplit[0].toInt()
    let secs = try! refPaceSplit[1].toInt()
    refPace = Double(mins*60 + secs)

    refDist = distanceFor(runDist, 1)
    refTime = (refDist*refPace) / 1000.0
    refTimeStr = timeToAlmostFullString(timeInMS: ((refTime*10.0).toLongRounded()*100))

    let waypointIndexList = waypointsFor(runDist, alternateStart)
    let waypointDist      = waypointDistances[runDist]!

    var prevOffset = sectionHeight
    for (i, waypointIndex) in waypointIndexList.enumerated() {
      if(i == 0) {
        waypointList.append(ProfileWaypoint(name: waypointNames[waypointIndex], dist: 0.0, waitTime: 0, refPace: refPace, offset: prevOffset, prevOffset: prevOffset))
        continue
      }

      let dist = waypointDist[i] - waypointDist[i-1]
      let time = (dist*refPace) / 1000.0

      let offset = offsetForTime(time, forDist: dist)
      waypointList.append(ProfileWaypoint(name: waypointNames[waypointIndex], dist: dist, waitTime: 0, refPace: refPace, offset: offset, prevOffset: prevOffset, roundTime: false))
      prevOffset = offset
    }

    updateTimes()
  }

  func updateTimes() {
    let movingTime   = waypointList.dropFirst().reduce(0.0) { $0 + $1.timeSecs }.rounded(toPlaces: 1)
    profileTime      = timeToAlmostFullString(timeInMS: ((movingTime*10.0).toLongRounded()*100))

    if(profileTime == refTimeStr) {
      profileValidity = .OK
    } else if(movingTime < refTime) {
      profileValidity = .TooFast
    } else {
      profileValidity = .TooSlow
    }

    let paceM   = movingTime / (refDist/50.0)
    let paceKM  = movingTime / (refDist/1000.0)
    profilePace = String(format: "(%.1f/50m, %@/km)", paceM, timeToMinuteString2(timeInMS: (paceKM.toLongRounded()*1000)))

    let restTimeMS   = waypointList.dropLast().reduce(0)    { $0 + $1.waitTime }
    profileWait      = timeToMinuteString2(timeInMS: restTimeMS)
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
    return waypointTimeRange.contains(val)
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
    waypointEdit.waypointIndex = i
    waypointEdit.atEnd = atEnd

    let waypoint = waypointList[i]
    waypointEdit.name = waypoint.name

    let secs = waypoint.timeSecs.toInt()
    let hths = ((waypoint.timeSecs - secs.toDouble())*100.0).rounded().toInt()
    waypointEdit.waypointTimeSS = String(secs)
    waypointEdit.waypointTimeHH = String(format: "%02d", hths)

    let waitTime = waypoint.waitTime / 1000
    let waitMins = waitTime / 60
    waypointEdit.waypointWaitMM = String(format: "%d", waitMins)

    let waitSecs = waitTime - waitMins*60
    waypointEdit.waypointWaitSS = String(format: "%02d", waitSecs)

    let dist = waypoint.dist
    let timeMin = ((refPace*dist)/(1.5*1000.0)).roundedToFifth()
    let timeMinHths = (timeMin*100.0).rounded().toInt()

    let timeMax = ((refPace*dist*3.0)/1000.0).roundedToFifth()
    let timeMaxHths = (timeMax*100.0).rounded().toInt()
    waypointTimeRange = timeMinHths...timeMaxHths

    mainViewModel.showEditWaypointDialog(width: 342, height: 260)
  }

  func saveWaypoint() {
    let i = waypointEdit.waypointIndex
    let oldWaypoint1 = waypointList[i]
    let oldWaypoint2 = waypointList[i+1]

    let secs = try! waypointEdit.waypointTimeSS.toInt()
    let hths = try! waypointEdit.waypointTimeHH.toInt()
    let time = Double(secs) + Double(hths)/100.0
    let offset = offsetForTime(time, forDist: oldWaypoint1.dist)

    let waitMins = try! waypointEdit.waypointWaitMM.toInt64()
    let waitSecs = try! waypointEdit.waypointWaitSS.toInt64()
    let waitTime = (waitMins*60 + waitSecs)*1000

    waypointList[i]   = ProfileWaypoint(other: oldWaypoint1, waitTime: waitTime, offset: offset, roundTime: false)
    waypointList[i+1] = ProfileWaypoint(other: oldWaypoint2, prevOffset: offset)
    updateTimes()
  }
}
