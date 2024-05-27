//
//  WaypointCalculator.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 22/05/2024.
//

import Foundation

class WaypointCalculator {
  private var waypointList: [Double]!
  private var waypointArcAngle: [Double]!
  private var currentWaypoint = -1
  private var currentExtra    = -1.0

  private var totalDist     = -1.0
  private var totalTime     = -1.0
  private var runLaneIndex  = -1

  private func arcExtra() -> Double {
    let arcIndex = currentWaypoint % 8
    let arcAngle = waypointArcAngle[arcIndex]
    return arcAngle * rDiff[runLaneIndex]
  }

  private func waypointDistance() -> Double {
    return waypointList[currentWaypoint] + currentExtra
  }

  func waypointTime() -> Double {
    return (waypointDistance() * totalTime) / totalDist
  }

  private func initRunParams(_ runDist: String, _ runLane: Int, _ runTime: Double) {
    runLaneIndex = runLane - 1
    waypointList = waypointMap[runDist]!

    switch(runDist) {
    case "1500m":
      // Special case, 1500m is 3.75 laps
      totalDist = distanceMap[runDist]! * runMultiplier1500[runLaneIndex]
      totalTime = runTime * runMultiplier1500[runLaneIndex]
      waypointArcAngle = arcAngle1500

    case "1 mile":
      // Special case, 1 mile is 4 laps + 9.34m
      totalDist = distanceMap[runDist]! * runMultiplierMile[runLaneIndex]
      totalTime = runTime * runMultiplierMile[runLaneIndex]
      waypointArcAngle = arcAngle

    default:
      totalDist = distanceMap[runDist]! * runMultiplier[runLaneIndex]
      totalTime = runTime * runMultiplier[runLaneIndex]
      waypointArcAngle = arcAngle
    }
  }

  func initRun(_ runDist: String, _ runLane: Int, _ runTime: Double) {
    initRunParams(runDist, runLane, runTime)

    currentWaypoint = 0
    currentExtra    = arcExtra()
    // Log.d("TP", totalDistance.toString())
    // Log.d("TP", totalTime.toString())

    // Log.d("TP", waypointTime().toString())
  }

  func initResume(_ runDist: String, _ runLane: Int, _ runTime: Double, _ resumeTime: Double) -> Double {
    initRunParams(runDist, runLane, runTime)

    var prevTime = 0.0
    for i in waypointList.indices {
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
    return (currentWaypoint < (waypointList.size - 1))
  }

  func nextWaypoint() -> Double {
    // val waypoint1 = waypointTime()
    currentWaypoint += 1
    currentExtra += arcExtra()

    // Log.d("TP", (waypointTime()-waypoint1).toString())
    return waypointTime()
  }

  func runTime() -> Int64 {
    return totalTime.toLong()
  }

  func distOnPace(_ elapsedTime: Double) -> Double {
    if(elapsedTime > totalTime) { return totalDist } else { return (elapsedTime*totalDist)/totalTime }
  }
}
