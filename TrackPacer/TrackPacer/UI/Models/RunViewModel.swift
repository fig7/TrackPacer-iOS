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

  init() {
    mainViewModel = nil
    distanceSelection = DistanceSelection()
  }

  func setMain(mainViewModel: MainViewModel) {
    self.mainViewModel = mainViewModel
  }
}
