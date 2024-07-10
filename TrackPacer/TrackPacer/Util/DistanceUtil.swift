//
//  DistanceUtil.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 27/05/2024.
//

import Foundation

func formatDist(_ baseDist: String, _ runLane: Int, _ runDist: Double) -> String {
  if(baseDist == "1 mile") {
    if(runLane == 1) { return baseDist } else { return String(format: "%.2f miles", runDist/1609.34) }
  } else {
    if(runLane == 1) { return String(format: "%dm", runDist.toInt()) } else { return String(format: "%.2fm", runDist) }
  }
}
