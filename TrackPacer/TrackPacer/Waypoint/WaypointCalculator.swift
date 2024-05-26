//
//  WaypointCalculator.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 22/05/2024.
//

import Foundation

let distanceMap = [
  "400m"   :   400.0,
  "800m"   :   800.0,
  "1000m"  :  1000.0,
  "1200m"  :  1200.0,
  "1500m"  :  1500.0,
  "2000m"  :  2000.0,
  "3000m"  :  3000.0,
  "4000m"  :  4000.0,
  "5000m"  :  5000.0,
  "10000m" : 10000.0,
  "1 mile" : 1609.34]

let waypointMap = [
  "400m"    : (0 ..<   8).map { (i: Int) in  50.0 + 50.0*i.toDouble() },
  "800m"    : (0 ..<  16).map { (i: Int) in  50.0 + 50.0*i.toDouble() },
  "1000m"   : (0 ..<  20).map { (i: Int) in  50.0 + 50.0*i.toDouble() },
  "1200m"   : (0 ..<  24).map { (i: Int) in  50.0 + 50.0*i.toDouble() },
  "1500m"   : (0 ..<  30).map { (i: Int) in  50.0 + 50.0*i.toDouble() },
  "2000m"   : (0 ..<  40).map { (i: Int) in  50.0 + 50.0*i.toDouble() },
  "3000m"   : (0 ..<  60).map { (i: Int) in  50.0 + 50.0*i.toDouble() },
  "4000m"   : (0 ..<  80).map { (i: Int) in  50.0 + 50.0*i.toDouble() },
  "5000m"   : (0 ..< 100).map { (i: Int) in  50.0 + 50.0*i.toDouble() },
  "10000m"  : (0 ..< 200).map { (i: Int) in  50.0 + 50.0*i.toDouble() },
  "1 mile"  : (0 ..<  32).map { (i: Int) in 59.34 + 50.0*i.toDouble() }]

let rDiff        = (0 ..<   8).map { (i: Int) in 1.22*i.toDouble() }
let arcAngle     = [1.358696, 1.358696, 0.424201, 0.0, 1.358696, 1.358696, 0.424201, 0.0]
let arcAngle1500 = [0.424201, 0.0, 1.358696, 1.358696, 0.424201, 0.0, 1.358696, 1.358696]

let runMultiplier = (0 ..< 8).map { (i: Int) in
  let r = 36.8 + rDiff[i]
  return (2.0*Double.pi*r + 168.78)/400.0
}

let runMultiplier1500 = (0 ..< 8).map { (i: Int) in
  let r = 36.8 + rDiff[i]
  return ((Double.pi + 0.424201)*r + 168.78 + (6.0*Double.pi*r) + 506.34)/1500.0
}

let runMultiplierMile = (0 ..< 8).map { (i: Int) in
  let r = 36.8 + rDiff[i]
  return (8.0*Double.pi*r + 675.12 + 9.34)/1609.34
}

func distanceFor(_ runDist: String, _ runLane: Int) -> Double {
  let runLaneIndex = runLane - 1
  switch(runDist) {
  case "1500m":
    // Special case, 1500m is 3.75 laps
    return distanceMap[runDist]! * runMultiplier1500[runLaneIndex]

  case "1 mile":
    // Special case, 1 mile is 4 laps + 9.34m
    return distanceMap[runDist]! * runMultiplierMile[runLaneIndex]

  default:
    return distanceMap[runDist]! * runMultiplier[runLaneIndex]
  }
}

func timeFor(_ runDist: String, _ runLane: Int, _ runTime:Double) -> Double {
  let runLaneIndex = runLane - 1
  switch(runDist) {
  case"1500m":
    // Special case, 1500m is 3.75 laps
    return runTime * runMultiplier1500[runLaneIndex]

  case "1 mile":
      // Special case, 1 mile is 4 laps + 9.34m
      return runTime * runMultiplierMile[runLaneIndex]

  default:
    return runTime * runMultiplier[runLaneIndex]
  }
}

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
