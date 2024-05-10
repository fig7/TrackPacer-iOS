//
//  TPDataModel.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 10/05/2024.
//

import Foundation

@MainActor class TPDataModel {
  var distanceSelection: DistanceSelection

  init(distanceSelection: DistanceSelection) {
    self.distanceSelection = distanceSelection
  }
}
