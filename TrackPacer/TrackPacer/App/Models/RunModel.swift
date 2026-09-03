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
    distanceModel = DistanceModel()
    runModelOK    = distanceModel.distanceDataOK
  }

  func timesFor(_ baseDist: String, _ runPace: String) throws -> [String] {
    let distanceManager = distanceModel.distanceManager
    let timeArray = distanceManager.timeMap[baseDist]![runPace]!

    var formattedTimeArray: [String] = []
    for time in timeArray {
      let timeSplit = time.split(separator: ":")
      let spacer: String
      if(timeSplit.count == 1) {
        spacer = "     "
      } else if(timeSplit[0].count == 1) {
        spacer = "  "
      } else {
        spacer = ""
      }

      let formattedTime = spacer + time
      formattedTimeArray.append(formattedTime)
    }

    return formattedTimeArray
  }

  func deleteTime(_ editTime: String, _ baseDist: String, _ runPace: String) throws -> ([String], String) {
    let distanceManager = distanceModel.distanceManager

    let newIndex    = try distanceManager.deleteTime(baseDist, runPace, editTime)
    let newList     = try timesFor(baseDist, runPace)
    let newSelected = newList[newIndex]
    return (newList, newSelected)
  }

  func addTime(_ newTime: String, _ baseDist: String, _ runPace: String) throws -> ([String], String) {
    let distanceManager = distanceModel.distanceManager

    let newIndex    = try distanceManager.addTime(baseDist, runPace, newTime)
    let newList     = try timesFor(baseDist, runPace)
    let newSelected = newList[newIndex]
    return (newList, newSelected)
  }

  func setTime(_ origTime: String, _ newTime: String, _ baseDist: String, _ runPace: String) throws -> ([String], String) {
    let distanceManager = distanceModel.distanceManager

    let newIndex    = try distanceManager.replaceTime(baseDist, runPace, origTime, newTime)
    let newList     = try timesFor(baseDist, runPace)
    let newSelected = newList[newIndex]
    return (newList, newSelected)
  }
}
