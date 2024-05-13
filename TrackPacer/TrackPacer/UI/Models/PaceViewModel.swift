//
//  PaceViewModel.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 12/05/2024.
//

import Foundation

@MainActor class PaceViewModel {
  var mainViewModel: MainViewModel!
  var pacingStatus: PacingStatus
  var pacingOptions: PacingOptions
  var pacingProgress: PacingProgress

  init() {
    mainViewModel = nil
    pacingStatus   = PacingStatus()
    pacingOptions  = PacingOptions()
    pacingProgress = PacingProgress()
  }

  func setMain(mainViewModel: MainViewModel) {
    self.mainViewModel = mainViewModel
  }

  func setPacingStatus(pacingStatus: PacingStatusVal) {
    self.pacingStatus.status = pacingStatus
  }
}
