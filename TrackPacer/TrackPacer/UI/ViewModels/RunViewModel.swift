//
//  RunViewModel.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 12/05/2024.
//

import Foundation

@MainActor class RunViewModel : SelectedChangedDelegate {
  weak var runModel: RunModel!
  weak var mainViewModel: MainViewModel!

  var distanceSelection: DistanceSelection
  var laneSelection: LaneSelection
  var timeSelection: TimeSelection

  init(_ runModel: RunModel) {
    self.runModel = runModel

    distanceSelection = DistanceSelection()
    laneSelection     = LaneSelection()
    timeSelection     = TimeSelection()

    distanceSelection.delegate = self
  }

  func setMain(mainViewModel: MainViewModel) {
    self.mainViewModel = mainViewModel
  }

  func setDistances(_ distanceArray: [String]) {
    distanceSelection.list     = distanceArray.map { (pickerBugWorkaround: String) in " " + pickerBugWorkaround + " "}
    distanceSelection.selected = distanceSelection.list[0]
  }

  func setNewTimes(_ selectedDistance: String) {
    let timeArray = runModel.timesFor(selectedDistance.trim())
    updateTimes(timeArray, selected: 0)
  }

  func updateTimes(_ timeArray: [String], selected: Int) {
    timeSelection.list     = timeArray
    timeSelection.selected = timeSelection.list[selected]
  }

  func selectedChanged(_ newSelected: String) {
    setNewTimes(newSelected)
  }
}
