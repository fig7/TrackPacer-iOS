//
//  ProfileViewModel.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 09/06/2024.
//

import SwiftUI

struct ProfileWaypoint {
  let name: String
  let scaleFactor: Double

  let waitTime: Int64
  let waitTimeStr: String

  var offset: CGFloat
  var prevOffset: CGFloat

  let timeSecs: Double
  let timeStr: String

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
  @Published var profileTimeCol: Color = .black

  @Published var waypointList = [
    ProfileWaypoint(name: "  0m", waitTime: 0, offset: sectionHeight2, prevOffset: sectionHeight),
    ProfileWaypoint(name: " 50m", waitTime: 0, offset: sectionHeight2, prevOffset: sectionHeight2),
    ProfileWaypoint(name: "100m", waitTime: 0, offset: sectionHeight2, prevOffset: sectionHeight2),
    ProfileWaypoint(name: "150m", waitTime: 0, offset: sectionHeight2, prevOffset: sectionHeight2),
    ProfileWaypoint(name: "200m", waitTime: 0, offset: sectionHeight2, prevOffset: sectionHeight2),
    ProfileWaypoint(name: "250m", waitTime: 0, offset: sectionHeight2, prevOffset: sectionHeight2),
    ProfileWaypoint(name: "300m", waitTime: 0, offset: sectionHeight2, prevOffset: sectionHeight2),
    ProfileWaypoint(name: "350m", waitTime: 0, offset: sectionHeight2, prevOffset: sectionHeight2),
    ProfileWaypoint(name: "400m", waitTime: 0, offset: sectionHeight2, prevOffset: sectionHeight2)
  ]

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
      profileTimeCol = .black
    } else if(movingTime < refTime) {
      profileTimeCol = .red
    } else {
      profileTimeCol = .blue
    }

    let paceM   = movingTime / (refDist/50.0)
    let paceKM  = movingTime / (refDist/1000.0)
    profilePace = String(format: "(%.1f/50m, %@/km)", paceM, timeToMinuteString2(timeInMS: (paceKM.toLongRounded()*1000)))

    let restTimeMS   = waypointList.dropLast().reduce(0)    { $0 + $1.waitTime }
    profileWait      = timeToMinuteString2(timeInMS: restTimeMS)
  }
}
