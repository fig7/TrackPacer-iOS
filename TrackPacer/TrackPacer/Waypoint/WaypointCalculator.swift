//
//  WaypointCalculator.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 22/05/2024.
//

import Foundation

struct WaypointCalculator {
  private var waypointDist: [Double]!
  private var waypointTimes: [Double]!
  private var waypointWaits: [Int64]!
  private var waypointArcAngle: [Double]!

  private var currentIndex = -1
  private var currentExtra = -1.0

  private var runDist = -1.0
  private var runTime = -1.0

  private var waitingTime: Int64 = 0
  private var totalTime          = -1.0

  private var runLaneIndex = -1
  private var prevWaypoint = (-1.0, -1.0)

  private func arcExtra() -> Double {
    let arcIndex = (currentIndex-1) % 8
    let arcAngle = waypointArcAngle[arcIndex]
    return arcAngle * rDiff[runLaneIndex]
  }

  private func waypointDistance() -> Double {
    return waypointDist[currentIndex] + currentExtra
  }

  func waypointTime() -> Double {
    return waypointTimes[currentIndex]
  }

  func waypointWait() -> Double {
    return waypointWaits[currentIndex].toDouble()
  }

  private mutating func initRunParams(_ baseDist: String, _ runLane: Int, _ baseTime: Double) {
    waypointDist  = waypointDistances[baseDist]!
    runLaneIndex = runLane - 1

    switch(baseDist) {
    case "1500m":
      // Special case, 1500m is 3.75 laps
      runDist = runDistances[baseDist]! * runMultiplier1500[runLaneIndex]
      runTime = baseTime * runMultiplier1500[runLaneIndex]
      waypointArcAngle = arcAngle1500

    case "1 mile":
      // Special case, 1 mile is 4 laps + 9.34m
      runDist = runDistances[baseDist]! * runMultiplierMile[runLaneIndex]
      runTime = baseTime * runMultiplierMile[runLaneIndex]
      waypointArcAngle = arcAngle

    default:
      runDist = runDistances[baseDist]! * runMultiplier[runLaneIndex]
      runTime = baseTime * runMultiplier[runLaneIndex]
      waypointArcAngle = arcAngle
    }
  }

  mutating func initRun(_ baseDist: String, _ runLane: Int, _ baseTime: Double, _ waypoints: [WaypointData]) {
    initRunParams(baseDist, runLane, baseTime)

    currentExtra = 0.0
    let runningPace  = runTime / runDist

    let waypointCount = waypoints.count
    waypointTimes     = Array(repeating: 0.0, count: waypointCount)

    var prevDistance = 0.0
    var prevTime     = 0.0
    for i in 0..<waypointCount {
      if(i == 0) { continue }

      currentIndex = i
      currentExtra += arcExtra()

      let distance = waypointDistance()
      let thisDistance = distance - prevDistance
      waypointTimes[i] = prevTime + (thisDistance*runningPace) / waypoints[i].scaleFactor

      prevDistance = distance
      prevTime = waypointTimes[i]
    }

    // The profiles are based on a lane 1 run.
    // If we are not in lane 1, there could be more time spent on the curves, so the times
    // won't add together to give us the required overall pace. A quick fix is to adjust all
    // the times so that the total time matches the time the user has set.
    let normaliseFactor = self.runTime / waypointTimes[waypointCount-1]
    for i in waypointTimes.indices {
      waypointTimes[i] *= normaliseFactor
    }

    // Add the wait times
    waitingTime = 0
    waypointWaits = waypoints.map { $0.waitTime }
    for i in 0..<waypointCount {
      if(i == 0) { continue }

      waypointTimes[i] = waypointTimes[i] + waitingTime.toDouble()
      waitingTime += waypointWaits[i]
    }

    currentIndex = 0
    currentExtra    = 0.0
    prevWaypoint    = (0.0, 0.0)
    totalTime       = runTime + waitingTime.toDouble()
  }

  mutating func initResume(_ runDist: String, _ runLane: Int, _ runTime: Double, _ resumeTime: Double) -> Double {
    initRunParams(runDist, runLane, runTime)

    var prevTime = 0.0
    for i in waypointDist.indices {
      if(i == 0) { continue }

      currentIndex = i
      currentExtra += arcExtra()

      let waypointTime = waypointTime()
      if(waypointTime > resumeTime) {
        break
      }

      prevTime = waypointTime
    }

    return prevTime
  }

  func waypointNum() -> Int {
    return currentIndex
  }

  func waypointsRemaining() -> Bool {
    return (currentIndex < (waypointDist.size - 1))
  }

  mutating func nextWaypoint() -> (Double, Double) {
    prevWaypoint = (waypointTime() + waypointWait(), waypointDistance())

    currentIndex += 1
    currentExtra += arcExtra()

    return (waypointTime(), waypointWait())
  }

  func runTotalTime() -> Int64 {
    return totalTime.toLong()
  }

  func runWaitingTime() -> Int64 {
    return waitingTime
  }

  func distOnPace() -> Double {
    return waypointDistance()
  }

  func distOnPace(_ elapsedTime: Double) -> Double {
    if(elapsedTime > totalTime) { return runDist }

    let legTime = waypointTime()     - prevWaypoint.0
    let legDist = waypointDistance() - prevWaypoint.1
    let legPace = legTime / legDist

    let legElapsed = elapsedTime - prevWaypoint.0
    return prevWaypoint.1 + (legElapsed/legPace)
  }
}
