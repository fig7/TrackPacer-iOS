//
//  DistanceManager.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 24/05/2024.
//

import Foundation

private let distanceVersion = "1.3"

enum DistanceError : Error { case VersionError }

class DistanceManager {
  private let filesDir: File
  private let distanceDir: File

  var distanceArray: [String]!
  var timeMap: [String : [String]] = [:]

  private var currentVersion: String!

  init(filesDir: URL) {
    self.filesDir    = File(url: filesDir)
    self.distanceDir = File(file: self.filesDir, child: "Data", directoryHint: .isDirectory)
  }

  func initDistances(defaultDistances: [String]) throws {
    if(distanceDir.exists()) {
      try readVersion()
      try readData()

      if(currentVersion != distanceVersion) {
        try updateData(defaultDistances: defaultDistances)
      }
    } else {
      try initData(defaultDistances)
    }
  }

  private func readVersion() throws {
    let versionFile = File(file: distanceDir, child: "version.dat", directoryHint: .notDirectory)
    if(!versionFile.exists()) { throw FileError.FileReadError }

    currentVersion = try versionFile.readText()
  }

  private func writeVersion() throws {
    let versionFile = File(file: distanceDir, child: "version.dat", directoryHint: .notDirectory)
    try versionFile.writeText(distanceVersion)
  }

  private func initData(_ defaultDistances: [String]) throws {
    let success = try distanceDir.mkdir()
    if(!success) { throw FileError.FolderCreationError }

    distanceArray = (0 ..< defaultDistances.size).map { (i: Int) in String(defaultDistances[i].split(separator: "+")[0]) }
    for (i, runDistance) in distanceArray.enumerated() {
      timeMap[runDistance] = String(defaultDistances[i].split(separator: "+")[1]).trim().split(separator: ",").map(String.init)
    }

    try writeData()
    try writeVersion()
  }

  private func readData() throws {
    let folderList = try distanceDir.list()
    let distanceFilter = { (distance: String) in distance.starts(with: "Distance") }

    var folderArray = folderList.filter(distanceFilter)
    folderArray.sort()
    distanceArray = [String](repeating: "", count: folderArray.size)

    for (i, distance) in folderArray.enumerated() {
      let runDistance  = distance.substring(13)
      distanceArray[i] = runDistance

      let distanceDir = File(file: distanceDir, child: distance, directoryHint: .isDirectory)
      let timesFile = File(file: distanceDir, child: "times.dat", directoryHint: .notDirectory)
      let timesStr  = try timesFile.readText()
      timeMap[runDistance] = timesStr.split(separator: ",").map(String.init)
    }
  }

  private func writeData(_ distance: String) throws {
    let i = distanceArray.firstIndex(of: distance)
    guard let i else { throw Exception.IllegalArgumentException }

    let prefix = String(format: "Distance_%03d_", i)
    let distanceDir = File(file: distanceDir, child: prefix + distance, directoryHint: .isDirectory)
    if(!distanceDir.exists()) {
      let success = try distanceDir.mkdir()
      if(!success) { throw Exception.IOException }
    }

    let timesFile = File(file: distanceDir, child: "times.dat", directoryHint: .notDirectory)
    let timeStr = timeMap[distance]!.joined(separator: ",")
    try timesFile.writeText(timeStr)
  }

  private func writeData() throws {
    for (i, distance) in distanceArray.enumerated() {
      let prefix = String(format: "Distance_%03d_", i)
      let distanceDir = File(file: distanceDir, child: prefix + distance, directoryHint: .isDirectory)
      if(!distanceDir.exists()) {
        let success = try distanceDir.mkdir()
        if(!success) { throw FileError.FolderCreationError }
      }

      let timesFile = File(file: distanceDir, child: "times.dat", directoryHint: .notDirectory)
      let timeStr = timeMap[distance]!.joined(separator: ",")
      try timesFile.writeText(timeStr)
    }
  }

  private func updateData(defaultDistances: [String]) throws {
    throw DistanceError.VersionError
  }

  private func timeGreaterThan(time1: String, time2: String) throws -> Bool {
    let time1Split = time1.split(separator: ":")
    let time1Split0 = try String(time1Split[0]).trim().toLong()
    let time1Split1 = try String(time1Split[1]).toDouble()
    let time1Dbl = 1000.0*(time1Split0.toDouble()*60.0 + time1Split1)

    let time2Split = time2.split(separator: ":")
    let time2Split0 = try String(time2Split[0]).trim().toLong()
    let time2Split1 = try String(time2Split[1]).toDouble()
    let time2Dbl = 1000.0*(time2Split0.toDouble()*60.0 + time2Split1)
    return (time1Dbl > time2Dbl)
  }


  func deleteTime(_ runDistance: String, _ runTime: String?) throws -> Int {
    guard let runTime else { throw Exception.IllegalArgumentException }

    let timeArray = timeMap[runDistance]
    guard let timeArray else { throw Exception.IllegalArgumentException }
    if(!timeArray.contains(runTime)) { throw Exception.IllegalArgumentException }

    var i = 0
    var newIndex = -1
    var newTimeArray = [String](repeating: "", count: timeArray.size-1)
    for time in timeArray {
      if(time == runTime) {
        newIndex = i-1
        if(newIndex < 0) { newIndex = 0 }

        continue
      }

      newTimeArray[i] = time
      i += 1
    }

    timeMap[runDistance] = newTimeArray
    try writeData(runDistance)

    return newIndex
  }

  func addTime(_ runDistance: String, _ runTime: String?) throws -> Int {
    guard let runTime else { throw Exception.IllegalArgumentException }

    let timeArray = timeMap[runDistance]
    guard let timeArray else { throw Exception.IllegalArgumentException }
    if(timeArray.contains(runTime)) { throw Exception.IllegalArgumentException }

    var i = 0
    var j = 0
    var newTimeArray = [String](repeating: "", count: timeArray.size+1)
    while(i < timeArray.size) {
      let time = timeArray[i]
      if(try timeGreaterThan(time1: time, time2: runTime)) { break }

      newTimeArray[j] = time
      i += 1; j += 1
    }

    let newIndex = j
    newTimeArray[j] = runTime
    j += 1

    while(i < timeArray.size) {
      newTimeArray[j] = timeArray[i]
      i += 1; j += 1
    }

    timeMap[runDistance] = newTimeArray
    try writeData(runDistance)

    return newIndex
  }

  func replaceTime(_ runDistance: String, _ origTime: String?, _ newTime: String?) throws -> Int {
    guard let origTime, let newTime else { throw Exception.IllegalArgumentException }

    let timeArray = timeMap[runDistance]
    guard let timeArray else { throw Exception.IllegalArgumentException }
    if(!timeArray.contains(origTime)) { throw Exception.IllegalArgumentException }
    if(timeArray.contains(newTime))   { throw Exception.IllegalArgumentException }

    var i = 0
    var j = 0
    var newTimeArray = [String](repeating: "", count: timeArray.size)
    while(i < timeArray.size) {
      let time = timeArray[i]
      if(try timeGreaterThan(time1: time, time2: newTime)) { break }

      i += 1
      if(time == origTime) { continue }

      newTimeArray[j] = time
      j += 1
    }

    let newIndex = j
    newTimeArray[j] = newTime
    j += 1

    while(i < timeArray.size) {
      let time = timeArray[i]

      i += 1
      if(time == origTime) { continue }

      newTimeArray[j] = time
      j += 1
    }

    timeMap[runDistance] = newTimeArray
    try writeData(runDistance)

    return newIndex
  }
}
