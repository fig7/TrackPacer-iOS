//
//  PacingOptions.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 13/05/2024.
//

import Foundation

@MainActor class PacingOptions : ObservableObject {
  var runDist = "" {
    didSet {
      totalDist = distanceFor(runDist, runLane)
      totalTime = timeFor(runDist, runLane, runTime)
      runLaps   = rtLaps(runDist, runLane)

      let totalPace = (1000.0 * totalTime) / totalDist
      totalPaceStr = timeToString(timeInMS: totalPace.toLong())
    }
  }

  var runLane = 1 {
    didSet {
      totalDist = distanceFor(runDist, runLane)
      totalTime = timeFor(runDist, runLane, runTime)
      runLaps   = rtLaps(runDist, runLane)

      let totalPace = (1000.0 * totalTime) / totalDist
      totalPaceStr = timeToString(timeInMS: totalPace.toLong())
    }
  }

  var runTime = 0.0 {
    didSet {
      totalTime = timeFor(runDist, runLane, runTime)

      let totalPace = (1000.0 * totalTime) / totalDist
      totalPaceStr = timeToString(timeInMS: totalPace.toLong())
    }
  }

  var totalDist: Double = 0.0 {
    didSet {
      totalDistStr = formatDist(runDist, runLane, totalDist)
    }
  }

  var totalTime: Double = 0.0 {
    didSet {
      totalTimeStr = timeToAlmostFullString(timeInMS: totalTime.toLong())
    }
  }

  @Published var runLaps = ""
  @Published var totalDistStr = ""

  @Published var totalTimeStr = ""
  @Published var totalPaceStr = ""

  @Published var runProf = "Fixed pace"
}
