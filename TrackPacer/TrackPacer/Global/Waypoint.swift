//
//  Waypoint.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 27/05/2024.
//

import Foundation

let runDistances = [
  "400m"          :   400.0,
  "400m (Home)"   :   400.0,

  "800m"          :   800.0,
  "800m (Home)"   :   800.0,

  "1000m"         :  1000.0,
  "1000m (Home)"  :  1000.0,
  "1000m (Race)"  :  1000.0,

  "1200m"         :  1200.0,
  "1200m (Home)"  :  1200.0,

  "1500m"         :  1500.0,
  "1500m (Race)"  :  1500.0,

  "2000m"         :  2000.0,
  "2000m (Home)"  :  2000.0,

  "3000m"         :  3000.0,
  "3000m (Home)"  :  3000.0,
  "3000m (Race)"  :  3000.0,

  "4000m"         :  4000.0,
  "4000m (Home)"  :  4000.0,

  "5000m"         :  5000.0,
  "5000m (Home)"  :  5000.0,
  "5000m (Race)"  :  5000.0,
  "5000m (Road)"  :  5000.0,

  "10000m"        : 10000.0,
  "10000m (Home)" : 10000.0,
  "10000m (Road)" : 10000.0,

  "1 mile"        : 1609.34,
  "1 mile (Home)" : 1609.34]

let waypointDistances = [
  "400m"         : (0 ..<   9).map { (i: Int) in  50.0*i.toDouble() },
  "400m (Home)"  : (0 ..<   9).map { (i: Int) in  50.0*i.toDouble() },

  "800m"         : (0 ..<  17).map { (i: Int) in  50.0*i.toDouble() },
  "800m (Home)"  : (0 ..<  17).map { (i: Int) in  50.0*i.toDouble() },

  "1000m"        : (0 ..<  21).map { (i: Int) in  50.0*i.toDouble() },
  "1200m"        : (0 ..<  25).map { (i: Int) in  50.0*i.toDouble() },
  "1500m"        : (0 ..<  31).map { (i: Int) in  50.0*i.toDouble() },
  "2000m"        : (0 ..<  41).map { (i: Int) in  50.0*i.toDouble() },
  "3000m"        : (0 ..<  61).map { (i: Int) in  50.0*i.toDouble() },
  "4000m"        : (0 ..<  81).map { (i: Int) in  50.0*i.toDouble() },

  "5000m"        : (0 ..< 101).map { (i: Int) in  50.0*i.toDouble() },
  "5000m (Home)" : (0 ..< 101).map { (i: Int) in  50.0*i.toDouble() },
  "5000m (Race)" : (0 ..< 101).map { (i: Int) in  50.0*i.toDouble() },
  "5000m (Road)" : (0 ..< 101).map { (i: Int) in  50.0*i.toDouble() },

  "10000m"       : (0 ..< 201).map { (i: Int) in  50.0*i.toDouble() },
  "1 mile"       : (0 ..<  33).map { (i: Int) in  (i == 0) ? 0.0 : 59.34 + 50.0*(i-1).toDouble() }]

let waypointNames = [
  "Start",
  
  "50m", "100m", "150m", "200m", "250m", "300m", "350m",
  
  "Lap 2",  "Lap 3",  "Lap 4",  "Lap 5",  "Lap 6",  "Lap 7",  "Lap 8",  "Lap 9",
  "Lap 10", "Lap 11", "Lap 12", "Lap 13", "Lap 14", "Lap 15", "Lap 16", "Lap 17",
  "Lap 18", "Lap 19", "Lap 20", "Lap 21", "Lap 22", "Lap 23", "Lap 24", "Lap 25",

  "1000m", "2000m", "3000m", "4000m", "5000m", "6000m", "7000m", "8000m", "9000m",

  "Finish", "Silent"]

enum Intvl: String, CaseIterable { case   i50m; case  i100m; case  i200m;  case  i400m; case  i800m; case i1000m; case i1km; case    i2km;
                                   case i1200m; case i1500m; case i2000m;  case i3000m; case i4000m; case i5000m; case i5km; case i10000m; case i10km; case i1mile; }

func intvlFromString(_ intvl: String) -> Intvl {
  var intvl = "i" + intvl
  intvl = intvl.filter { !$0.isWhitespace }
  return Intvl(rawValue: intvl)!
}

func stringFromIntvl(_ intvl: Intvl) -> String {
  let rawValue   = intvl.rawValue
  let startIndex = rawValue.index(rawValue.startIndex, offsetBy: 1)
  return String(rawValue[startIndex...])
}


let fL = waypointNames.size - 2
let sl = waypointNames.size - 1
let waypointsMap =
[
  "400m (Home)"   : [
    Intvl.i50m    : [  0,  1,  2,  3,  4,  5,  6,  7, fL ],

    Intvl.i100m   : [  0, sl,  2, sl,  4, sl,  6, sl, fL ],

    Intvl.i200m   : [  0, sl, sl, sl,  4, sl, sl, sl, fL ],

    Intvl.i400m   : [  0, sl, sl, sl, sl, sl, sl, sl, fL ] ],

  "800m (Home)"   : [
    Intvl.i50m    : [  0,  1,  2,  3,  4,  5,  6,  7,
                       8,  1,  2,  3,  4,  5,  6,  7, fL ],

    Intvl.i100m   : [  0, sl,  2, sl,  4, sl,  6, sl,
                       8, sl,  2, sl,  4, sl,  6, sl, fL ],

    Intvl.i200m   : [  0, sl, sl, sl,  4, sl, sl, sl,
                       8, sl, sl, sl,  4, sl, sl, sl, fL ],

    Intvl.i400m   : [  0, sl, sl, sl, sl, sl, sl, sl,
                       8, sl, sl, sl, sl, sl, sl, sl, fL ],

    Intvl.i800m   : [  0, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl, fL ] ],

  "1000m (Home)"  : [
    Intvl.i50m    : [  0,  1,  2,  3,  4,  5,  6,  7,
                       8,  1,  2,  3,  4,  5,  6,  7,
                       9,  1,  2,  3, fL ],

    Intvl.i100m   : [  0, sl,  2, sl,  4, sl,  6, sl,
                       8, sl,  2, sl,  4, sl,  6, sl,
                       9, sl,  2, sl, fL ],

    Intvl.i200m   : [  0, sl, sl, sl,  4, sl, sl, sl,
                       8, sl, sl, sl,  4, sl, sl, sl,
                       9, sl, sl, sl, fL ],

    Intvl.i400m   : [  0, sl, sl, sl, sl, sl, sl, sl,
                       8, sl, sl, sl, sl, sl, sl, sl,
                       9, sl, sl, sl, fL ],

    Intvl.i800m   : [  0, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                       9, sl, sl, sl, fL ],

    Intvl.i1000m  : [  0, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, fL ] ],

  "1000m (Race)"  : [
    Intvl.i50m    : [  0,  1,  2,  3,
                       8,  1,  2,  3,  4,  5,  6,  7,
                       9,  1,  2,  3,  4,  5,  6,  7, fL ],

    Intvl.i100m   : [  0, sl,  2, sl,
                       8, sl,  2, sl,  4, sl,  6, sl,
                       9, sl,  2, sl,  4, sl,  6, sl, fL ],

    Intvl.i200m   : [  0, sl, sl, sl,
                       8, sl, sl, sl,  4, sl, sl, sl,
                       9, sl, sl, sl,  4, sl, sl, sl, fL ],

    Intvl.i400m   : [  0, sl, sl, sl,
                       8, sl, sl, sl, sl, sl, sl, sl,
                       9, sl, sl, sl, sl, sl, sl, sl, fL ],

    Intvl.i800m   : [  0, sl, sl, sl,
                       8, sl, sl, sl, sl, sl, sl, sl,
                       sl, sl, sl, sl, sl, sl, sl, sl, fL ],

    Intvl.i1000m  : [  0, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl, fL ] ],

  "1200m (Home)"  : [
    Intvl.i50m    : [  0,  1,  2,  3,  4,  5,  6,  7,
                       8,  1,  2,  3,  4,  5,  6,  7,
                       9,  1,  2,  3,  4,  5,  6,  7, fL ],

    Intvl.i100m   : [  0, sl,  2, sl,  4, sl,  6, sl,
                       8, sl,  2, sl,  4, sl,  6, sl,
                       9, sl,  2, sl,  4, sl,  6, sl, fL ],

    Intvl.i200m   : [  0, sl, sl, sl,  4, sl, sl, sl,
                       8, sl, sl, sl,  4, sl, sl, sl,
                       9, sl, sl, sl,  4, sl, sl, sl, fL ],

    Intvl.i400m   : [  0, sl, sl, sl, sl, sl, sl, sl,
                       8, sl, sl, sl, sl, sl, sl, sl,
                       9, sl, sl, sl, sl, sl, sl, sl, fL ],

    Intvl.i800m   : [  0, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                       9, sl, sl, sl, sl, sl, sl, sl, fL ],

    Intvl.i1000m  : [  0, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl,  4, sl, sl, sl, fL ],

    Intvl.i1200m  : [  0, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl, fL ] ],

  "1500m (Race)"  : [
    Intvl.i50m    : [  0,  1,  2,  3,  4,  5,
                       8,  1,  2,  3,  4,  5,  6,  7,
                       9,  1,  2,  3,  4,  5,  6,  7,
                      10,  1,  2,  3,  4,  5,  6,  7, fL ],

    Intvl.i100m   : [  0, sl,  2, sl,  4, sl,
                       8, sl,  2, sl,  4, sl,  6, sl,
                       9, sl,  2, sl,  4, sl,  6, sl,
                      10, sl,  2, sl,  4, sl,  6, sl, fL ],

    Intvl.i200m   : [  0, sl, sl, sl,  4, sl,
                       8, sl, sl, sl,  4, sl, sl, sl,
                       9, sl, sl, sl,  4, sl, sl, sl,
                      10, sl, sl, sl,  4, sl, sl, sl, fL ],

    Intvl.i400m   : [  0, sl, sl, sl, sl, sl,
                       8, sl, sl, sl, sl, sl, sl, sl,
                       9, sl, sl, sl, sl, sl, sl, sl,
                      10, sl, sl, sl, sl, sl, sl, sl, fL ],

    Intvl.i800m   : [  0, sl, sl, sl, sl, sl,
                       8, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      10, sl, sl, sl, sl, sl, sl, sl, fL ],

    Intvl.i1000m  : [  0, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl,  6, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl, fL ],

    Intvl.i1500m  : [  0, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl, fL ] ],

  "2000m (Home)"  : [
    Intvl.i50m    : [  0,  1,  2,  3,  4,  5,  6,  7,
                       8,  1,  2,  3,  4,  5,  6,  7,
                       9,  1,  2,  3,  4,  5,  6,  7,
                      10,  1,  2,  3,  4,  5,  6,  7,
                      11,  1,  2,  3,  4,  5,  6,  7, fL],

    Intvl.i100m   : [  0, sl,  2, sl,  4, sl,  6, sl,
                       8, sl,  2, sl,  4, sl,  6, sl,
                       9, sl,  2, sl,  4, sl,  6, sl,
                      10, sl,  2, sl,  4, sl,  6, sl,
                      11, sl,  2, sl,  4, sl,  6, sl, fL],

    Intvl.i200m   : [  0, sl, sl, sl,  4, sl, sl, sl,
                       8, sl, sl, sl,  4, sl, sl, sl,
                       9, sl, sl, sl,  4, sl, sl, sl,
                      10, sl, sl, sl,  4, sl, sl, sl,
                      11, sl, sl, sl,  4, sl, sl, sl, fL],

    Intvl.i400m   : [  0, sl, sl, sl, sl, sl, sl, sl,
                       8, sl, sl, sl, sl, sl, sl, sl,
                       9, sl, sl, sl, sl, sl, sl, sl,
                      10, sl, sl, sl, sl, sl, sl, sl,
                      11, sl, sl, sl, sl, sl, sl, sl, fL],

    Intvl.i800m   : [  0, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                       9, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      11, sl, sl, sl, sl, sl, sl, sl, fL],

    Intvl.i1000m  : [  0, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl,  4, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl, fL],

    Intvl.i2000m  : [  0, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl, fL] ],

  "3000m (Home)"  : [
    Intvl.i50m    : [  0,  1,  2,  3,  4,  5,  6,  7,
                       8,  1,  2,  3,  4,  5,  6,  7,
                       9,  1,  2,  3,  4,  5,  6,  7,
                      10,  1,  2,  3,  4,  5,  6,  7,
                      11,  1,  2,  3,  4,  5,  6,  7,
                      12,  1,  2,  3,  4,  5,  6,  7,
                      13,  1,  2,  3,  4,  5,  6,  7,
                      14,  1,  2,  3, fL],

    Intvl.i100m   : [  0, sl,  2, sl,  4, sl,  6, sl,
                       8, sl,  2, sl,  4, sl,  6, sl,
                       9, sl,  2, sl,  4, sl,  6, sl,
                      10, sl,  2, sl,  4, sl,  6, sl,
                      11, sl,  2, sl,  4, sl,  6, sl,
                      12, sl,  2, sl,  4, sl,  6, sl,
                      13, sl,  2, sl,  4, sl,  6, sl,
                      14, sl,  2, sl, fL],

    Intvl.i200m   : [  0, sl, sl, sl,  4, sl, sl, sl,
                       8, sl, sl, sl,  4, sl, sl, sl,
                       9, sl, sl, sl,  4, sl, sl, sl,
                      10, sl, sl, sl,  4, sl, sl, sl,
                      11, sl, sl, sl,  4, sl, sl, sl,
                      12, sl, sl, sl,  4, sl, sl, sl,
                      13, sl, sl, sl,  4, sl, sl, sl,
                      14, sl, sl, sl, fL],

    Intvl.i400m   : [  0, sl, sl, sl, sl, sl, sl, sl,
                       8, sl, sl, sl, sl, sl, sl, sl,
                       9, sl, sl, sl, sl, sl, sl, sl,
                      10, sl, sl, sl, sl, sl, sl, sl,
                      11, sl, sl, sl, sl, sl, sl, sl,
                      12, sl, sl, sl, sl, sl, sl, sl,
                      13, sl, sl, sl, sl, sl, sl, sl,
                      14, sl, sl, sl, fL],

    Intvl.i800m   : [  0, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                       9, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      11, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      13, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, fL],

    Intvl.i1000m  : [  0, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl,  4, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      12, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, fL],

    Intvl.i3000m  : [  0, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, fL] ],

  "3000m (Race)"  : [
    Intvl.i50m    : [  0,  1,  2,  3,
                       8,  1,  2,  3,  4,  5,  6,  7,
                       9,  1,  2,  3,  4,  5,  6,  7,
                      10,  1,  2,  3,  4,  5,  6,  7,
                      11,  1,  2,  3,  4,  5,  6,  7,
                      12,  1,  2,  3,  4,  5,  6,  7,
                      13,  1,  2,  3,  4,  5,  6,  7,
                      14,  1,  2,  3,  4,  5,  6,  7, fL],

    Intvl.i100m   : [  0, sl,  2, sl,
                       8, sl,  2, sl,  4, sl,  6, sl,
                       9, sl,  2, sl,  4, sl,  6, sl,
                      10, sl,  2, sl,  4, sl,  6, sl,
                      11, sl,  2, sl,  4, sl,  6, sl,
                      12, sl,  2, sl,  4, sl,  6, sl,
                      13, sl,  2, sl,  4, sl,  6, sl,
                      14, sl,  2, sl,  4, sl,  6, sl, fL],

    Intvl.i200m   : [  0, sl, sl, sl,
                       8, sl, sl, sl,  4, sl, sl, sl,
                       9, sl, sl, sl,  4, sl, sl, sl,
                      10, sl, sl, sl,  4, sl, sl, sl,
                      11, sl, sl, sl,  4, sl, sl, sl,
                      12, sl, sl, sl,  4, sl, sl, sl,
                      13, sl, sl, sl,  4, sl, sl, sl,
                      14, sl, sl, sl,  4, sl, sl, sl, fL],

    Intvl.i400m   : [  0, sl, sl, sl,
                       8, sl, sl, sl, sl, sl, sl, sl,
                       9, sl, sl, sl, sl, sl, sl, sl,
                      10, sl, sl, sl, sl, sl, sl, sl,
                      11, sl, sl, sl, sl, sl, sl, sl,
                      12, sl, sl, sl, sl, sl, sl, sl,
                      13, sl, sl, sl, sl, sl, sl, sl,
                      14, sl, sl, sl, sl, sl, sl, sl, fL],

    Intvl.i800m   : [  0, sl, sl, sl,
                       8, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      10, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      12, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      14, sl, sl, sl, sl, sl, sl, sl, fL],

    Intvl.i1000m  : [  0, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      10, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl,  4, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl, fL],

    Intvl.i3000m  : [  0, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl, fL] ],

  "4000m (Home)"  : [
    Intvl.i50m    : [  0,  1,  2,  3,  4,  5,  6,  7,
                       8,  1,  2,  3,  4,  5,  6,  7,
                       9,  1,  2,  3,  4,  5,  6,  7,
                      10,  1,  2,  3,  4,  5,  6,  7,
                      11,  1,  2,  3,  4,  5,  6,  7,
                      12,  1,  2,  3,  4,  5,  6,  7,
                      13,  1,  2,  3,  4,  5,  6,  7,
                      14,  1,  2,  3,  4,  5,  6,  7,
                      15,  1,  2,  3,  4,  5,  6,  7,
                      16,  1,  2,  3,  4,  5,  6,  7, fL],

    Intvl.i100m   : [  0, sl,  2, sl,  4, sl,  6, sl,
                       8, sl,  2, sl,  4, sl,  6, sl,
                       9, sl,  2, sl,  4, sl,  6, sl,
                      10, sl,  2, sl,  4, sl,  6, sl,
                      11, sl,  2, sl,  4, sl,  6, sl,
                      12, sl,  2, sl,  4, sl,  6, sl,
                      13, sl,  2, sl,  4, sl,  6, sl,
                      14, sl,  2, sl,  4, sl,  6, sl,
                      15, sl,  2, sl,  4, sl,  6, sl,
                      16, sl,  2, sl,  4, sl,  6, sl, fL],

    Intvl.i200m   : [  0, sl, sl, sl,  4, sl, sl, sl,
                       8, sl, sl, sl,  4, sl, sl, sl,
                       9, sl, sl, sl,  4, sl, sl, sl,
                      10, sl, sl, sl,  4, sl, sl, sl,
                      11, sl, sl, sl,  4, sl, sl, sl,
                      12, sl, sl, sl,  4, sl, sl, sl,
                      13, sl, sl, sl,  4, sl, sl, sl,
                      14, sl, sl, sl,  4, sl, sl, sl,
                      15, sl, sl, sl,  4, sl, sl, sl,
                      16, sl, sl, sl,  4, sl, sl, sl, fL],

    Intvl.i400m   : [  0, sl, sl, sl, sl, sl, sl, sl,
                       8, sl, sl, sl, sl, sl, sl, sl,
                       9, sl, sl, sl, sl, sl, sl, sl,
                      10, sl, sl, sl, sl, sl, sl, sl,
                      11, sl, sl, sl, sl, sl, sl, sl,
                      12, sl, sl, sl, sl, sl, sl, sl,
                      13, sl, sl, sl, sl, sl, sl, sl,
                      14, sl, sl, sl, sl, sl, sl, sl,
                      15, sl, sl, sl, sl, sl, sl, sl,
                      16, sl, sl, sl, sl, sl, sl, sl, fL],

    Intvl.i800m   : [  0, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                       9, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      11, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      13, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      15, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl, fL],

    Intvl.i1000m  : [  0, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl,  4, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      12, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl,  4, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl, fL],

    Intvl.i2000m  : [  0, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      12, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl, fL],

    Intvl.i4000m  : [  0, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl, fL] ],

  "5000m (Home)"  : [
    Intvl.i50m    : [  0,  1,  2,  3,  4,  5,  6,  7,
                       8,  1,  2,  3,  4,  5,  6,  7,
                       9,  1,  2,  3,  4,  5,  6,  7,
                      10,  1,  2,  3,  4,  5,  6,  7,
                      11,  1,  2,  3,  4,  5,  6,  7,
                      12,  1,  2,  3,  4,  5,  6,  7,
                      13,  1,  2,  3,  4,  5,  6,  7,
                      14,  1,  2,  3,  4,  5,  6,  7,
                      15,  1,  2,  3,  4,  5,  6,  7,
                      16,  1,  2,  3,  4,  5,  6,  7,
                      17,  1,  2,  3,  4,  5,  6,  7,
                      18,  1,  2,  3,  4,  5,  6,  7,
                      19,  1,  2,  3, fL],

    Intvl.i100m   : [  0, sl,  2, sl,  4, sl,  6, sl,
                       8, sl,  2, sl,  4, sl,  6, sl,
                       9, sl,  2, sl,  4, sl,  6, sl,
                      10, sl,  2, sl,  4, sl,  6, sl,
                      11, sl,  2, sl,  4, sl,  6, sl,
                      12, sl,  2, sl,  4, sl,  6, sl,
                      13, sl,  2, sl,  4, sl,  6, sl,
                      14, sl,  2, sl,  4, sl,  6, sl,
                      15, sl,  2, sl,  4, sl,  6, sl,
                      16, sl,  2, sl,  4, sl,  6, sl,
                      17, sl,  2, sl,  4, sl,  6, sl,
                      18, sl,  2, sl,  4, sl,  6, sl,
                      19, sl,  2, sl, fL],

    Intvl.i200m   : [  0, sl, sl, sl,  4, sl, sl, sl,
                       8, sl, sl, sl,  4, sl, sl, sl,
                       9, sl, sl, sl,  4, sl, sl, sl,
                      10, sl, sl, sl,  4, sl, sl, sl,
                      11, sl, sl, sl,  4, sl, sl, sl,
                      12, sl, sl, sl,  4, sl, sl, sl,
                      13, sl, sl, sl,  4, sl, sl, sl,
                      14, sl, sl, sl,  4, sl, sl, sl,
                      15, sl, sl, sl,  4, sl, sl, sl,
                      16, sl, sl, sl,  4, sl, sl, sl,
                      17, sl, sl, sl,  4, sl, sl, sl,
                      18, sl, sl, sl,  4, sl, sl, sl,
                      19, sl, sl, sl, fL],

    Intvl.i400m   : [  0, sl, sl, sl, sl, sl, sl, sl,
                       8, sl, sl, sl, sl, sl, sl, sl,
                       9, sl, sl, sl, sl, sl, sl, sl,
                      10, sl, sl, sl, sl, sl, sl, sl,
                      11, sl, sl, sl, sl, sl, sl, sl,
                      12, sl, sl, sl, sl, sl, sl, sl,
                      13, sl, sl, sl, sl, sl, sl, sl,
                      14, sl, sl, sl, sl, sl, sl, sl,
                      15, sl, sl, sl, sl, sl, sl, sl,
                      16, sl, sl, sl, sl, sl, sl, sl,
                      17, sl, sl, sl, sl, sl, sl, sl,
                      18, sl, sl, sl, sl, sl, sl, sl,
                      19, sl, sl, sl, fL],

    Intvl.i800m   : [  0, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                       9, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      11, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      13, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      15, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      17, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      19, sl, sl, sl, fL],

    Intvl.i1000m  : [  0, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl,  4, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      12, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl,  4, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      17, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, fL],

    Intvl.i5000m  : [  0, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, fL] ],

  "5000m (Race)"  : [
    Intvl.i50m    : [  0,  1,  2,  3,
                       8,  1,  2,  3,  4,  5,  6,  7,
                       9,  1,  2,  3,  4,  5,  6,  7,
                      10,  1,  2,  3,  4,  5,  6,  7,
                      11,  1,  2,  3,  4,  5,  6,  7,
                      12,  1,  2,  3,  4,  5,  6,  7,
                      13,  1,  2,  3,  4,  5,  6,  7,
                      14,  1,  2,  3,  4,  5,  6,  7,
                      15,  1,  2,  3,  4,  5,  6,  7,
                      16,  1,  2,  3,  4,  5,  6,  7,
                      17,  1,  2,  3,  4,  5,  6,  7,
                      18,  1,  2,  3,  4,  5,  6,  7,
                      19,  1,  2,  3,  4,  5,  6,  7, fL],

    Intvl.i100m   : [  0, sl,  2, sl,
                       8, sl,  2, sl,  4, sl,  6, sl,
                       9, sl,  2, sl,  4, sl,  6, sl,
                      10, sl,  2, sl,  4, sl,  6, sl,
                      11, sl,  2, sl,  4, sl,  6, sl,
                      12, sl,  2, sl,  4, sl,  6, sl,
                      13, sl,  2, sl,  4, sl,  6, sl,
                      14, sl,  2, sl,  4, sl,  6, sl,
                      15, sl,  2, sl,  4, sl,  6, sl,
                      16, sl,  2, sl,  4, sl,  6, sl,
                      17, sl,  2, sl,  4, sl,  6, sl,
                      18, sl,  2, sl,  4, sl,  6, sl,
                      19, sl,  2, sl,  4, sl,  6, sl, fL],

    Intvl.i200m   : [  0, sl, sl, sl,
                       8, sl, sl, sl,  4, sl, sl, sl,
                       9, sl, sl, sl,  4, sl, sl, sl,
                      10, sl, sl, sl,  4, sl, sl, sl,
                      11, sl, sl, sl,  4, sl, sl, sl,
                      12, sl, sl, sl,  4, sl, sl, sl,
                      13, sl, sl, sl,  4, sl, sl, sl,
                      14, sl, sl, sl,  4, sl, sl, sl,
                      15, sl, sl, sl,  4, sl, sl, sl,
                      16, sl, sl, sl,  4, sl, sl, sl,
                      17, sl, sl, sl,  4, sl, sl, sl,
                      18, sl, sl, sl,  4, sl, sl, sl,
                      19, sl, sl, sl,  4, sl, sl, sl, fL],

    Intvl.i400m   : [  0, sl, sl, sl,
                       8, sl, sl, sl, sl, sl, sl, sl,
                       9, sl, sl, sl, sl, sl, sl, sl,
                      10, sl, sl, sl, sl, sl, sl, sl,
                      11, sl, sl, sl, sl, sl, sl, sl,
                      12, sl, sl, sl, sl, sl, sl, sl,
                      13, sl, sl, sl, sl, sl, sl, sl,
                      14, sl, sl, sl, sl, sl, sl, sl,
                      15, sl, sl, sl, sl, sl, sl, sl,
                      16, sl, sl, sl, sl, sl, sl, sl,
                      17, sl, sl, sl, sl, sl, sl, sl,
                      18, sl, sl, sl, sl, sl, sl, sl,
                      19, sl, sl, sl, sl, sl, sl, sl, fL],

    Intvl.i800m   : [  0, sl, sl, sl,
                       8, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      10, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      12, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      14, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      16, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      18, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl, fL],

    Intvl.i1000m  : [  0, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      10, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl,  4, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      15, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl,  4, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl, fL],

    Intvl.i5000m  : [  0, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl, fL] ],

  "5000m (Road)"  : [
    Intvl.i1km    : [  0, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl,
                      32, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl,
                      33, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl,
                      34, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl,
                      35, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, fL ],

    Intvl.i5km    : [  0, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, fL ] ],

  "10000m (Home)" : [
    Intvl.i50m    : [  0,  1,  2,  3,  4,  5,  6,  7,
                       8,  1,  2,  3,  4,  5,  6,  7,
                       9,  1,  2,  3,  4,  5,  6,  7,
                      10,  1,  2,  3,  4,  5,  6,  7,
                      11,  1,  2,  3,  4,  5,  6,  7,
                      12,  1,  2,  3,  4,  5,  6,  7,
                      13,  1,  2,  3,  4,  5,  6,  7,
                      14,  1,  2,  3,  4,  5,  6,  7,
                      15,  1,  2,  3,  4,  5,  6,  7,
                      16,  1,  2,  3,  4,  5,  6,  7,
                      17,  1,  2,  3,  4,  5,  6,  7,
                      18,  1,  2,  3,  4,  5,  6,  7,
                      19,  1,  2,  3,  4,  5,  6,  7,
                      20,  1,  2,  3,  4,  5,  6,  7,
                      21,  1,  2,  3,  4,  5,  6,  7,
                      22,  1,  2,  3,  4,  5,  6,  7,
                      23,  1,  2,  3,  4,  5,  6,  7,
                      24,  1,  2,  3,  4,  5,  6,  7,
                      25,  1,  2,  3,  4,  5,  6,  7,
                      26,  1,  2,  3,  4,  5,  6,  7,
                      27,  1,  2,  3,  4,  5,  6,  7,
                      28,  1,  2,  3,  4,  5,  6,  7,
                      29,  1,  2,  3,  4,  5,  6,  7,
                      30,  1,  2,  3,  4,  5,  6,  7,
                      31,  1,  2,  3,  4,  5,  6,  7, fL],

    Intvl.i100m   : [  0, sl,  2, sl,  4, sl,  6, sl,
                       8, sl,  2, sl,  4, sl,  6, sl,
                       9, sl,  2, sl,  4, sl,  6, sl,
                      10, sl,  2, sl,  4, sl,  6, sl,
                      11, sl,  2, sl,  4, sl,  6, sl,
                      12, sl,  2, sl,  4, sl,  6, sl,
                      13, sl,  2, sl,  4, sl,  6, sl,
                      14, sl,  2, sl,  4, sl,  6, sl,
                      15, sl,  2, sl,  4, sl,  6, sl,
                      16, sl,  2, sl,  4, sl,  6, sl,
                      17, sl,  2, sl,  4, sl,  6, sl,
                      18, sl,  2, sl,  4, sl,  6, sl,
                      19, sl,  2, sl,  4, sl,  6, sl,
                      20, sl,  2, sl,  4, sl,  6, sl,
                      21, sl,  2, sl,  4, sl,  6, sl,
                      22, sl,  2, sl,  4, sl,  6, sl,
                      23, sl,  2, sl,  4, sl,  6, sl,
                      24, sl,  2, sl,  4, sl,  6, sl,
                      25, sl,  2, sl,  4, sl,  6, sl,
                      26, sl,  2, sl,  4, sl,  6, sl,
                      27, sl,  2, sl,  4, sl,  6, sl,
                      28, sl,  2, sl,  4, sl,  6, sl,
                      29, sl,  2, sl,  4, sl,  6, sl,
                      30, sl,  2, sl,  4, sl,  6, sl,
                      31, sl,  2, sl,  4, sl,  6, sl, fL],

    Intvl.i200m   : [  0, sl, sl, sl,  4, sl, sl, sl,
                       8, sl, sl, sl,  4, sl, sl, sl,
                       9, sl, sl, sl,  4, sl, sl, sl,
                      10, sl, sl, sl,  4, sl, sl, sl,
                      11, sl, sl, sl,  4, sl, sl, sl,
                      12, sl, sl, sl,  4, sl, sl, sl,
                      13, sl, sl, sl,  4, sl, sl, sl,
                      14, sl, sl, sl,  4, sl, sl, sl,
                      15, sl, sl, sl,  4, sl, sl, sl,
                      16, sl, sl, sl,  4, sl, sl, sl,
                      17, sl, sl, sl,  4, sl, sl, sl,
                      18, sl, sl, sl,  4, sl, sl, sl,
                      19, sl, sl, sl,  4, sl, sl, sl,
                      20, sl, sl, sl,  4, sl, sl, sl,
                      21, sl, sl, sl,  4, sl, sl, sl,
                      22, sl, sl, sl,  4, sl, sl, sl,
                      23, sl, sl, sl,  4, sl, sl, sl,
                      24, sl, sl, sl,  4, sl, sl, sl,
                      25, sl, sl, sl,  4, sl, sl, sl,
                      26, sl, sl, sl,  4, sl, sl, sl,
                      27, sl, sl, sl,  4, sl, sl, sl,
                      28, sl, sl, sl,  4, sl, sl, sl,
                      29, sl, sl, sl,  4, sl, sl, sl,
                      30, sl, sl, sl,  4, sl, sl, sl,
                      31, sl, sl, sl,  4, sl, sl, sl, fL],

    Intvl.i400m   : [  0, sl, sl, sl, sl, sl, sl, sl,
                       8, sl, sl, sl, sl, sl, sl, sl,
                       9, sl, sl, sl, sl, sl, sl, sl,
                      10, sl, sl, sl, sl, sl, sl, sl,
                      11, sl, sl, sl, sl, sl, sl, sl,
                      12, sl, sl, sl, sl, sl, sl, sl,
                      13, sl, sl, sl, sl, sl, sl, sl,
                      14, sl, sl, sl, sl, sl, sl, sl,
                      15, sl, sl, sl, sl, sl, sl, sl,
                      16, sl, sl, sl, sl, sl, sl, sl,
                      17, sl, sl, sl, sl, sl, sl, sl,
                      18, sl, sl, sl, sl, sl, sl, sl,
                      19, sl, sl, sl, sl, sl, sl, sl,
                      20, sl, sl, sl, sl, sl, sl, sl,
                      21, sl, sl, sl, sl, sl, sl, sl,
                      22, sl, sl, sl, sl, sl, sl, sl,
                      23, sl, sl, sl, sl, sl, sl, sl,
                      24, sl, sl, sl, sl, sl, sl, sl,
                      25, sl, sl, sl, sl, sl, sl, sl,
                      26, sl, sl, sl, sl, sl, sl, sl,
                      27, sl, sl, sl, sl, sl, sl, sl,
                      28, sl, sl, sl, sl, sl, sl, sl,
                      29, sl, sl, sl, sl, sl, sl, sl,
                      30, sl, sl, sl, sl, sl, sl, sl,
                      31, sl, sl, sl, sl, sl, sl, sl, fL],

    Intvl.i800m   : [  0, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                       9, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      11, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      13, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      15, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      17, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      19, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      21, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      23, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      25, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      27, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      29, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      31, sl, sl, sl, sl, sl, sl, sl, fL],

    Intvl.i1000m  : [  0, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl,  4, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      12, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl,  4, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      17, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl,  4, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      22, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl,  4, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      27, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl,  4, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl, fL],

    Intvl.i2000m  : [  0, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      12, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      17, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      22, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      27, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl, fL],

    Intvl.i5000m  : [  0, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl,  4, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl, fL],

    Intvl.i10000m : [  0, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl, fL] ],

  "10000m (Road)" : [
    Intvl.i1km    : [  0, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl,
                      32, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl,
                      33, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl,
                      34, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl,
                      35, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl,
                      36, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl,
                      37, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl,
                      38, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl,
                      39, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl,
                      40, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, fL ],

    Intvl.i2km    : [  0, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl,
                      33, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl,
                      35, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl,
                      37, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl,
                      39, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, fL ],

    Intvl.i5km    : [  0, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl,
                      36, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, fL ],

    Intvl.i10km   : [  0, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, fL ] ],

  "1 mile (Race)" : [
    Intvl.i50m    : [  0,  1,  2,  3,  4,  5,  6,  7,
                       8,  1,  2,  3,  4,  5,  6,  7,
                       9,  1,  2,  3,  4,  5,  6,  7,
                      10,  1,  2,  3,  4,  5,  6,  7, fL],

    Intvl.i100m   : [  0, sl,  2, sl,  4, sl,  6, sl,
                       8, sl,  2, sl,  4, sl,  6, sl,
                       9, sl,  2, sl,  4, sl,  6, sl,
                      10, sl,  2, sl,  4, sl,  6, sl, fL],

    Intvl.i200m   : [  0, sl, sl, sl,  4, sl, sl, sl,
                       8, sl, sl, sl,  4, sl, sl, sl,
                       9, sl, sl, sl,  4, sl, sl, sl,
                      10, sl, sl, sl,  4, sl, sl, sl, fL],

    Intvl.i400m   : [  0, sl, sl, sl, sl, sl, sl, sl,
                       8, sl, sl, sl, sl, sl, sl, sl,
                       9, sl, sl, sl, sl, sl, sl, sl,
                      10, sl, sl, sl, sl, sl, sl, sl, fL],

    Intvl.i800m   : [  0, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                       9, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl, fL],

    Intvl.i1000m  : [  0, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl,  4, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl, fL],

    Intvl.i1mile  : [  0, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl,
                      sl, sl, sl, sl, sl, sl, sl, sl, fL] ]
]

// Also, E.g. 1500m (UP), 1500m (DN), 1500m (UD)
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

func timeFor(_ baseDist: String, _ runLane: Int, _ baseTime: Double) -> Double {
  let runLaneIndex = runLane - 1
  switch baseDist {
  case "1500m":
    // Special case, 1500m is 3.75 laps
    return baseTime * runMultiplier1500[runLaneIndex]

  case "1 mile":
      // Special case, 1 mile is 4 laps + 9.34m
      return baseTime * runMultiplierMile[runLaneIndex]

  default:
    return baseTime * runMultiplier[runLaneIndex]
  }
}

func baseTimeFor(_ baseDist: String, _ runLane: Int, _ setPace: String, _ setTime: Double) -> Double {
  switch setPace
  {
  case "Pace":
    return distanceFor(baseDist, 1) * (setTime / 1000.0)

  case "Goal":
    return setTime

  case "Actual":
    // TODO: Can we avoid scaling down and then back up again?
    // TODO: This will get converted back to actual time, later.
    // TODO: Maybe just have over-loaded setPacingOptions fn?
    // TODO: Possibly tricky with the setter fns. IDK.
    let runLaneIndex = runLane - 1
    switch baseDist {
    case"1500m":
      // Special case, 1500m is 3.75 laps
      return setTime / runMultiplier1500[runLaneIndex]

    case "1 mile":
        // Special case, 1 mile is 4 laps + 9.34m
        return setTime / runMultiplierMile[runLaneIndex]

    default:
      return setTime / runMultiplier[runLaneIndex]
    }

  default:
    fatalError()
  }
}

func waypointsFor(_ distAndStart: String, _ intvl: Intvl) -> [Int] {
    return waypointsMap[distAndStart]![intvl]!
}
