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
      let totalDist = distanceFor(runDist, runLane)
      totalDistStr  = formatDistance(totalDist)
      runLaps       = rtLaps(runDist, runLane)

      let totalTime = timeFor(runDist, runLane, runTime)
      totalTimeStr = timeToAlmostFullString(timeInMS: totalTime.toLong())

      let totalPace = (1000.0 * totalTime) / totalDist
      totalPaceStr = timeToString(timeInMS: totalPace.toLong())
    }
  }

  var runLane = 1 {
    didSet {
      let totalDist = distanceFor(runDist, runLane)
      totalDistStr  = formatDistance(totalDist)
      runLaps       = rtLaps(runDist, runLane)

      let totalTime = timeFor(runDist, runLane, runTime)
      totalTimeStr = timeToAlmostFullString(timeInMS: totalTime.toLong())

      let totalPace = (1000.0 * totalTime) / totalDist
      totalPaceStr = timeToString(timeInMS: totalPace.toLong())
    }
  }

  var runTime = 0.0 {
    didSet {
      let totalDist = distanceFor(runDist, runLane)
      let totalTime = timeFor(runDist, runLane, runTime)
      totalTimeStr = timeToAlmostFullString(timeInMS: totalTime.toLong())

      let totalPace = (1000.0 * totalTime) / totalDist
      totalPaceStr = timeToString(timeInMS: totalPace.toLong())
    }
  }

  @Published var runLaps = ""
  @Published var totalDistStr = ""

  @Published var totalTimeStr = ""
  @Published var totalPaceStr = ""

  @Published var runProf = "Fixed pace"

  private func formatDistance(_ totalDist: Double) -> String {
    if(runDist == "1 mile") {
      if(runLane == 1) { return runDist } else { return String(format: "%.2f miles", totalDist/1609.34) }
    } else {
      if(runLane == 1) { return String(format: "%dm", totalDist.toInt()) } else { return String(format: "%.2fm", totalDist) }
    }
  }
}
