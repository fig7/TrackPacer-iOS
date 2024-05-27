//
//  RunViewModel.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 12/05/2024.
//

import Foundation

@MainActor class RunViewModel {
  unowned let runModel: RunModel
  unowned var mainViewModel: MainViewModel!

  var distanceSelection: DistanceSelection = DistanceSelection()
  var laneSelection: LaneSelection = LaneSelection()
  var timeSelection: TimeSelection = TimeSelection()

  var trackSelection: TrackSelection = TrackSelection()

  init(_ runModel: RunModel) {
    self.runModel  = runModel
  }

  func setMain(mainViewModel: MainViewModel) {
    self.mainViewModel = mainViewModel
  }

  func initTimes() throws {
    let selectedDistance = distanceSelection.selected.trim()
    try initTimes(selectedDistance)
  }

  func initCallbacks() {
    distanceSelection.selectedCallback = { [weak self] newSelected in
      guard let self else { return }

      do {
        let newSelected = newSelected.trim()
        try initTimes(newSelected)
      } catch { }

      updateTrackOverlay()
    }

    laneSelection.selectedCallback = { [weak self] newSelected in
      guard let self else { return }
      updateTrackOverlay()
    }
  }

  func initDistances(_ distanceArray: [String]) throws {
    distanceSelection.list     = distanceArray.map { (pickerBugWorkaround: String) in " " + pickerBugWorkaround + " "}
    distanceSelection.selected = distanceSelection.list[0]

    laneSelection.list         = ["1", "2", "3", "4", "5", "6", "7", "8"]
    laneSelection.selected     = laneSelection.list[0]

    try initTimes()
    initCallbacks()
    updateTrackOverlay()
  }

  func initTimes(_ selectedDistance: String) throws {
    let timeArray = try runModel.timesFor(selectedDistance)
    updateTimes(timeArray, selected: 0)
  }

  func updateTimes(_ timeArray: [String], selected: Int) {
    timeSelection.list     = timeArray
    timeSelection.selected = timeSelection.list[selected]
  }

  func updateTrackOverlay() {
    do {
      let runDist        = distanceSelection.selected.trim()
      let runLane        = try laneSelection.selected.toInt()
      let alternateStart = false // TODO: settingsModel.settingsManager.alternateStart

      let totalDist = distanceFor(runDist, runLane)
      trackSelection.totalDist  = formatDist(runDist, runLane, totalDist)

      trackSelection.lapCounter = rtLaps(runDist, runLane)
      trackSelection.lapDesc1   = rtDesc1(runDist, runLane, alternateStart)
      trackSelection.lapDesc2   = rtDesc2(runDist, runLane, alternateStart)

      trackSelection.trackOverlay = rtOverlay(runDist, runLane, alternateStart)
    } catch { }
  }

  func showProfileHelp() {
    mainViewModel.showInfoDialog(title: "Create profiles", message:
      "Profiles are a feature that allow you to incorporate changes to your pace.\n\n" +
      "Perhaps you want to run at a slower pace, or stop to recover, between fast intervals. Speed up and slow down, you decide when!\n\n" +
      "Profiles will only be available in the pro version of TrackPacer, which is coming soon...",
      width: 342, height: 342)
  }

  func fetchPacingOptions() -> (String, Int, Double) {
    do {
      let distanceSelected = distanceSelection.selected
      let runDist = distanceSelected.trim()

      let laneSelected = laneSelection.selected
      let runLane = try laneSelected.toInt()

      let timeSelected = timeSelection.selected
      let runTime = try runTimeFor(selectedTime: timeSelected)

      return (runDist, runLane, runTime)
    } catch { }

    return ("", 0, 0.0)
  }
}
