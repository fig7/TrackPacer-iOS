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
  @Published var milestoneName: String
  @Published var milestoneProgress: Double

  @Published var timeRemaining: Int64? {
    didSet {
      timeToProgress = (timeRemaining == nil) ? 0.0 : min(1.0, (1.0 - (Double(timeRemaining!) / Double(timeRemaining! + elapsedTime))))
    }
  }

  @Published var waitRemaining: Int64 = 0

  @Published var timeToProgress: Double

  init() {
    elapsedTime = 0
    distRun     = 0.0

    milestoneName     = ""
    milestoneProgress = 0.0
    timeRemaining    = nil

    timeToProgress = 0.0
  }

  func resetProgress() {
    elapsedTime = 0
    distRun     = 0.0

    resetWaypointProgress()
  }

  func setElapsedTime(_ elapsedTime: Int64) {
    self.elapsedTime = elapsedTime
  }

  func setDistRun(_ distRun: Double) {
    self.distRun = distRun
  }

  func setMilestoneProgress(_ milestoneName: String, _ milestoneProgress: Double, _ timeRemaining: Int64, _ waitRemaining: Int64) {
    self.milestoneName     = milestoneName
    self.milestoneProgress = milestoneProgress

    self.timeRemaining    = timeRemaining
    self.waitRemaining    = waitRemaining
  }

  func resetWaypointProgress() {
    self.milestoneName     = ""
    self.milestoneProgress = 0.0

    self.timeRemaining = nil
    self.waitRemaining = 0
  }
}
