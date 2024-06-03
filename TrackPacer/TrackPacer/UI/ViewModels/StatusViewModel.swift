//
//  StatusViewModel.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 24/05/2024.
//

import Foundation

@MainActor class StatusViewModel : ObservableObject {
  var pacingStatus: PacingStatus
  var pacingSettings: PacingSettings

  var screenReceiverActive: Bool

  init() {
    pacingStatus   = PacingStatus()
    pacingSettings = PacingSettings()

    screenReceiverActive = false
  }

  func setFromSettings(_ settingsManager: SettingsManager) {
    pacingSettings.startDelay = settingsManager.startDelay
    pacingSettings.powerStart = settingsManager.powerStart
    pacingSettings.quickStart = settingsManager.quickStart
  }

  func setPacingStatus(pacingStatus: PacingStatusVal) {
    self.pacingStatus.status = pacingStatus
  }
}
