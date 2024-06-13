//
//  SettingsManager.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 03/06/2024.
//

import Foundation

let settingsVersion = "1.0"

class SettingsManager {
  private let settingsDir: File
  private var currentVersion: String!

  private var settingsData: SettingsData!

  init(filesDir: URL) {
    let filesDir     = File(url: filesDir)
    self.settingsDir = File(file: filesDir, child: "Settings", directoryHint: .isDirectory)
  }

  var startDelay: String   { get { return settingsData.startDelay } }
  var powerStart: Bool     { get { return settingsData.powerStart } }
  var quickStart: Bool     { get { return settingsData.quickStart } }
  var alternateStart: Bool { get { return settingsData.alternateStart } }
  var flightMode: Bool     { get { return settingsData.flightMode } }
  var refPace: String      { get { return settingsData.refPace } }

  func initSettings(defaultSettings: [Any]) throws {
    settingsFromDefaults(defaultSettings)

    if(settingsDir.exists()) {
      try readVersion()
      try readData()

      if(currentVersion != settingsVersion) {
        try updateData()
      }
    } else {
      try initData()
    }
  }

  func setStartDelay(_ startDelay: String) -> Bool {
    var newSettingsData = settingsData!
    if(newSettingsData.startDelay == startDelay) { return true }

    do {
      newSettingsData.startDelay = startDelay
      try writeData(newSettingsData)
    } catch {
      return false
    }

    settingsData.startDelay = startDelay
    return true
  }

  func setPowerStart(_ powerStart: Bool) -> Bool {
    var newSettingsData = settingsData!
    if(newSettingsData.powerStart == powerStart) { return true }

    do {
      newSettingsData.powerStart = powerStart
      try writeData(newSettingsData)
    } catch {
      return false
    }

    settingsData.powerStart = powerStart
    return true
  }

  func setQuickStart(_ quickStart: Bool) -> Bool {
    var newSettingsData = settingsData!
    if(newSettingsData.quickStart == quickStart) { return true }

    do {
      newSettingsData.quickStart = quickStart
      try writeData(newSettingsData)
    } catch {
      return false
    }

    settingsData.quickStart = quickStart
    return true
  }

  func setAlternateStart(_ alternateStart: Bool) -> Bool {
    var newSettingsData = settingsData!
    if(newSettingsData.alternateStart == alternateStart) { return true }

    do {
      newSettingsData.alternateStart = alternateStart
      try writeData(newSettingsData)
    } catch {
      return false
    }

    settingsData.alternateStart = alternateStart
    return true
  }

  func setFlightMode(_ flightMode: Bool) -> Bool {
    // NB Flight mode reminder is not saved
    settingsData.flightMode = flightMode
    return true
  }

  func setRefPace(_ refPace: String) -> Bool {
    var newSettingsData = settingsData!
    if(newSettingsData.refPace == refPace) { return true }

    do {
      newSettingsData.refPace = refPace
      try writeData(newSettingsData)
    } catch {
      return false
    }

    settingsData.refPace = refPace
    return true
  }

  private func readVersion() throws {
    let versionFile = File(file: settingsDir, child: "version.dat", directoryHint: .notDirectory)
    if(!versionFile.exists()) { throw Exception.IOException }

    currentVersion = try versionFile.readText()
  }

  private func writeVersion() throws {
    let versionFile = File(file: settingsDir, child: "version.dat", directoryHint: .notDirectory)
    try versionFile.writeText(settingsVersion)
  }

  private func settingsFromDefaults(_ defaultSettings: [Any]) {
    settingsData = SettingsData()
    settingsData.startDelay     = defaultSettings[0] as! String
    settingsData.powerStart     = defaultSettings[1] as! Bool
    settingsData.quickStart     = defaultSettings[2] as! Bool
    settingsData.alternateStart = defaultSettings[3] as! Bool
    settingsData.flightMode     = defaultSettings[4] as! Bool
    settingsData.refPace        = defaultSettings[5] as! String
  }

  private func initData() throws {
    let success = try settingsDir.mkdir()
    if(!success) { throw FileError.FolderCreationError }

    try writeData()
    try writeVersion()
  }

  private func readData() throws {
    let settingsFile = File(file: settingsDir, child: "settings.dat", directoryHint: .notDirectory)
    let jsonData     = try settingsFile.readData()

    let jsonDecoder   = JSONDecoder()
    settingsData      = try jsonDecoder.decode(SettingsData.self, from: jsonData)

    // Flight mode is not saved
    settingsData.flightMode = true
  }

  private func writeData(_ newSettingsData: SettingsData? = nil) throws {
    let jsonEncoder = JSONEncoder()
    let jsonData: Data?

    // 1.0
    jsonData = try jsonEncoder.encode((newSettingsData != nil) ? newSettingsData : settingsData)

    let settingsFile = File(file: settingsDir, child: "settings.dat", directoryHint: .notDirectory)
    try settingsFile.writeData(jsonData!)
  }

  private func updateData() throws {
    try writeData()
    try writeVersion()
  }
}
