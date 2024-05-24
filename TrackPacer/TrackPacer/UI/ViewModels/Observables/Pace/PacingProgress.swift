//
//  PacingProgress.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 13/05/2024.
//

import Foundation

@MainActor class PacingProgress : ObservableObject {
  @Published var elapsedTime: Int64

  @Published var distRun: Double
  @Published var waypointName: String
  @Published var waypointProgress: Double

  @Published var timeRemaining: Int64? {
    didSet {
      timeToProgress = (timeRemaining == nil) ? 0.0 : min(1.0, (1.0 - (Double(timeRemaining!) / Double(timeRemaining! + elapsedTime))))
    }
  }
  @Published var timeToProgress: Double

  init() {
    elapsedTime = 0

    distRun = 0.0
    waypointName = ""
    waypointProgress = 0.0

    timeRemaining  = nil
    timeToProgress = 0.0
  }

  func setElapsedTime(_ elapsedTime: Int64) {
    self.elapsedTime = elapsedTime
  }

  func setDistRun(_ distRun: Double) {
    self.distRun = distRun
  }

  func setWaypointProgress(_ waypointName: String, _ waypointProgress: Double, _ timeRemaining: Int64) {
    self.waypointName     = waypointName
    self.waypointProgress = waypointProgress
    self.timeRemaining    = timeRemaining
  }

  func resetWaypointProgress() {
    self.waypointName     = ""
    self.waypointProgress = 0.0
    self.timeRemaining    = nil
  }
}
