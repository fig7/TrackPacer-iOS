//
//  PacingOptions.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 13/05/2024.
//

import Foundation

@MainActor class PacingOptions : ObservableObject {
  @Published var runLane: Int

  @Published var runLaps: String
  @Published var totalDistStr: String

  @Published var runTime: Double
  @Published var totalTimeStr: String
  @Published var totalPaceStr: String

  @Published var runProf: String

  init() {
    runLane = 1

    runLaps = "25 laps"
    totalDistStr = "10000m"

    runTime = 2200.0
    totalTimeStr = "37:30.00"
    totalPaceStr = "3:45"

    runProf = "Fixed pace"
  }

  func setRunLane(runLane: Int) {
    self.runLane = runLane
  }
}
