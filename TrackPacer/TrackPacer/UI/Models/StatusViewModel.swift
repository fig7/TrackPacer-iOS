//
//  StatusViewModel.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 24/05/2024.
//

import Foundation

@MainActor class StatusViewModel {
  var pacingStatus: PacingStatus
  var pacingSettings: PacingSettings

  var screenReceiverActive: Bool

  init() {
    pacingStatus   = PacingStatus()
    pacingSettings = PacingSettings()

    screenReceiverActive = false
  }

  func setPacingStatus(pacingStatus: PacingStatusVal) {
    self.pacingStatus.status = pacingStatus
  }
}
