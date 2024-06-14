//
//  DistanceUtil.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 27/05/2024.
//

import Foundation

func formatDist(_ runDist: String, _ runLane: Int, _ totalDist: Double) -> String {
  if(runDist == "1 mile") {
    if(runLane == 1) { return runDist } else { return String(format: "%.2f miles", totalDist/1609.34) }
  } else {
    if(runLane == 1) { return String(format: "%dm", totalDist.toInt()) } else { return String(format: "%.2fm", totalDist) }
  }
}

func hasAlternateStart(_ runDist: String) -> Bool {
  return ["1000m", "3000m", "5000m"].contains(runDist)
}
