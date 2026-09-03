//
//  RunViewModel.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 12/05/2024.
//

import Foundation

@MainActor class RunViewModel : ObservableObject {
  unowned let runModel: RunModel
  unowned var mainViewModel: MainViewModel!

  var distanceSelection: DistanceSelection = DistanceSelection()
  var startSelection: StartSelection = StartSelection()
  var laneSelection: LaneSelection = LaneSelection()

  var timeSelection: TimeSelection = TimeSelection()
  var paceSelection: PaceSelection = PaceSelection()
  let timeEdit: TimeEdit

  var profileSelection: ProfileSelection = ProfileSelection()
  var intervalSelection: IntervalSelection = IntervalSelection()

  var trackSelection: TrackSelection = TrackSelection()

  init(_ runModel: RunModel) {
    self.runModel  = runModel

    timeEdit = TimeEdit(timeSelection)
  }

  func setMain(mainViewModel: MainViewModel) {
    self.mainViewModel = mainViewModel
  }

  func startListFor(dist: String) -> [String]
  {
    switch(dist)
    {
    case "1500m", "1 mile":
      return ["Race"]

    case "1000m", "3000m":
      return ["Home", "Race"]

    case "5000m":
      return ["Home", "Race", "Road"]

    case "10000m":
      return ["Home", "Road"]

    default: // 400m, 800m, 1200m, 2000m, 4000m
      return ["Home"]
    }
  }

  func paceListFor(start: String) -> [String]
  {
    switch(start)
    {
    case "Road":
      return ["Pace", "Goal"]

    default: // Home, Race
      return ["Pace", "Goal", "Actual"]
    }
  }

  func intevalListFor(distance: String, start: String) -> [String]
  {
    if(start == "Road")
    {
      return ["1km"]
    }

    switch(distance)
    {
    case "400m":
      return ["50m", "100m", "200m", "400m"]

    case "800m":
      return ["50m", "100m", "200m", "400m", "800m"]

    default:
      return ["50m", "100m", "200m", "400m", "800m", "1000m"]
    }
  }

  func initTimes() throws {
    let selectedDist = distanceSelection.selected
    let selectedPace     = paceSelection.selected
    try initTimes(selectedDist, selectedPace)
  }

  func initCallbacks() {
    distanceSelection.selectedCallback = { [weak self] newSelected in
      guard let self else { return }

      do {
        try initTimes(newSelected, paceSelection.selected)
      } catch { }

      startSelection.list = startListFor(dist: newSelected);
      if(!startSelection.list.contains(startSelection.selected)) {
        startSelection.selected = startSelection.list[0]
      }

      let profArray = runModel.distanceModel.distanceManager.profMap[newSelected]![Intvl.i50m]!.map { $0.0 }
      profileSelection.list     = profArray
      profileSelection.selected = profileSelection.list[0]

      intervalSelection.list = intevalListFor(distance: newSelected, start: startSelection.selected)
      if(!intervalSelection.list.contains(intervalSelection.selected)) {
        intervalSelection.selected = intervalSelection.list[0]
      }

      updateTrackOverlay()
    }

    paceSelection.selectedCallback = { [weak self] newSelected in
      guard let self else { return }

      do {
        try initTimes(distanceSelection.selected, newSelected)
      } catch { }

      updateTrackOverlay()
    }

    startSelection.selectedCallback = { [weak self] newSelected in
      guard let self else { return }

      paceSelection.list = paceListFor(start: newSelected);
      if(!paceSelection.list.contains(paceSelection.selected)) {
        paceSelection.selected = paceSelection.list[1]
      }

      intervalSelection.list = intevalListFor(distance: newSelected, start: startSelection.selected)
      if(!intervalSelection.list.contains(intervalSelection.selected)) {
        intervalSelection.selected = intervalSelection.list[0]
      }

      updateTrackOverlay()
    }

    laneSelection.selectedCallback = { [weak self] newSelected in
      guard let self else { return }

      updateTrackOverlay()
    }
  }

  func initDistances(_ distanceArray: [String], _ profileArray: [String]) throws {
    // To workaround a picker bug, the picker selection is padded with spaces
    distanceSelection.list = distanceArray.map { (pickerBugWorkaround: String) in " " + pickerBugWorkaround + " " }
    distanceSelection.selectedPadded = distanceSelection.list[0]

    profileSelection.list     = profileArray
    profileSelection.selected = profileSelection.list[0]

    try initTimes()
    initCallbacks()
  }

  func initTimes(_ selectedDist: String, _ selectedPace: String) throws {
    let timeArray = try runModel.timesFor(selectedDist, selectedPace)
    try updateTimes(timeArray)
  }

  func updateTimes(_ timeArray: [String]) throws {
    // To workaround a picker bug, the picker selection is padded with spaces
    timeSelection.list = timeArray.map { (pickerBugWorkaround: String) in " " + pickerBugWorkaround + " " }
    if(!timeSelection.list.contains(timeSelection.selected)) {
      timeSelection.selected = timeSelection.list[0]
    }
  }

  func updateProfiles(_ profileArray: [String]) {
    profileSelection.list     = profileArray
    profileSelection.selected = profileSelection.list[profileArray.count - 1]
  }

  func updateTrackOverlay() {
    do {
      let baseDist  = distanceSelection.selected
      if(baseDist == "") {
        // There's been an error loading distances
        return
      }

      let startType = startSelection.selected
      let runLane   = try laneSelection.selected.toInt()

      let runDist = distanceFor(baseDist, runLane)
      trackSelection.runDist    = formatDist(baseDist, runLane, runDist)
      distanceSelection.runDist = formatDist2(baseDist, runLane, runDist)

      trackSelection.lapCounter = rtLaps(baseDist, startType, runLane)
      trackSelection.lapDesc1   = rtDesc1(baseDist, startType, runLane)
      trackSelection.lapDesc2   = rtDesc2(baseDist, startType, runLane)

      let settingsModel   = mainViewModel.settingsModel
      let settingsManager = settingsModel.settingsManager
      let runClockwise    = settingsManager.runClockwise

      trackSelection.trackOverlay = rtOverlay(baseDist, startType, runLane, runClockwise)
    } catch { }
  }

  func editProfile() {
    let runDist = distanceSelection.selected
    mainViewModel.editProfile(runDist, profileSelection.selected, intervalSelection.selected)
  }

  func showProfileHelp() {
    mainViewModel.showInfoDialog(title: "Create profiles", message:
      "Profiles are a feature that allow you to incorporate changes to your pace.\n\n" +
      "Perhaps you want to run at a slower pace, or stop to recover, between fast intervals. Speed up and slow down, you decide when!\n\n" +
      "Profiles will only be available in the pro version of TrackPacer, which is coming soon...",
      width: 342, height: 356)
  }

  func editTime() {
    do {
      timeEdit.unit = paceSelection.selected
      timeEdit.dist = distanceSelection.selected.trim()
      let setTime = try setTimeFor(timeSelection.selected)
      (timeEdit.mins, timeEdit.secs, timeEdit.hths) = mshFromRunTime(setTime)
    } catch { }

    mainViewModel.showEditTimeDialog(width: 300, height: 382)
  }

  func deleteTime() {
    do {
      (timeSelection.list, timeSelection.selected) =
      try runModel.deleteTime(timeSelection.selected.trim(), distanceSelection.selected, paceSelection.selected)
    } catch {
      mainViewModel.handleDistanceError()
    }
  }

  func addTime() {
    do {
      (timeSelection.list, timeSelection.selected) =
        try runModel.addTime(timeEdit.timeStr, distanceSelection.selected, paceSelection.selected)
    } catch {
      mainViewModel.handleDistanceError()
    }
  }

  func setTime() {
    do {
      (timeSelection.list, timeSelection.selected) =
      try runModel.setTime(timeSelection.selected.trim(), timeEdit.timeStr, distanceSelection.selected, paceSelection.selected)
    } catch {
      mainViewModel.handleDistanceError()
    }
  }

  func performTimeEdit() {
    let editAction = timeEdit.editAction
    timeEdit.editAction = .UserCancel

    Task { @MainActor in
      switch(editAction) {
      case .UserAdd:
        addTime()

      case .UserSet:
        setTime()

      case .UserDelete:
        deleteTime()

      default:
        break
      }
    }
  }

  func onYourMarks() {
    do {
      let baseDist  = distanceSelection.selected + " (" + startSelection.selected + ")"

      let laneSelected = laneSelection.selected
      let runLane = try laneSelected.toInt()

      let setPace      = paceSelection.selected
      let timeSelected = timeSelection.selected
      let setTime = try setTimeFor(timeSelected)

      let runProf = profileSelection.selected + " (" + intervalSelection.selected + ")"
      mainViewModel.onYourMarks(baseDist, runLane, setPace, setTime, runProf)
    } catch { }
  }
}
