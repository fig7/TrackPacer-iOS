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

  let scaleFactor: Double
  let timeSecs: Double
  let timeStr: String

  let waitTime: Int64
  let waitTimeStr: String

  var offset: CGFloat
  var prevOffset: CGFloat

  init(name: String, waitTime: Int64, offset: CGFloat, prevOffset: CGFloat) {
    self.name     = name
    self.waitTime = waitTime

    self.offset     = clamped(offset, 0.0...sectionHeight)
    self.prevOffset = clamped(prevOffset, 0.0...sectionHeight)

    switch(self.offset) {
    case 0.0...sectionHeight2:
      let range = 1.5 - 1.0
      scaleFactor = 1.0 + range*(1.0 - self.offset/sectionHeight2)

    default:
      let oneThird = 1.0/3.0
      let range    = 1.0 - oneThird
      scaleFactor = oneThird + range*((sectionHeight - self.offset)/sectionHeight2)
    }

    let prevScaleFactor: Double
    switch(self.prevOffset) {
    case 0.0...sectionHeight2:
      let range = 1.5 - 1.0
      prevScaleFactor = 1.0 + range*(1.0 - self.prevOffset/sectionHeight2)

    default:
      let oneThird = 1.0/3.0
      let range    = 1.0 - oneThird
      prevScaleFactor = oneThird + range*((sectionHeight - self.prevOffset)/sectionHeight2)
    }

    self.timeSecs = 15.0/prevScaleFactor
    self.timeStr  = String(format: "%.1fs", self.timeSecs)

    if(waitTime == 0) {
      waitTimeStr = "--->"
    } else {
      let waitTimeMin = timeToMinuteString2(timeInMS: waitTime)
      waitTimeStr = "🛑 \(waitTimeMin) --->"
    }
  }

  init(other: ProfileWaypoint, offset: CGFloat)     { self.init(name: other.name, waitTime: other.waitTime, offset: offset,       prevOffset: other.prevOffset) }
  init(other: ProfileWaypoint, prevOffset: CGFloat) { self.init(name: other.name, waitTime: other.waitTime, offset: other.offset, prevOffset: prevOffset) }

  init(other: ProfileWaypoint, waitTime: Int64, prevOffset: CGFloat) { self.init(name: other.name, waitTime: waitTime, offset: other.offset, prevOffset: prevOffset) }
}

@MainActor class ProfileViewModel : ObservableObject {
  unowned var mainViewModel: MainViewModel!

  @Published var profileDist = ""
  @Published var profileName = ""

  var refDist: Double = 0.0
  var refTime: Double = 0.0
  var refTimeStr: String = ""

  @Published var profileTime = ""
  @Published var profilePace = ""
  @Published var profileWait = ""
  @Published var profileValidity: ProfileValidity = .OK

  @Published var waypointList = [
    ProfileWaypoint(name: "  0m", waitTime: 0, offset: sectionHeight2, prevOffset: sectionHeight),
    ProfileWaypoint(name: " 50m", waitTime: 0, offset: sectionHeight2, prevOffset: sectionHeight2),
    ProfileWaypoint(name: "100m", waitTime: 0, offset: sectionHeight2, prevOffset: sectionHeight2),
    ProfileWaypoint(name: "150m", waitTime: 0, offset: sectionHeight2, prevOffset: sectionHeight2),
    ProfileWaypoint(name: "200m", waitTime: 0, offset: sectionHeight2, prevOffset: sectionHeight2),
    ProfileWaypoint(name: "250m", waitTime: 0, offset: sectionHeight2, prevOffset: sectionHeight2),
    ProfileWaypoint(name: "300m", waitTime: 0, offset: sectionHeight2, prevOffset: sectionHeight2),
    ProfileWaypoint(name: "350m", waitTime: 0, offset: sectionHeight2, prevOffset: sectionHeight2),
    ProfileWaypoint(name: "Finish", waitTime: 0, offset: sectionHeight2, prevOffset: sectionHeight2)
  ]

  var waypointEdit = WaypointEdit()

  func setMain(mainViewModel: MainViewModel) {
    self.mainViewModel = mainViewModel
  }

  func saveProfile() {
    mainViewModel.saveProfile()
  }

  func finishProfile() {
    mainViewModel.finishProfile()
  }

  func setProfileOptions(_ runDist: String, _ runProfile: String, _ refPace: Double) {
    profileDist = runDist
    profileName = runProfile

    refDist = distanceFor(runDist, 1)
    refTime = (refDist*refPace*20.0)/1000.0
    refTimeStr = timeToAlmostFullString(timeInMS: ((refTime*10.0).toLongRounded()*100))

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

  func validateSecs(_ secsStr: String, _ hthsStr: String, _ secsRange: ClosedRange<Double>) -> Bool {
    if(secsStr.count > 2)  { return false }
    if(hthsStr.count != 2) { return false }

    do {
      let secs = try secsStr.toInt()
      let hths = try hthsStr.toInt()

      let val = Double(secs) + Double(hths)/100.0
      if(secsRange.contains(val)) { return true }
    } catch { }

    return false
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

    mainViewModel.showEditWaypointDialog(width: 342, height: 260)
  }

  func saveWaypoint() {
    let i = waypointEdit.waypointIndex
    let oldWaypoint1 = waypointList[i]
    let oldWaypoint2 = waypointList[i-1]

    let secs = try! waypointEdit.waypointTimeSS.toInt()
    let hths = try! waypointEdit.waypointTimeHH.toInt()
    let time = Double(secs) + Double(hths)/100.0
    let offset = offsetForTime(time)

    let waitMins = try! waypointEdit.waypointWaitMM.toInt64()
    let waitSecs = try! waypointEdit.waypointWaitSS.toInt64()
    let waitTime = (waitMins*60 + waitSecs)*1000

    waypointList[i]   = ProfileWaypoint(other: oldWaypoint1, waitTime: waitTime, prevOffset: offset)
    waypointList[i-1] = ProfileWaypoint(other: oldWaypoint2, offset: offset)
    updateTimes()
  }
}
