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
  private let dataDir: File

  var distArray: [String]!
  var timeMap: [String : [String : [String]]] = [:]
  var profMap: [String : [Intvl : [(String, [WaypointData])]]] = [:]

  private var currentVersion: String!

  init(filesDir: URL) {
    let filesDir = File(url: filesDir)
    self.dataDir = File(file: filesDir, child: "Data", directoryHint: .isDirectory)
  }

  func initDistances(_ defaultDist: [[String : Any]]) throws {
    if(dataDir.exists()) {
      try readVersion()
      try readData()

      if(currentVersion != distanceVersion) {
        try updateData(defaultDist)
      }
    } else {
      try initData(defaultDist)
    }
  }

  private func readVersion() throws {
    let versionFile = File(file: dataDir, child: "version.dat", directoryHint: .notDirectory)
    if(!versionFile.exists()) { throw FileError.FileReadError }

    currentVersion = try versionFile.readText()
  }

  private func writeVersion() throws {
    let versionFile = File(file: dataDir, child: "version.dat", directoryHint: .notDirectory)
    try versionFile.writeText(distanceVersion)
  }

  private func initData(_ defaultDist: [[String : Any]]) throws {
    let success = try dataDir.mkdir()
    if(!success) { throw FileError.FolderCreationError }

    distArray = (0 ..< defaultDist.size).map { (i: Int) in String(defaultDist[i]["Dist"]! as! String) }
    for (i, baseDist) in distArray.enumerated() {
      timeMap[baseDist] = [:]
      timeMap[baseDist]!["Pace"]   = (defaultDist[i]["Pace"]!   as! [String])
      timeMap[baseDist]!["Goal"]   = (defaultDist[i]["Goal"]!   as! [String])
      timeMap[baseDist]!["Actual"] = (defaultDist[i]["Actual"]! as! [String])

      var profileWaypoints: [WaypointData] = []
      for _ in 0..<waypointDistances[baseDist]!.count { profileWaypoints.append(WaypointData()) }
      profMap[baseDist] = [:];
      profMap[baseDist]![Intvl.i50m ] = [("Fixed pace", profileWaypoints)]
      profMap[baseDist]![Intvl.i100m] = [("Fixed pace", profileWaypoints)]
      profMap[baseDist]![Intvl.i200m] = [("Fixed pace", profileWaypoints)]

      switch baseDist
      {
      case "800m":
        profMap[baseDist]![Intvl.i400m] = [("Fixed pace", profileWaypoints)]

      case  "1000m":
        profMap[baseDist]![Intvl.i400m] = [("Fixed pace", profileWaypoints)]
        profMap[baseDist]![Intvl.i800m] = [("Fixed pace", profileWaypoints)]

      case "1200m", "1500m", "2000m", "1 mile":
        profMap[baseDist]![Intvl.i400m ] = [("Fixed pace", profileWaypoints)]
        profMap[baseDist]![Intvl.i800m ] = [("Fixed pace", profileWaypoints)]
        profMap[baseDist]![Intvl.i1000m] = [("Fixed pace", profileWaypoints)]

      case "3000m", "4000m":
        profMap[baseDist]![Intvl.i400m ] = [("Fixed pace", profileWaypoints)]
        profMap[baseDist]![Intvl.i800m ] = [("Fixed pace", profileWaypoints)]
        profMap[baseDist]![Intvl.i1000m] = [("Fixed pace", profileWaypoints)]
        profMap[baseDist]![Intvl.i2000m] = [("Fixed pace", profileWaypoints)]

      case "5000m":
        profMap[baseDist]![Intvl.i400m ] = [("Fixed pace", profileWaypoints)]
        profMap[baseDist]![Intvl.i800m ] = [("Fixed pace", profileWaypoints)]
        profMap[baseDist]![Intvl.i1000m] = [("Fixed pace", profileWaypoints)]
        profMap[baseDist]![Intvl.i2000m] = [("Fixed pace", profileWaypoints)]
        profMap[baseDist]![Intvl.i1km  ] = [("Fixed pace", profileWaypoints)]
        profMap[baseDist]![Intvl.i2km  ] = [("Fixed pace", profileWaypoints)]

      case "10000m":
        profMap[baseDist]![Intvl.i400m ] = [("Fixed pace", profileWaypoints)]
        profMap[baseDist]![Intvl.i800m ] = [("Fixed pace", profileWaypoints)]
        profMap[baseDist]![Intvl.i1000m] = [("Fixed pace", profileWaypoints)]
        profMap[baseDist]![Intvl.i2000m] = [("Fixed pace", profileWaypoints)]
        profMap[baseDist]![Intvl.i5000m] = [("Fixed pace", profileWaypoints)]
        profMap[baseDist]![Intvl.i1km  ] = [("Fixed pace", profileWaypoints)]
        profMap[baseDist]![Intvl.i2km  ] = [("Fixed pace", profileWaypoints)]
        profMap[baseDist]![Intvl.i5km  ] = [("Fixed pace", profileWaypoints)]

      default:
        break
      }

      switch baseDist
      {
      case "400m":
        profMap[baseDist]![Intvl.i400m]  = [("Freestyle", profileWaypoints)]

      case "800m":
        profMap[baseDist]![Intvl.i800m]  = [("Freestyle", profileWaypoints)]

      case "1000m":
        profMap[baseDist]![Intvl.i1000m]  = [("Freestyle", profileWaypoints)]

      case "1200m":
        profMap[baseDist]![Intvl.i1200m]  = [("Freestyle", profileWaypoints)]

      case "1500m":
        profMap[baseDist]![Intvl.i1500m]  = [("Freestyle", profileWaypoints)]

      case "2000m":
        profMap[baseDist]![Intvl.i2000m]  = [("Freestyle", profileWaypoints)]

      case "3000m":
        profMap[baseDist]![Intvl.i3000m]  = [("Freestyle", profileWaypoints)]

      case "4000m":
        profMap[baseDist]![Intvl.i4000m]  = [("Freestyle", profileWaypoints)]

      case "5000m":
        profMap[baseDist]![Intvl.i5000m]  = [("Freestyle", profileWaypoints)]
        profMap[baseDist]![Intvl.i5km  ]  = [("Freestyle", profileWaypoints)]

      case "10000m":
        profMap[baseDist]![Intvl.i10000m] = [("Freestyle", profileWaypoints)]
        profMap[baseDist]![Intvl.i10km  ] = [("Freestyle", profileWaypoints)]

      case "1 mile":
        profMap[baseDist]![Intvl.i1mile]  = [("Freestyle", profileWaypoints)]

      default:
        break
      }
    }

    try writeData()
    try writeVersion()
  }

  private func readData() throws {
    let folderList = try dataDir.list()
    var distList = folderList.filter { (dist: String) in dist.starts(with: "Distance") }
    distList.sort()

    distArray = [String](repeating: "", count: distList.size)
    for (i, dist) in distList.enumerated() {
      let baseDist  = dist.substring(13)
      distArray[i] = baseDist

      let distDir = File(file: dataDir, child: dist, directoryHint: .isDirectory)
      let timesFile = File(file: distDir, child: "times.dat", directoryHint: .notDirectory)
      let timesStr  = try timesFile.readText()
      let timesArray = timesStr.split(separator: "\n")
      timeMap[baseDist] = [:]
      timeMap[baseDist]!["Pace"]   = timesArray[0].split(separator: ",").map(String.init)
      timeMap[baseDist]!["Goal"]   = timesArray[1].split(separator: ",").map(String.init)
      timeMap[baseDist]!["Actual"] = timesArray[2].split(separator: ",").map(String.init)

      let baseProfDir = File(file: distDir, child: "Profiles", directoryHint: .isDirectory)
      let intvlList = try baseProfDir.list()

      profMap[baseDist] = [:]
      for intvl in intvlList {
        let profDir = File(file: baseProfDir, child: intvl, directoryHint: .isDirectory)
        let profList = try profDir.listByDate()

        var profiles: [(String, [WaypointData])] = []
        for fileName in profList {
          let profName = String(fileName.dropLast(4))
          let profFile = File(file: profDir, child: fileName, directoryHint: .notDirectory)
          let jsonData    = try profFile.readData()

          let jsonDecoder   = JSONDecoder()
          let waypointData  = try jsonDecoder.decode([WaypointData].self, from: jsonData)
          profiles.append((profName, waypointData))
        }

        // To do, make sure string converts correctly
        // Should really also check dist dirs are correct, too
        profMap[baseDist]![Intvl(rawValue: intvl)!] = profiles
      }
    }
  }

  private func writeData(_ index: Int, _ dist: String) throws {
    let prefix = String(format: "Distance_%03d_", index)
    let distDir = File(file: dataDir, child: prefix + dist, directoryHint: .isDirectory)
    if(!distDir.exists()) {
      let success = try distDir.mkdir()
      if(!success) { throw Exception.IOException }
    }

    let baseProfDir = File(file: distDir, child: "Profiles", directoryHint: .isDirectory)
    if(!baseProfDir.exists()) {
      let success = try baseProfDir.mkdir()
      if(!success) { throw Exception.IOException }
    }

    let timesFile = File(file: distDir, child: "times.dat", directoryHint: .notDirectory)
    var timeStr = timeMap[dist]!["Pace"]!.joined(separator: ",")    + "\n"
    timeStr    += timeMap[dist]!["Goal"]!.joined(separator: ",")    + "\n"
    timeStr    += timeMap[dist]!["Actual"]!.joined(separator: ",")  + "\n"
    try timesFile.writeText(timeStr)

    let profIntvl = profMap[dist]!
    for intvl in profIntvl.keys {
      let profDir = File(file: baseProfDir, child: intvl.rawValue, directoryHint: .isDirectory)
      if(!profDir.exists()) {
        let success = try profDir.mkdir()
        if(!success) { throw Exception.IOException }
      }

      let profiles = profIntvl[intvl]!
      for profile in profiles {
        let profName = profile.0
        let profFile = File(file: profDir, child: "\(profName).dat", directoryHint: .notDirectory)

        let jsonEncoder = JSONEncoder()
        let jsonData    = try jsonEncoder.encode(profile.1)
        try profFile.writeData(jsonData)
      }
    }
  }

  private func writeData(_ dist: String) throws {
    let index = distArray.firstIndex(of: dist)
    guard let index else { throw Exception.IllegalArgumentException }

    try writeData(index, dist)
  }

  private func writeData() throws {
    for (index, dist) in distArray.enumerated() {
      try writeData(index, dist)
    }
  }

  private func updateData(_ defaultDist: [[String : Any]]) throws {
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

  func deleteTime(_ baseDist: String, _ runPace: String, _ setTime: String) throws -> Int {
    let timeDict = timeMap[baseDist]
    guard let timeDict else { throw Exception.IllegalArgumentException }

    let timeArray = timeDict[runPace]
    guard let timeArray else { throw Exception.IllegalArgumentException }

    if(!timeArray.contains(setTime)) { throw Exception.IllegalArgumentException }

    var i = 0
    var newIndex = -1
    var newTimeArray = [String](repeating: "", count: timeArray.size-1)
    for time in timeArray {
      if(time == setTime) {
        newIndex = i-1
        if(newIndex < 0) { newIndex = 0 }
        continue
      }

      newTimeArray[i] = time
      i += 1
    }

    timeMap[baseDist]![runPace]! = newTimeArray
    try writeData(baseDist)

    return newIndex
  }

  func addTime(_ baseDist: String, _ runPace: String, _ setTime: String) throws -> Int {
    let timeDict = timeMap[baseDist]
    guard let timeDict else { throw Exception.IllegalArgumentException }

    let timeArray = timeDict[runPace]
    guard let timeArray else { throw Exception.IllegalArgumentException }

    if(timeArray.contains(setTime)) { throw Exception.IllegalArgumentException }

    var i = 0
    var j = 0
    var newTimeArray = [String](repeating: "", count: timeArray.size+1)
    while(i < timeArray.size) {
      let time = timeArray[i]
      if(try timeGreaterThan(time1: time, time2: setTime)) { break }

      newTimeArray[j] = time
      i += 1; j += 1
    }

    let newIndex = j
    newTimeArray[j] = setTime
    j += 1

    while(i < timeArray.size) {
      newTimeArray[j] = timeArray[i]
      i += 1; j += 1
    }

    timeMap[baseDist]![runPace]! = newTimeArray
    try writeData(baseDist)

    return newIndex
  }

  func replaceTime(_ baseDist: String, _ runPace: String, _ origTime: String, _ newTime: String) throws -> Int {
    let timeDict = timeMap[baseDist]
    guard let timeDict else { throw Exception.IllegalArgumentException }

    let timeArray = timeDict[runPace]
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

    timeMap[baseDist]![runPace]! = newTimeArray
    try writeData(baseDist)

    return newIndex
  }

  func profileExists(_ runDistance: String, _ intvl: Intvl,  _ profileName: String) -> Bool
  { return profMap[runDistance]![intvl]!.contains { (name, _) in return (name == profileName) } }

  func saveProfile(_ baseDist: String, _ intvl: Intvl, _ profileName: String, _ waypointData: [WaypointData]) throws -> [String] {
    let profilesDict = profMap[baseDist]
    guard let updatedProfilesDict = profilesDict else { throw Exception.IllegalArgumentException }

    let profiles = updatedProfilesDict[intvl]
    guard var updatedProfiles = profiles else { throw Exception.IllegalArgumentException }

    updatedProfiles = updatedProfiles.filter { $0.0 != profileName }
    updatedProfiles.append((profileName, waypointData))
    profMap[baseDist]![intvl]! = updatedProfiles

    try writeData(baseDist)
    return profMap[baseDist]![intvl]!.map { $0.0 }
  }

  func deleteProfile(_ runDist: String, _ intvl: Intvl, _ profileName: String) throws -> [String] {
    let profilesDict = profMap[runDist]
    guard let updatedProfilesDict = profilesDict else { throw Exception.IllegalArgumentException }

    let profiles = updatedProfilesDict[intvl]
    guard var updatedProfiles = profiles else { throw Exception.IllegalArgumentException }

    let i = distArray.firstIndex(of: runDist)
    guard let i else { throw Exception.IllegalArgumentException }

    let prefix  = String(format: "Distance_%03d_", i)
    let distDir = File(file: dataDir, child: prefix + runDist, directoryHint: .isDirectory)

    let baseProfDir = File(file: distDir,     child: "Profiles", directoryHint: .isDirectory)
    let profDir     = File(file: baseProfDir, child: intvl.rawValue, directoryHint: .isDirectory)
    let profFile    = File(file: profDir,     child: "\(profileName).dat", directoryHint: .notDirectory)
    if(profFile.delete()) {
      updatedProfiles = updatedProfiles.filter { $0.0 != profileName }
      profMap[runDist]![intvl]! = updatedProfiles

      return updatedProfiles.map { $0.0 }
    }

    throw Exception.IOException
  }

  func waypointsFor(_ baseDist: String, _ intvl: Intvl, _ profName: String) throws -> [WaypointData] {
    let profilesDict = profMap[baseDist]
    guard let profilesDict else { throw Exception.IllegalArgumentException }

    let profiles = profilesDict[intvl]
    guard let profiles = profiles else { throw Exception.IllegalArgumentException }

    let matches = profiles.filter { $0.0 == profName }
    if(matches.count != 1) { throw Exception.IllegalArgumentException }

    return matches[0].1
  }
}
