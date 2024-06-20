//
//  RunModel.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 25/05/2024.
//

import Foundation

class RunModel {
  let distanceModel: DistanceModel
  let runModelOK: Bool

  init() {
    self.distanceModel = DistanceModel()

    runModelOK = distanceModel.distanceDataOK
  }

  func timesFor(_ distance: String) throws -> [String] {
    let distanceManager = distanceModel.distanceManager
    let timeArray = distanceManager.timeMap[distance]

    guard let timeArray else { throw Exception.IllegalArgumentException }
    return timeArray
  }

  func deleteTime(_ editTime: String, _ runDist: String) throws -> ([String], String) {
    let distanceManager = distanceModel.distanceManager

    let newIndex    = try distanceManager.deleteTime(runDist, editTime)
    let newList     = try timesFor(runDist)
    let newSelected = newList[newIndex]
    return (newList, newSelected)
  }

  func addTime(_ newTime: String, _ runDist: String) throws -> ([String], String) {
    let distanceManager = distanceModel.distanceManager

    let newIndex    = try distanceManager.addTime(runDist, newTime)
    let newList     = try timesFor(runDist)
    let newSelected = newList[newIndex]
    return (newList, newSelected)
  }

  func setTime(_ origTime: String, _ newTime: String, _ runDist: String) throws -> ([String], String) {
    let distanceManager = distanceModel.distanceManager

    let newIndex    = try distanceManager.replaceTime(runDist, origTime, newTime)
    let newList     = try timesFor(runDist)
    let newSelected = newList[newIndex]
    return (newList, newSelected)
  }
}
