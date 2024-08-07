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
  false,   // Run clockwise
  true,    // Flight mode
  "5:00"   // Ref pace
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
