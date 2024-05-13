//
//  PacingTimes.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 13/05/2024.
//

import SwiftUI

@MainActor class PacingProgress : ObservableObject {
@Published var elapsedTime: Int64

  @Published var distRun: Double
  @Published var waypointName: String
  @Published var waypointProgress: Double

  @Published var timeRemaining: Int64 {
    didSet {
      timeToProgress = min(1.0, (1.0 - (Double(timeRemaining) / Double(timeRemaining + elapsedTime))))
    }
  }
  @Published var timeToProgress: Double

  init() {
    elapsedTime = 0

    distRun = -1.0
    waypointName = "50m"
    waypointProgress = 0.3

    timeRemaining  = 2249000
    timeToProgress = 0.0
  }

  func setElapsedTime(elapsedTime: Int64) {
    self.elapsedTime    = elapsedTime
  }
}
