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

  init() {
    mainViewModel = nil
    pacingStatus = PacingStatus()
  }

  func setMain(mainViewModel: MainViewModel) {
    self.mainViewModel = mainViewModel
  }

  func setPacingStatus(pacingStatus: PacingStatusVal) {
    self.pacingStatus.status = pacingStatus
  }
}
