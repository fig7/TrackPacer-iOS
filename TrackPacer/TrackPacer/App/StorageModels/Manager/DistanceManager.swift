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
  private let distanceDir: File

  var distanceArray: [String]!
  var timeMap: [String : [String]] = [:]
  var profileMap: [String : [(String, [WaypointData])]] = [:]

  private var currentVersion: String!

  init(filesDir: URL) {
    let filesDir     = File(url: filesDir)
    self.distanceDir = File(file: filesDir, child: "Data", directoryHint: .isDirectory)
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

      var profileWaypoints: [WaypointData] = []
      for _ in 0..<waypointDistances[runDistance]!.count { profileWaypoints.append(WaypointData()) }
      profileMap[runDistance] = [("Fixed pace", profileWaypoints)]
    }

    try writeData()
    try writeVersion()
  }

  private func readData() throws {
    var folderList = try distanceDir.list()
    var distanceList = folderList.filter { (distance: String) in distance.starts(with: "Distance") }
    distanceList.sort()

    distanceArray = [String](repeating: "", count: distanceList.size)
    for (i, distance) in distanceList.enumerated() {
      let runDistance  = distance.substring(13)
      distanceArray[i] = runDistance

      let distanceDir = File(file: distanceDir, child: distance, directoryHint: .isDirectory)
      let timesFile = File(file: distanceDir, child: "times.dat", directoryHint: .notDirectory)
      let timesStr  = try timesFile.readText()
      timeMap[runDistance] = timesStr.split(separator: ",").map(String.init)

      let profilesDir = File(file: distanceDir, child: "Profiles", directoryHint: .isDirectory)
      folderList = try profilesDir.list()

      var profileDates: [String : Date] = [:]
      for fileName in folderList {
        let profileFile = File(file: profilesDir, child: fileName, directoryHint: .notDirectory)
        let fileAttrib  = try profileFile.fileAttributes()

        let creationDate = fileAttrib[FileAttributeKey.creationDate] as? Date
        guard let creationDate else { throw FileError.FileDataError }

        profileDates[fileName] = creationDate
      }
      folderList.sort { return (profileDates[$0]! < profileDates[$1]!) }

      var profiles: [(String, [WaypointData])] = []
      for fileName in folderList {
        let profileName = String(fileName.dropLast(4))

        let profileFile = File(file: profilesDir, child: fileName, directoryHint: .notDirectory)
        let jsonData    = try profileFile.readData()

        let jsonDecoder   = JSONDecoder()
        let waypointData  = try jsonDecoder.decode([WaypointData].self, from: jsonData)

        profiles.append((profileName, waypointData))
      }

      profileMap[runDistance] = profiles
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

    let profilesDir = File(file: distanceDir, child: "Profiles", directoryHint: .isDirectory)
    if(!profilesDir.exists()) {
      let success = try profilesDir.mkdir()
      if(!success) { throw Exception.IOException }
    }

    let timesFile = File(file: distanceDir, child: "times.dat", directoryHint: .notDirectory)
    let timeStr = timeMap[distance]!.joined(separator: ",")
    try timesFile.writeText(timeStr)

    let profiles = profileMap[distance]!
    for profile in profiles {
      let profileName = profile.0
      let profileFile = File(file: profilesDir, child: "\(profileName).dat", directoryHint: .notDirectory)

      let jsonEncoder = JSONEncoder()
      let jsonData    = try jsonEncoder.encode(profile.1)
      try profileFile.writeData(jsonData)
    }
  }

  private func writeData() throws {
    for (i, distance) in distanceArray.enumerated() {
      let prefix = String(format: "Distance_%03d_", i)
      let distanceDir = File(file: distanceDir, child: prefix + distance, directoryHint: .isDirectory)
      if(!distanceDir.exists()) {
        let success = try distanceDir.mkdir()
        if(!success) { throw FileError.FolderCreationError }
      }

      let profilesDir = File(file: distanceDir, child: "Profiles", directoryHint: .isDirectory)
      if(!profilesDir.exists()) {
        let success = try profilesDir.mkdir()
        if(!success) { throw Exception.IOException }
      }

      let timesFile = File(file: distanceDir, child: "times.dat", directoryHint: .notDirectory)
      let timeStr = timeMap[distance]!.joined(separator: ",")
      try timesFile.writeText(timeStr)

      let profiles = profileMap[distance]!
      for profile in profiles {
        let profileName = profile.0
        let profileFile = File(file: profilesDir, child: "\(profileName).dat", directoryHint: .notDirectory)

        let jsonEncoder = JSONEncoder()
        let jsonData    = try jsonEncoder.encode(profile.1)
        try profileFile.writeData(jsonData)
      }
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

  func saveProfile(_ runDistance: String, _ profileName: String, _ waypointData: [WaypointData]) throws -> [String] {
    let profiles = profileMap[runDistance]
    guard var updatedProfiles = profiles else { throw Exception.IllegalArgumentException }

    updatedProfiles = updatedProfiles.filter { $0.0 != profileName }
    updatedProfiles.append((profileName, waypointData))
    profileMap[runDistance]! = updatedProfiles

    try writeData(runDistance)
    return profileMap[runDistance]!.map { $0.0 }
  }

  // TODO: Maybe make a profile manager?
  func deleteProfile(_ runDistance: String, _ profileName: String) throws -> [String]? {
    let profiles = profileMap[runDistance]
    guard var updatedProfiles = profiles else { throw Exception.IllegalArgumentException }

    let i = distanceArray.firstIndex(of: runDistance)
    guard let i else { throw Exception.IllegalArgumentException }

    let prefix = String(format: "Distance_%03d_", i)
    let distanceDir = File(file: distanceDir, child: prefix + runDistance, directoryHint: .isDirectory)
    let profilesDir = File(file: distanceDir, child: "Profiles", directoryHint: .isDirectory)
    let profileFile = File(file: profilesDir, child: "\(profileName).dat", directoryHint: .notDirectory)
    if(profileFile.delete()) {
      updatedProfiles = updatedProfiles.filter { $0.0 != profileName }
      profileMap[runDistance]! = updatedProfiles

      return updatedProfiles.map { $0.0 }
    }

    return nil
  }

  func waypointsFor(_ runDistance: String, _ profileName: String) throws -> [WaypointData] {
    let profiles = profileMap[runDistance]
    guard let profiles else { throw Exception.IllegalArgumentException }

    let matches = profiles.filter { $0.0 == profileName }
    if(matches.count != 1) { throw Exception.IllegalArgumentException }

    return matches[0].1
  }
}
