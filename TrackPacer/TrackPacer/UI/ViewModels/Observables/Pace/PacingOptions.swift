//
//  PacingOptions.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 13/05/2024.
//

import Foundation

@MainActor class PacingOptions : ObservableObject {
  var distAndStart = "" {
    didSet {
      let index1 = distAndStart.lastIndex(of: "(")!
      let index2 = distAndStart.index(after: index1)
      let index3 = distAndStart.lastIndex(of: ")")!

      startType = String(distAndStart[index2 ..< index3])
      baseDist  = String(distAndStart[ ..<index1]).trim()
    }
  }

  var baseDist = "" {
    didSet {
      runDist = distanceFor(baseDist, runLane)
      runTime = timeFor(baseDist, runLane, baseTime)
      runLaps = rtLaps(baseDist, startType, runLane)
    }
  }

  var startType = ""

  var runLane = 1 {
    didSet {
      runDist = distanceFor(baseDist, runLane)
      runTime = timeFor(baseDist, runLane, baseTime)
      runLaps = rtLaps(baseDist, startType, runLane)
    }
  }

  var baseTime = 0.0 {
    didSet {
      runTime = timeFor(baseDist, runLane, baseTime)
    }
  }

  var intvl: Intvl = Intvl.i50m
  var profName: String = "Fixed pace"

  var runDist: Double = 0.0 {
    didSet {
      let totalPace = (1000.0 * runTime) / runDist
      runPaceStr = timeToString(timeInMS: totalPace.toLong(), roundUp: false)
      runDistStr = formatDist(baseDist, runLane, runDist)
    }
  }

  var runTime: Double = 0.0 {
    didSet {
      let totalPace = (1000.0 * runTime) / runDist
      runPaceStr = timeToString(timeInMS: totalPace.toLong(), roundUp: false)
      runTimeStr = timeToAlmostFullString(timeInMS: runTime.toLong())
    }
  }

  var waitingTime: Int64 = 0

  @Published var runLaps = ""
  @Published var runDistStr = ""

  @Published var runTimeStr = ""
  @Published var runPaceStr = ""

  @Published var runProf  = "Fixed pace (50m)" {
    didSet {
      let index1 = runProf.lastIndex(of: "(")!
      let index2 = runProf.index(after: index1)
      let index3 = runProf.lastIndex(of: ")")!

      intvl = intvlFromString(String(runProf[index2 ..< index3]))
      profName = String(runProf[ ..<index1]).trim()
    }
  }
}
