//
//  DistanceModel.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 24/05/2024.
//

import Foundation

private let distanceArray = [
  "400m+         1:30.00,2:00.00",
  "800m+         3:00.00,4:00.00",
  "1000m+        3:45.00,5:00.00",
  "1000m (AS)+   3:45.00,5:00.00",
  "1200m+        4:30.00,6:00.00",
  "1500m+        5:37.50,7:30.00",
  "2000m+        7:30.00,10:00.00",
  "3000m+       11:15.00,15:00.00",
  "3000m (AS)+  11:15.00,15:00.00",
  "4000m+       15:00.00,20:00.00",
  "5000m+       18:45.00,25:00.00",
  "5000m (AS)+  18:45.00,25:00.00",
  "10000m+      37:30.00,50:00.00,60:00.00",
  "1 mile+       6:00.00,8:00.00"]

class DistanceModel {
  let distanceManager = DistanceManager(filesDir: URL.documentsDirectory)
  var distanceDataOK = true

  init() {
    do {
      try distanceManager.initDistances(defaultDistances: distanceArray)
    } catch {
      distanceDataOK = false
      print("Failed to initialize distances. Error: \(error.localizedDescription)")
    }
  }
}
