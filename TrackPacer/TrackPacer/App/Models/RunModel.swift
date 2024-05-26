//
//  RunModel.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 25/05/2024.
//

import Foundation

class RunModel {
  private let distanceModel: DistanceModel
  let runModelOK: Bool

  init() {
    self.distanceModel = DistanceModel()

    runModelOK = distanceModel.distanceDataOK
  }

  func distanceArray() -> [String] {
    let distanceManager = distanceModel.distanceManager
    return distanceManager.distanceArray
  }

  func timesFor(_ distance: String) -> [String] {
    let distanceManager = distanceModel.distanceManager
    return distanceManager.timeMap[distance]!
  }
}
