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

  init() {
    pacingStatus   = PacingStatus()
    pacingSettings = PacingSettings()
  }

  func setFromSettings(_ settingsManager: SettingsManager) {
    pacingSettings.startDelay     = settingsManager.startDelay
    pacingSettings.powerStart     = settingsManager.powerStart
    pacingSettings.quickStart     = settingsManager.quickStart
    pacingSettings.alternateStart = settingsManager.alternateStart
  }
}
