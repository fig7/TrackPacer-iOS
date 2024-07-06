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
  private var currentWaypoint = -1
  private var currentExtra    = -1.0

  private var totalDist     = -1.0
  private var totalTime     = -1.0
  private var runLaneIndex  = -1

  private func arcExtra() -> Double {
    let arcIndex = (currentWaypoint-1) % 8
    let arcAngle = waypointArcAngle[arcIndex]
    return arcAngle * rDiff[runLaneIndex]
  }

  private func waypointDistance() -> Double {
    return waypointDist[currentWaypoint] + currentExtra
  }

  func waypointTime() -> Double {
    return waypointTimes[currentWaypoint]
  }

  func waypointWait() -> Double {
    return waypointWaits[currentWaypoint].toDouble()
  }

  private mutating func initRunParams(_ runDist: String, _ runLane: Int, _ runTime: Double) {
    waypointDist  = waypointDistances[runDist]!
    runLaneIndex = runLane - 1

    switch(runDist) {
    case "1500m":
      // Special case, 1500m is 3.75 laps
      totalDist = runDistances[runDist]! * runMultiplier1500[runLaneIndex]
      totalTime = runTime * runMultiplier1500[runLaneIndex]
      waypointArcAngle = arcAngle1500

    case "1 mile":
      // Special case, 1 mile is 4 laps + 9.34m
      totalDist = runDistances[runDist]! * runMultiplierMile[runLaneIndex]
      totalTime = runTime * runMultiplierMile[runLaneIndex]
      waypointArcAngle = arcAngle

    default:
      totalDist = runDistances[runDist]! * runMultiplier[runLaneIndex]
      totalTime = runTime * runMultiplier[runLaneIndex]
      waypointArcAngle = arcAngle
    }
  }

  mutating func initRun(_ runDist: String, _ runLane: Int, _ runTime: Double, _ waypoints: [WaypointData]) {
    initRunParams(runDist, runLane, runTime)

    var prevDistance = 0.0
    var prevTime     = 0.0
    let speed = totalDist / totalTime

    currentExtra = 0.0
    waypointTimes = Array(repeating: 0.0, count: waypointDist.count)
    for i in waypointTimes.indices {
      if(i == 0) { continue }

      currentWaypoint = i
      currentExtra += arcExtra()

      let distance = waypointDistance()
      let thisDistance = distance - prevDistance
      waypointTimes[i] = prevTime + (thisDistance / (speed*waypoints[i].scaleFactor))

      prevDistance = distance
      prevTime = waypointTimes[i]
    }

    // The profiles are based on a lane 1 run.
    // If we are not in lane 1, there could be more time spent on the curves, so the times
    // won't add together to give us the required overall pace. A quick fix is to adjust all
    // the times so that the total time matches the time the user has set.
    let normaliseFactor = totalTime / waypointTimes[waypointDist.count-1]
    for i in waypointTimes.indices {
      waypointTimes[i] *= normaliseFactor
    }

    // Add the wait times
    var waitTotal = 0.0
    waypointWaits = waypoints.map { $0.waitTime }
    for i in waypointTimes.indices {
      if(i == 0) { continue }

      waypointTimes[i] = waypointTimes[i] + waitTotal
      waitTotal += waypointWaits[i].toDouble()
    }

    currentWaypoint = 0
    currentExtra    = 0.0
    totalTime += waitTotal
  }

  mutating func initResume(_ runDist: String, _ runLane: Int, _ runTime: Double, _ resumeTime: Double) -> Double {
    initRunParams(runDist, runLane, runTime)

    var prevTime = 0.0
    for i in waypointDist.indices {
      if(i == 0) { continue }

      currentWaypoint = i
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
    return currentWaypoint
  }

  func waypointsRemaining() -> Bool {
    return (currentWaypoint < (waypointDist.size - 1))
  }

  mutating func nextWaypoint() -> (Double, Double) {
    currentWaypoint += 1
    currentExtra += arcExtra()

    return (waypointTime(), waypointWait())
  }

  func runTime() -> Int64 {
    return totalTime.toLong()
  }

  func distOnPace(_ elapsedTime: Double) -> Double {
    if(elapsedTime > totalTime) { return totalDist } else { return (elapsedTime*totalDist)/totalTime }
  }
}
