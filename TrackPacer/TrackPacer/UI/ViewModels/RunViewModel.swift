//
//  RunViewModel.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 12/05/2024.
//

import Foundation

@MainActor class RunViewModel {
  var mainViewModel: MainViewModel!
  var distanceSelection: DistanceSelection
  var laneSelection: LaneSelection

  init() {
    mainViewModel = nil
    distanceSelection = DistanceSelection()
    laneSelection     = LaneSelection()
  }

  func setMain(mainViewModel: MainViewModel) {
    self.mainViewModel = mainViewModel
  }
}
