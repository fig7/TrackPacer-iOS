//
//  SettingsViewModel.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 03/06/2024.
//

import Foundation

@MainActor class SettingsViewModel : ObservableObject {
  unowned var mainViewModel: MainViewModel!

  @Published var startDelay = ""
  @Published var startDelayValid = false

  @Published var powerStart     = false
  @Published var quickStart     = false
  @Published var alternateStart = false
  @Published var flightMode     = false

  func setMain(mainViewModel: MainViewModel) {
    self.mainViewModel = mainViewModel
  }

  func setFromSettings(_ settingsManager: SettingsManager) {
    startDelay      = settingsManager.startDelay
    startDelayValid = true

    powerStart     = settingsManager.powerStart
    quickStart     = settingsManager.quickStart
    alternateStart = settingsManager.alternateStart
    flightMode     = settingsManager.flightMode
  }

  func startDelayChanged() {
    var updated = startDelay
    if(updated.isEmpty) {
      startDelayValid = false
      return
    }

    updated = startDelay.filter { "0123456789.".contains($0) }
    while(updated.first == "0") {
      let startIndex = updated.startIndex;
      updated.remove(at: startIndex)
    }

    updated = String(updated.prefix(5))
    var dpRanges = updated.ranges(of: ".")
    while(dpRanges.count > 1) {
      updated.remove(at: dpRanges[dpRanges.count - 1].lowerBound)
      dpRanges = updated.ranges(of: ".")
    }

    if(dpRanges.count > 0) {
      let dpIndex = dpRanges[0].lowerBound
      var count = updated[dpIndex...].count - 1
      if(count == 0) {
        startDelayValid = false
        startDelay      = updated
        return
      }

      while(count > 2) {
        let lastIndex = updated.index(before: updated.endIndex)
        updated.remove(at: lastIndex)

        count = updated[dpIndex...].count - 1
      }
    }

    do {
      let startDelayVal = try updated.toDouble()
      startDelayValid = ((startDelayVal >= 5.0) && (startDelayVal <= 30.0))
      if(startDelayValid) { mainViewModel.setStartDelay(String(format: "%.2f", startDelayVal)) }
    } catch { startDelayValid = false }

    startDelay = updated
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
}
