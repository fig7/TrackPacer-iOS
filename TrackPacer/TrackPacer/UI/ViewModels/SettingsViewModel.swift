//
//  SettingsViewModel.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 03/06/2024.
//

import Foundation

@MainActor class SettingsViewModel : ObservableObject {
  unowned var mainViewModel: MainViewModel!

  @Published var startDelaySS = ""
  @Published var startDelayHH = ""
  @Published var startDelayValid = false

  @Published var powerStart     = false
  @Published var quickStart     = false
  @Published var alternateStart = false
  @Published var flightMode     = false

  @Published var refPaceMM = ""
  @Published var refPaceSS = ""
  @Published var refPaceValid = false

  func setMain(mainViewModel: MainViewModel) {
    self.mainViewModel = mainViewModel
  }

  func setFromSettings(_ settingsManager: SettingsManager) {
    let startDelaySplit = settingsManager.startDelay.split(separator: ".")

    startDelaySS = String(startDelaySplit[0])
    startDelayHH = String(startDelaySplit[1])
    startDelayValid = true

    let refPaceSplit = settingsManager.refPace.split(separator: ":")
    refPaceMM = String(refPaceSplit[0])
    refPaceSS = String(refPaceSplit[1])
    refPaceValid = true

    powerStart     = settingsManager.powerStart
    quickStart     = settingsManager.quickStart
    alternateStart = settingsManager.alternateStart
    flightMode     = settingsManager.flightMode
  }

  func startDelayChanged() {
    startDelayValid = validateSecs(startDelaySS, startDelayHH, 5.0...30.0)
    if(!startDelayValid) { return }

    let startDelayStr = startDelaySS + "." + startDelayHH
    mainViewModel.setStartDelay(startDelayStr)
  }

  func powerStartChanged() {
    mainViewModel.setPowerStart(powerStart)
  }

  func quickStartChanged() {
    mainViewModel.setQuickStart(quickStart)
  }

  func alternateStartChanged() {
    mainViewModel.setAlternateStart(alternateStart)
  }

  func flightModeChanged() {
    mainViewModel.setFlightMode(flightMode)
  }

  func refPaceChanged() {
    refPaceValid = validateMinsSecs(refPaceMM, refPaceSS, 150...900)
    if(!refPaceValid) { return }

    let refPaceStr = refPaceMM + ":" + refPaceSS
    mainViewModel.setRefPace(refPaceStr)
  }

  func validateSecs(_ secsStr: String, _ hthsStr: String, _ secsRange: ClosedRange<Double>) -> Bool {
    if(secsStr.count > 2)  { return false }
    if(hthsStr.count != 2) { return false }

    do {
      let secs = try secsStr.toInt()
      let hths = try hthsStr.toInt()

      let val = Double(secs) + Double(hths)/100.0
      if(secsRange.contains(val)) { return true }
    } catch { }

    return false
  }

  func validateMinsSecs(_ minsStr: String, _ secsStr: String, _ secsRange: ClosedRange<Int>) -> Bool {
    if(minsStr.count > 2)  { return false }
    if(secsStr.count != 2) { return false }

    do {
      let mins = try minsStr.toInt()
      let secs = try secsStr.toInt()
      if(secs > 59) { return false }

      let val = mins*60 + secs
      if(secsRange.contains(val)) { return true }
    } catch { }

    return false
  }
}
