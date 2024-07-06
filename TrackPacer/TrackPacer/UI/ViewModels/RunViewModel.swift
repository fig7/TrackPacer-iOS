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
  var laneSelection: LaneSelection = LaneSelection()

  var timeSelection: TimeSelection = TimeSelection()
  let timeEdit: TimeEdit

  var profileSelection: ProfileSelection = ProfileSelection()
  var trackSelection: TrackSelection     = TrackSelection()

  init(_ runModel: RunModel) {
    self.runModel  = runModel

    timeEdit = TimeEdit(timeSelection)
  }

  func setMain(mainViewModel: MainViewModel) {
    self.mainViewModel = mainViewModel
  }

  func initTimes() throws {
    let selectedDistance = distanceSelection.selected
    try initTimes(selectedDistance)
  }

  func initCallbacks() {
    distanceSelection.selectedCallback = { [weak self] newSelected in
      guard let self else { return }

      do {
        try initTimes(newSelected)
      } catch { }

      // How to grant access properly?
      let profileArray = runModel.distanceModel.distanceManager.profileMap[newSelected]!.map { $0.0 }

      profileSelection.list     = profileArray
      profileSelection.selected = profileSelection.list[0]

      updateTrackOverlay()
    }

    laneSelection.selectedCallback = { [weak self] newSelected in
      guard let self else { return }
      updateTrackOverlay()
    }
  }

  func initDistances(_ distanceArray: [String], _ profileArray: [String]) throws {
    // To workaround a picker bug, the picker selection is padded with spaces
    distanceSelection.list           = distanceArray.map { (pickerBugWorkaround: String) in " " + pickerBugWorkaround + " "}
    distanceSelection.selectedPadded = distanceSelection.list[0]

    laneSelection.list     = ["1", "2", "3", "4", "5", "6", "7", "8"]
    laneSelection.selected = laneSelection.list[0]

    profileSelection.list     = profileArray
    profileSelection.selected = profileSelection.list[0]

    try initTimes()
    initCallbacks()
  }

  func initTimes(_ selectedDistance: String) throws {
    let timeArray = try runModel.timesFor(selectedDistance)
    try updateTimes(timeArray, selected: 0)
  }

  func updateTimes(_ timeArray: [String], selected: Int) throws {
    guard (selected < timeArray.count) else { throw Exception.IllegalArgumentException }

    timeSelection.list     = timeArray
    timeSelection.selected = timeSelection.list[selected]
  }

  func updateProfiles(_ profileArray: [String]) {
    profileSelection.list     = profileArray
    profileSelection.selected = profileSelection.list[profileArray.count - 1]
  }

  func updateTrackOverlay() {
    do {
      let runDist = distanceSelection.selected
      let runLane = try laneSelection.selected.toInt()

      let settingsModel   = mainViewModel.settingsModel
      let settingsManager = settingsModel.settingsManager
      let alternateStart  = settingsManager.alternateStart

      let totalDist = distanceFor(runDist, runLane)
      trackSelection.totalDist  = formatDist(runDist, runLane, totalDist)

      trackSelection.lapCounter = rtLaps(runDist, runLane)
      trackSelection.lapDesc1   = rtDesc1(runDist, runLane, alternateStart)
      trackSelection.lapDesc2   = rtDesc2(runDist, runLane, alternateStart)

      trackSelection.trackOverlay = rtOverlay(runDist, runLane, alternateStart)
    } catch { }
  }

  func editProfile() {
    let runDist = distanceSelection.selected
    mainViewModel.editProfile(runDist, profileSelection.selected)
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
      let runTime = try runTimeFor(timeSelection.selected)
      (timeEdit.mins, timeEdit.secs, timeEdit.hths) = mshFromRunTime(runTime)
    } catch { }

    mainViewModel.showEditTimeDialog(width: 300, height: 382)
  }

  func deleteTime() {
    do {
      (timeSelection.list, timeSelection.selected) = try runModel.deleteTime(timeSelection.selected, distanceSelection.selected)
    } catch {
      mainViewModel.handleDistanceError()
    }
  }

  func addTime() {
    do {
      (timeSelection.list, timeSelection.selected) = try runModel.addTime(timeEdit.timeStr, distanceSelection.selected)
    } catch {
      mainViewModel.handleDistanceError()
    }
  }

  func setTime() {
    do {
      (timeSelection.list, timeSelection.selected) = try runModel.setTime(timeSelection.selected, timeEdit.timeStr, distanceSelection.selected)
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
      let distanceSelected = distanceSelection.selected
      let runDist = distanceSelected

      let laneSelected = laneSelection.selected
      let runLane = try laneSelected.toInt()

      let timeSelected = timeSelection.selected
      let runTime = try runTimeFor(timeSelected)

      let profileSelected = profileSelection.selected
      let runProfile = profileSelected

      mainViewModel.onYourMarks(runDist, runLane, runTime, runProfile)
    } catch { }
  }
}
