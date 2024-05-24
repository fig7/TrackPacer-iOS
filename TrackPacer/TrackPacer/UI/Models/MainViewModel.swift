//
//  MainViewModel.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 10/05/2024.
//

import Foundation

@MainActor class MainViewModel {
  var runViewModel: RunViewModel
  var paceViewModel: PaceViewModel
  var statusViewModel: StatusViewModel

  init() {
    runViewModel    = RunViewModel()
    paceViewModel   = PaceViewModel()
    statusViewModel = StatusViewModel()

    runViewModel.setMain(mainViewModel: self)
    paceViewModel.setMain(mainViewModel: self)
  }

  func handleIncomingIntent(begin: Bool, silent: Bool) {
    let pacingStatus = statusViewModel.pacingStatus.status
    if(begin) {
      if(pacingStatus != .PacingWait) { return }
      paceViewModel.powerStart()
    } else {
      switch(pacingStatus) {
      case .NotPacing, .PacingPaused:
        return

      case .Pacing:
        paceViewModel.pausePacing(silent: silent)

      default:
        paceViewModel.stopPacing(silent: silent)
      }
    }
  }
}
