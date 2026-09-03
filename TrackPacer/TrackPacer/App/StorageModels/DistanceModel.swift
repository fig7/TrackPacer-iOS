//
//  DistanceModel.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 24/05/2024.
//

import Foundation

private let defaultDistArray = [
  [ "Dist"   : "400m",
    "Pace"   : ["2:30.00", "3:30.00", "4:30.00"],
    "Goal"   : ["1:30.00", "2:00.00"],
    "Actual" : ["1:30.00", "2:00.00"] ],

  [ "Dist"   : "800m",
    "Pace"   : ["3:00.00", "4:00.00", "5:00.00"],
    "Goal"   : ["3:00.00", "4:00.00"],
    "Actual" : ["3:00.00", "4:00.00"] ],

  [ "Dist"   : "1000m",
    "Pace"   : ["3:00.00", "4:00.00", "5:00.00"],
    "Goal"   : ["3:45.00", "5:00.00"],
    "Actual" : ["3:45.00", "5:00.00"] ],

  [ "Dist"   : "1200m",
    "Pace"   : ["3:30.00", " 4:00.00", "5:00.00"],
    "Goal"   : ["4:30.00", " 6:00.00"],
    "Actual" : ["4:30.00", " 6:00.00"] ],

  [ "Dist"   : "1500m",
    "Pace"   : ["3:30.00", "4:00.00", "5:00.00"],
    "Goal"   : ["5:37.50", "7:30.00"],
    "Actual" : ["5:37.50", "7:30.00"] ],

  [ "Dist"   : "2000m",
    "Pace"   : ["3:45.00", "4:30.00",  "6:00.00"],
    "Goal"   : ["7:30.00", "10:00.00", "12:00.00"],
    "Actual" : ["7:30.00", "10:00.00", "12:00.00"] ],

  [ "Dist"   : "3000m",
    "Pace"   : ["3:45.00",  "4:30.00",  "6:00.00"],
    "Goal"   : ["11:15.00", "15:00.00", "18:00.00"],
    "Actual" : ["11:15.00", "15:00.00", "18:00.00"] ],

  [ "Dist"   : "4000m",
    "Pace"   : ["3:45.00",  "4:30.00",  "6:00.00"],
    "Goal"   : ["15:00.00", "20:00.00", "24:00.00"],
    "Actual" : ["15:00.00", "20:00.00", "24:00.00"] ],

  [ "Dist"   : "5000m",
    "Pace"   : ["4:00.00",  "5:00.00",  "6:00.00"],
    "Goal"   : ["18:45.00", "25:00.00", "30:00.00"],
    "Actual" : ["18:45.00", "25:00.00", "30:00.00"] ],

  [ "Dist"   : "10000m",
    "Pace"   : ["4:30.00",  "6:00.00",  "7:00.00"],
    "Goal"   : ["37:30.00", "50:00.00", "60:00.00"],
    "Actual" : ["37:30.00", "50:00.00", "60:00.00"] ],

  [ "Dist"   : "1 mile",
    "Pace"   : ["3:30.00", "4:00.00",  "5:00.00"],
    "Goal"   : ["6:00.00", "8:00.00", "10:00.00"],
    "Actual" : ["6:00.00", "8:00.00", "10:00.00"] ]
]

class DistanceModel {
  let distanceManager = DistanceManager(filesDir: URL.documentsDirectory)
  var distanceDataOK = true

  init() {
    do {
      try distanceManager.initDistances(defaultDistArray)
    } catch {
      distanceDataOK = false
      print("Failed to initialize distances. Error: \(error.localizedDescription)")
    }
  }
}
