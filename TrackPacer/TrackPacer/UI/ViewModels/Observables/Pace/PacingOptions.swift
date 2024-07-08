//
//  PacingOptions.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 13/05/2024.
//

import Foundation

@MainActor class PacingOptions : ObservableObject {
  var baseDist = "" {
    didSet {
      runDist = distanceFor(baseDist, runLane)
      runTime = timeFor(baseDist, runLane, baseTime)
      runLaps   = rtLaps(baseDist, runLane)

      let totalPace = (1000.0 * runTime) / runDist
      runPaceStr = timeToString(timeInMS: totalPace.toLong())
    }
  }

  var runLane = 1 {
    didSet {
      runDist = distanceFor(baseDist, runLane)
      runTime = timeFor(baseDist, runLane, baseTime)
      runLaps   = rtLaps(baseDist, runLane)

      let totalPace = (1000.0 * runTime) / runDist
      runPaceStr = timeToString(timeInMS: totalPace.toLong())
    }
  }

  var baseTime = 0.0 {
    didSet {
      runTime = timeFor(baseDist, runLane, baseTime)

      let totalPace = (1000.0 * runTime) / runDist
      runPaceStr = timeToString(timeInMS: totalPace.toLong())
    }
  }

  var runDist: Double = 0.0 {
    didSet {
      runDistStr = formatDist(baseDist, runLane, runDist)
    }
  }

  var runTime: Double = 0.0 {
    didSet {
      runTimeStr = timeToAlmostFullString(timeInMS: runTime.toLong())
    }
  }

  @Published var runLaps = ""
  @Published var runDistStr = ""

  @Published var runTimeStr = ""
  @Published var runPaceStr = ""

  @Published var runProf = "Fixed pace"
}
