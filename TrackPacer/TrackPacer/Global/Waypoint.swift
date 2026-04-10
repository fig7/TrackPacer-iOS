//
//  Waypoint.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 27/05/2024.
//

import Foundation

let runDistances = [
  "400m"        :   400.0,
  "800m"        :   800.0,
  "1000m"       :  1000.0,
  "1000m (AS)"  :  1000.0,
  "1200m"       :  1200.0,
  "1500m"       :  1500.0,
  "2000m"       :  2000.0,
  "3000m"       :  3000.0,
  "3000m (AS)"  :  3000.0,
  "4000m"       :  4000.0,
  "5000m"       :  5000.0,
  "5000m (AS)"  :  5000.0,
  "5000m (KM)"  :  5000.0,
  "10000m"      : 10000.0,
  "10000m (KM)" : 10000.0,
  "1 mile"      : 1609.34]

let waypointDistances = [
  "400m"         : (0 ..<   9).map { (i: Int) in  50.0*i.toDouble() },
  "800m"         : (0 ..<  17).map { (i: Int) in  50.0*i.toDouble() },
  "1000m"        : (0 ..<  21).map { (i: Int) in  50.0*i.toDouble() },
  "1000m (AS)"   : (0 ..<  21).map { (i: Int) in  50.0*i.toDouble() },
  "1200m"        : (0 ..<  25).map { (i: Int) in  50.0*i.toDouble() },
  "1500m"        : (0 ..<  31).map { (i: Int) in  50.0*i.toDouble() },
  "2000m"        : (0 ..<  41).map { (i: Int) in  50.0*i.toDouble() },
  "3000m"        : (0 ..<  61).map { (i: Int) in  50.0*i.toDouble() },
  "3000m (AS)"   : (0 ..<  61).map { (i: Int) in  50.0*i.toDouble() },
  "4000m"        : (0 ..<  81).map { (i: Int) in  50.0*i.toDouble() },
  "5000m"        : (0 ..< 101).map { (i: Int) in  50.0*i.toDouble() },
  "5000m (AS)"   : (0 ..< 101).map { (i: Int) in  50.0*i.toDouble() },
  "10000m"       : (0 ..< 201).map { (i: Int) in  50.0*i.toDouble() },
  "1 mile"       : (0 ..<  33).map { (i: Int) in  (i == 0) ? 0.0 : 59.34 + 50.0*(i-1).toDouble() }]

let waypointNames = [
  "Start",
  
  "50m", "100m", "150m", "200m", "250m", "300m", "350m",
  
  "Lap 2",  "Lap 3",  "Lap 4",  "Lap 5",  "Lap 6",  "Lap 7",  "Lap 8",  "Lap 9",
  "Lap 10", "Lap 11", "Lap 12", "Lap 13", "Lap 14", "Lap 15", "Lap 16", "Lap 17",
  "Lap 18", "Lap 19", "Lap 20", "Lap 21", "Lap 22", "Lap 23", "Lap 24", "Lap 25",

  "1000m", "2000m", "3000m", "4000m", "5000m", "6000m", "7000m", "8000m", "9000m",

  "Finish",
  "Silent"]

enum intvl { case I50m; case I100m; case I200m; case I400m; case I800m; case I1000m; }

let fL = waypointNames.size - 2
let sl = waypointNames.size - 1
let waypointsMap =
[ "400m" : [
    intvl.I50m   : [ 0,  1,  2,  3,  4,  5,  6,  7, fL ],
    intvl.I100m  : [ 0, sl,  2, sl,  4, sl,  6, sl, fL ],
    intvl.I200m  : [ 0, sl, sl, sl,  4, sl, sl, sl, fL ],
    intvl.I400m  : [ 0, sl, sl, sl, sl, sl, sl, sl, fL ] ],

  "800m" : [
    intvl.I50m   : [ 0,  1,  2,  3,  4,  5,  6,  7,  8,  1,  2,  3,  4,  5,  6,  7, fL ],
    intvl.I100m  : [ 0, sl,  2, sl,  4, sl,  6, sl,  8, sl,  2, sl,  4, sl,  6, sl, fL ],
    intvl.I200m  : [ 0, sl, sl, sl,  4, sl, sl, sl,  8, sl, sl, sl,  4, sl, sl, sl, fL ],
    intvl.I400m  : [ 0, sl, sl, sl, sl, sl, sl, sl,  8, sl, sl, sl, sl, sl, sl, sl, fL ],
    intvl.I800m  : [ 0, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, fL ] ],

  "1000m" : [
    intvl.I50m   : [ 0,  1,  2,  3,  8,  1,  2,  3,  4,  5,  6,  7,  9,  1,  2,  3,  4,  5,  6,  7, fL ],
    intvl.I100m  : [ 0, sl,  2, sl,  8, sl,  2, sl,  4, sl,  6, sl,  9, sl,  2, sl,  4, sl,  6, sl, fL ],
    intvl.I200m  : [ 0, sl, sl, sl,  8, sl, sl, sl,  4, sl, sl, sl,  9, sl, sl, sl,  4, sl, sl, sl, fL ],
    intvl.I400m  : [ 0, sl, sl, sl, sl, sl, sl, sl,  4, sl, sl, sl, sl, sl, sl, sl,  4, sl, sl, sl, fL ],
    intvl.I800m  : [ 0, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl,  4, sl, sl, sl, fL ],
    intvl.I1000m : [ 0, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, fL ] ],

  "1000m (AS)" : [
    intvl.I50m   : [ 0,  1,  2,  3,  4,  5,  6,  7,  8,  1,  2,  3,  4,  5,  6,  7,  9,  1,  2,  3, fL ],
    intvl.I100m  : [ 0, sl,  2, sl,  4, sl,  6, sl,  8, sl,  2, sl,  4, sl,  6, sl,  9, sl,  2, sl, fL ],
    intvl.I200m  : [ 0, sl, sl, sl,  4, sl, sl, sl,  8, sl, sl, sl,  4, sl, sl, sl,  9, sl, sl, sl, fL ],
    intvl.I400m  : [ 0, sl, sl, sl, sl, sl, sl, sl,  8, sl, sl, sl, sl, sl, sl, sl,  9, sl, sl, sl, fL ],
    intvl.I800m  : [ 0, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl,  9, sl, sl, sl, fL ],
    intvl.I1000m : [ 0, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, fL ] ],

  "1200m" : [
    intvl.I50m   : [ 0,  1,  2,  3,  4,  5,  6,  7,  8,  1,  2,  3,  4,  5,  6,  7,  9,  1,  2,  3,  4,  5,  6,  7, fL ],
    intvl.I100m  : [ 0, sl,  2, sl,  4, sl,  6, sl,  8, sl,  2, sl,  4, sl,  6, sl,  9, sl,  2, sl,  4, sl,  6, sl, fL ],
    intvl.I200m  : [ 0, sl, sl, sl,  4, sl, sl, sl,  8, sl, sl, sl,  4, sl, sl, sl,  9, sl, sl, sl,  4, sl, sl, sl, fL ],
    intvl.I400m  : [ 0, sl, sl, sl, sl, sl, sl, sl,  8, sl, sl, sl, sl, sl, sl, sl,  9, sl, sl, sl, sl, sl, sl, sl, fL ],
    intvl.I800m  : [ 0, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl,  9, sl, sl, sl, sl, sl, sl, sl, fL ],
    intvl.I1000m : [ 0, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl,  4, sl, sl, sl, fL ] ],

  "1500m" : [
    intvl.I50m   : [ 0,  1,  2,  3,  4,  5,  8,  1,  2,  3,  4,  5,  6,  7,  9,  1,  2,  3,  4,  5,  6,  7, 10,  1,  2,  3,  4,  5,  6,  7, fL ],
    intvl.I100m  : [ 0, sl,  2, sl,  4, sl,  8, sl,  2, sl,  4, sl,  6, sl,  9, sl,  2, sl,  4, sl,  6, sl, 10, sl,  2, sl,  4, sl,  6, sl, fL ],
    intvl.I200m  : [ 0, sl, sl, sl,  4, sl,  8, sl, sl, sl,  4, sl, sl, sl,  9, sl, sl, sl,  4, sl, sl, sl, 10, sl, sl, sl,  4, sl, sl, sl, fL ],
    intvl.I400m  : [ 0, sl, sl, sl, sl, sl,  8, sl, sl, sl, sl, sl, sl, sl,  9, sl, sl, sl, sl, sl, sl, sl, 10, sl, sl, sl, sl, sl, sl, sl, fL ],
    intvl.I800m  : [ 0, sl, sl, sl, sl, sl,  8, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, 10, sl, sl, sl, sl, sl, sl, sl, fL ],
    intvl.I1000m : [ 0, sl, sl, sl, sl, sl,  8, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl,  4, sl, sl, sl, fL ],

  "2000m" : [
    intvl.I50m   : [ 0,  1,  2,  3,  4,  5,  6,  7,  8,  1,  2,  3,  4,  5,  6,  7,  9,  1,  2,  3,  4,  5,  6,  7, 10,  1,  2,  3,  4,  5,  6,  7, 11,  1,  2,  3,  4,  5,  6,  7, fL],
    intvl.I100m  : [ 0, sl,  2, sl,  4, sl,  6, sl,  8, sl,  2, sl,  4, sl,  6, sl,  9, sl,  2, sl,  4, sl,  6, sl, 10, sl,  2, sl,  4, sl,  6, sl, 11, sl,  2, sl,  4, sl,  6, sl, fL],
    intvl.I200m  : [ 0, sl, sl, sl,  4, sl, sl, sl,  8, sl, sl, sl,  4, sl, sl, sl,  9, sl, sl, sl,  4, sl, sl, sl, 10, sl, sl, sl,  4, sl, sl, sl, 11, sl, sl, sl,  4, sl, sl, sl, fL],
    intvl.I400m  : [ 0, sl, sl, sl, sl, sl, sl, sl,  8, sl, sl, sl, sl, sl, sl, sl,  9, sl, sl, sl, sl, sl, sl, sl, 10, sl, sl, sl, sl, sl, sl, sl, 11, sl, sl, sl, sl, sl, sl, sl, fL],
    intvl.I800m  : [ 0, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl,  9, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, 11, sl, sl, sl, sl, sl, sl, sl, fL],
    intvl.I1000m : [ 0, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl,  4, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, fL],

  "3000m" : [
    intvl.I50m   : [ 0,  1,  2,  3,  8,  1,  2,  3,  4,  5,  6,  7,  9,  1,  2,  3,  4,  5,  6,  7, 10,  1,  2,  3,  4,  5,  6,  7, 11,  1,  2,  3,  4,  5,  6,  7, 12,  1,  2,  3,  4,  5,  6,  7, 13,  1,  2,  3,  4,  5,  6,  7, 14,  1,  2,  3,  4,  5,  6,  7, fL],
    intvl.I100m  : [ 0, sl,  2, sl,  8, sl,  2, sl,  4, sl,  6, sl,  9, sl,  2, sl,  4, sl,  6, sl, 10, sl,  2, sl,  4, sl,  6, sl, 11, sl,  2, sl,  4, sl,  6, sl, 12, sl,  2, sl,  4, sl,  6, sl, 13, sl,  2, sl,  4, sl,  6, sl, 14, sl,  2, sl,  4, sl,  6, sl, fL],
    intvl.I200m  : [ 0, sl, sl, sl,  8, sl, sl, sl,  4, sl, sl, sl,  9, sl, sl, sl,  4, sl, sl, sl, 10, sl, sl, sl,  4, sl, sl, sl, 11, sl, sl, sl,  4, sl, sl, sl, 12, sl, sl, sl,  4, sl, sl, sl, 13, sl, sl, sl,  4, sl, sl, sl, 14, sl, sl, sl,  4, sl, sl, sl, fL],
    intvl.I400m  : [ 0, sl, sl, sl,  8, sl, sl, sl, sl, sl, sl, sl,  9, sl, sl, sl, sl, sl, sl, sl, 10, sl, sl, sl, sl, sl, sl, sl, 11, sl, sl, sl, sl, sl, sl, sl, 12, sl, sl, sl, sl, sl, sl, sl, 13, sl, sl, sl, sl, sl, sl, sl, 14, sl, sl, sl, sl, sl, sl, sl, fL],
    intvl.I800m  : [ 0, sl, sl, sl,  8, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, 10, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, 12, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, 14, sl, sl, sl, sl, sl, sl, sl, fL],

  "304 00m (AS)" : [ 0, 1, 2, 3, 4, 5, 6, 7,  8, 1 ,2, 3, 4, 5, 6, 7,  9, 1, 2, 3, 4, 5, 6, 7, 10, 1, 2, 3, 4, 5, 6, 7, 11, 1 ,2, 3, 4, 5, 6, 7, 12, 1, 2, 3, 4, 5, 6, 7, 13, 1, 2, 3, 4, 5, 6, 7, 14, 1, 2, 3, fL],

  "4000m"      : [ 0, 1, 2, 3, 4, 5 ,6, 7,  8, 1, 2, 3, 4, 5, 6, 7,  9, 1, 2, 3, 4, 5, 6, 7, 10, 1, 2, 3, 4, 5, 6, 7, 11, 1, 2, 3, 4, 5, 6, 7,
               12, 1, 2, 3, 4, 5 ,6, 7, 13, 1, 2, 3, 4, 5, 6, 7, 14, 1, 2, 3, 4, 5, 6, 7, 15, 1, 2, 3, 4, 5, 6, 7, 16, 1, 2, 3, 4, 5, 6, 7, fL],
  "5000m"      : [             0, 1, 2, 3,  8, 1 ,2, 3, 4, 5, 6, 7,  9, 1, 2, 3, 4, 5, 6, 7, 10, 1, 2, 3, 4, 5, 6, 7, 11, 1, 2, 3, 4, 5, 6, 7,
               12, 1, 2, 3, 4, 5, 6, 7, 13, 1, 2, 3, 4, 5, 6, 7, 14, 1, 2, 3, 4, 5, 6, 7, 15, 1, 2, 3, 4, 5, 6, 7, 16, 1, 2, 3, 4, 5, 6, 7,
               17, 1, 2, 3, 4, 5, 6, 7, 18, 1, 2, 3, 4, 5, 6, 7, 19, 1, 2, 3, 4, 5, 6, 7, fL],
  "5000m (AS)" : [ 0, 1, 2, 3, 4, 5, 6, 7,  8, 1 ,2, 3, 4, 5, 6, 7,  9, 1, 2, 3, 4, 5, 6, 7, 10, 1, 2, 3, 4, 5, 6, 7, 11, 1, 2, 3, 4, 5, 6, 7,
               12, 1, 2, 3, 4, 5, 6, 7, 13, 1, 2, 3, 4, 5, 6, 7, 14, 1, 2, 3, 4, 5, 6, 7, 15, 1, 2, 3, 4, 5, 6, 7, 16, 1, 2, 3, 4, 5, 6, 7,
               17, 1, 2, 3, 4, 5, 6, 7, 18, 1, 2, 3, 4, 5, 6, 7, 19, 1, 2, 3, fL],

  "5000m (KM)" : [ 5 : [  0, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl,
                         32, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl,
                         33, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl,
                         34, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl,
                         35, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, fL ] ],

  "10000m"     : [ 0, 1, 2, 3, 4, 5 ,6, 7,  8, 1, 2, 3, 4, 5, 6, 7,  9, 1, 2, 3, 4, 5, 6, 7, 10, 1, 2, 3, 4, 5, 6, 7, 11, 1, 2, 3, 4, 5, 6, 7,
               12, 1, 2, 3, 4, 5, 6, 7, 13, 1, 2, 3, 4, 5, 6, 7, 14, 1, 2, 3, 4, 5, 6, 7, 15, 1, 2, 3, 4, 5, 6, 7, 16, 1, 2, 3, 4, 5, 6, 7,
               17, 1, 2, 3, 4, 5, 6, 7, 18, 1, 2, 3, 4, 5, 6, 7, 19, 1, 2, 3, 4, 5, 6, 7, 20, 1, 2, 3, 4, 5, 6, 7, 21, 1, 2, 3, 4, 5, 6, 7,
               22, 1, 2, 3, 4, 5, 6, 7, 23, 1, 2, 3, 4, 5, 6, 7, 24, 1, 2, 3, 4, 5, 6, 7, 25, 1, 2, 3, 4, 5, 6, 7, 26, 1, 2, 3, 4, 5, 6, 7,
               27, 1, 2, 3, 4, 5, 6, 7, 28, 1, 2, 3, 4, 5, 6, 7, 29, 1, 2, 3, 4, 5, 6, 7, 30, 1, 2, 3, 4, 5, 6, 7, 31, 1, 2, 3, 4, 5, 6, 7, fL],
  "10000m (KM)" :
  "1 mile"     : [ 0, 1, 2, 3, 4, 5 ,6, 7,  8, 1, 2, 3, 4, 5, 6, 7,  9, 1, 2, 3, 4, 5, 6, 7, 10, 1, 2, 3, 4, 5, 6, 7, fL]]

// Also, E.g. 1500m (UP), 1500m (DN), 1500m (UD)     (for 100m increments perhaps)
// Just add as profiles: e.g. Fixed pace (UP) ?

let rDiff        = (0..<8).map { (i: Int) in 1.22*i.toDouble() }
let arcAngle     = [1.358696, 1.358696, 0.424201, 0.0, 1.358696, 1.358696, 0.424201, 0.0]
let arcAngle1500 = [0.424201, 0.0, 1.358696, 1.358696, 0.424201, 0.0, 1.358696, 1.358696]

let runMultiplier = (0 ..< 8).map { (i: Int) in
  let r = 36.8 + rDiff[i]
  return (2.0*Double.pi*r + 168.78)/400.0
}

let runMultiplier1500 = (0..<8).map { (i: Int) in
  let r = 36.8 + rDiff[i]
  return ((Double.pi + 0.424201)*r + 168.78 + (6.0*Double.pi*r) + 506.34)/1500.0
}

let runMultiplierMile = (0..<8).map { (i: Int) in
  let r = 36.8 + rDiff[i]
  return (8.0*Double.pi*r + 675.12 + 9.34)/1609.34
}

func distanceFor(_ baseDist: String, _ runLane: Int) -> Double {
  let runLaneIndex = runLane - 1
  switch(baseDist) {
  case "1500m":
    // Special case, 1500m is 3.75 laps
    return runDistances[baseDist]! * runMultiplier1500[runLaneIndex]

  case "1 mile":
    // Special case, 1 mile is 4 laps + 9.34m
    return runDistances[baseDist]! * runMultiplierMile[runLaneIndex]

  default:
    return runDistances[baseDist]! * runMultiplier[runLaneIndex]
  }
}

func timeFor(_ baseDist: String, _ runLane: Int, _ baseTime:Double) -> Double {
  let runLaneIndex = runLane - 1
  switch(baseDist) {
  case"1500m":
    // Special case, 1500m is 3.75 laps
    return baseTime * runMultiplier1500[runLaneIndex]

  case "1 mile":
      // Special case, 1 mile is 4 laps + 9.34m
      return baseTime * runMultiplierMile[runLaneIndex]

  default:
    return baseTime * runMultiplier[runLaneIndex]
  }
}

func waypointsFor(_ baseDist: String, _ interval: Int) -> [Int] {
  return waypointsMap[baseDist][interval]!
}
