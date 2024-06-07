//
//  SettingsModel.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 27/05/2024.
//

import Foundation

private let settingsArray: [Any] = [
  "5.00",  // Start delay
  false,   // Power start
  false,   // Quick start
  false,   // Alternate start
  true,    // Flight mode
]

class SettingsModel {
  let settingsManager = SettingsManager(filesDir: URL.documentsDirectory)
  var settingsDataOK = true

  init () {
    do {
      try settingsManager.initSettings(defaultSettings: settingsArray)
    } catch {
      settingsDataOK = false
    }
  }
}
