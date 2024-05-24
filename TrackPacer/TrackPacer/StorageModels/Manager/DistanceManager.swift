//
//  DistanceManager.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 24/05/2024.
//

import Foundation

private let distanceVersion = "1.3"
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
      // readVersion()
      // readData()

      if(currentVersion != distanceVersion) {
        // updateData(defaultDistances)
      }
    } else {
      try initData(defaultDistances)
    }
  }

  private func readVersion() throws {
    let versionFile = File(file: distanceDir, child: "version.dat", directoryHint: .notDirectory)
    if(!versionFile.exists()) {
      // Version before version file existed
      currentVersion = "1.2"
      return
    }

    currentVersion = try versionFile.readText()
  }

  private func writeVersion() throws {
    let versionFile = File(file: distanceDir, child: "version.dat", directoryHint: .notDirectory)
    try versionFile.writeText(text: distanceVersion)
  }

  private func initData(_ defaultDistances: [String]) throws {
    if(!(try distanceDir.mkdir())) { throw FileError.FileCreationError }

    distanceArray = (0 ..< defaultDistances.size).map { (i: Int) in String(defaultDistances[i].split(separator: "+")[0]) }
    for (i, runDistance) in distanceArray.enumerated() {
      timeMap[runDistance] = String(defaultDistances[i].split(separator: "+")[1]).trim().split(separator: ",").map(String.init)
    }

    try writeData()
    try writeVersion()
  }

  /*
    private fun readData() {
        val folderList = distanceDir.list() ?: throw IOException()
        val distanceFilter = { distance: String -> distance.startsWith("Distance") }

        val folderArray = folderList.filter(distanceFilter).toTypedArray()
        folderArray.sort()
        distanceArray = Array(folderArray.size) { "" }

        for ((i, distance) in folderArray.withIndex()) {
            val runDistance  = distance.substring(13)
            distanceArray[i] = runDistance

            val distanceDir = File(distanceDir, distance)
            val timesFile = File(distanceDir, "times.dat")
            val timesStr  = timesFile.readText()
            timeMap[runDistance] = timesStr.split(",").toTypedArray()
        }
    }

    private fun writeData(distance: String) {
        val i = distanceArray.indexOf(distance)
        if (i == -1) { throw IllegalArgumentException() }

        val prefix = String.format("Distance_%03d_", i)
        val distanceDir = File(distanceDir, prefix + distance)
        if (!distanceDir.exists() && !distanceDir.mkdir()) throw IOException()

        val timesFile = File(distanceDir, "times.dat")
        val timeStr = timeMap[distance]!!.joinToString(separator = ",")
        timesFile.writeText(timeStr)
    }

    private fun writeData() {
        for ((i, distance) in distanceArray.withIndex()) {
            val prefix = String.format("Distance_%03d_", i)
            val distanceDir = File(distanceDir, prefix + distance)
            if (!distanceDir.exists() && !distanceDir.mkdir()) throw IOException()

            val timesFile = File(distanceDir, "times.dat")
            val timeStr = timeMap[distance]!!.joinToString(separator = ",")
            timesFile.writeText(timeStr)
        }
    }

    private fun updateData(defaultDistances: Array<String>) {
        when(currentVersion) {
            "1.2" -> {
                // 1.2 -> 1.3
                // Rename Distance_002_1200m ....
                var oldDistanceDir = File(distanceDir, "Distance_002_1200m")
                var newDistanceDir = File(distanceDir, "Distance_003_1200m")
                if(!oldDistanceDir.renameTo(newDistanceDir)) throw IOException()

                oldDistanceDir = File(distanceDir, "Distance_003_1500m")
                newDistanceDir = File(distanceDir, "Distance_004_1500m")
                if(!oldDistanceDir.renameTo(newDistanceDir)) throw IOException()

                oldDistanceDir = File(distanceDir, "Distance_004_2000m")
                newDistanceDir = File(distanceDir, "Distance_005_2000m")
                if(!oldDistanceDir.renameTo(newDistanceDir)) throw IOException()

                oldDistanceDir = File(distanceDir, "Distance_005_3000m")
                newDistanceDir = File(distanceDir, "Distance_006_3000m")
                if(!oldDistanceDir.renameTo(newDistanceDir)) throw IOException()

                oldDistanceDir = File(distanceDir, "Distance_006_4000m")
                newDistanceDir = File(distanceDir, "Distance_007_4000m")
                if(!oldDistanceDir.renameTo(newDistanceDir)) throw IOException()

                oldDistanceDir = File(distanceDir, "Distance_007_5000m")
                newDistanceDir = File(distanceDir, "Distance_008_5000m")
                if(!oldDistanceDir.renameTo(newDistanceDir)) throw IOException()

                oldDistanceDir = File(distanceDir, "Distance_008_10000m")
                newDistanceDir = File(distanceDir, "Distance_009_10000m")
                if(!oldDistanceDir.renameTo(newDistanceDir)) throw IOException()

                oldDistanceDir = File(distanceDir, "Distance_009_1 mile")
                newDistanceDir = File(distanceDir, "Distance_010_1 mile")
                if(!oldDistanceDir.renameTo(newDistanceDir)) throw IOException()

                // Update distance array
                distanceArray = Array(defaultDistances.size) { defaultDistances[it].split("+")[0] }
                timeMap["1000m"] = defaultDistances[2].split("+")[1].trim().split(",").toTypedArray()

                // Write out Distance_002_1000m
                val distanceDir = File(distanceDir, "Distance_002_1000m")
                if (!distanceDir.exists() && !distanceDir.mkdir()) throw IOException()

                val timesFile = File(distanceDir, "times.dat")
                val timeStr = timeMap["1000m"]!!.joinToString(separator = ",")
                timesFile.writeText(timeStr)
            }

            else -> throw IllegalArgumentException()
        }

        writeVersion()
    }

    private fun timeGreaterThan(time1: String, time2: String): Bool {
        val time1Split = time1.split(":")
        val time1Dbl = 1000.0*(time1Split[0].trim().toLong()*60.0 + time1Split[1].toDouble())

        val time2Split = time2.split(":")
        val time2Dbl = 1000.0*(time2Split[0].trim().toLong()*60.0 + time2Split[1].toDouble())
        return time1Dbl > time2Dbl
    }

    fun deleteTime(runDistance: String, runTime: String?): Int {
        if (runTime == null) { throw IllegalArgumentException() }
        if (!timeMap.containsKey(runDistance)) { throw IllegalArgumentException() }

        val timeArray = timeMap[runDistance]!!
        if (!timeArray.contains(runTime)) { throw IllegalArgumentException() }

        var i = 0
        var newIndex = -1
        val newTimeArray = Array(timeArray.size-1) { "" }
        for (time in timeArray) {
            if (time == runTime) {
                newIndex = i-1
                if (newIndex < 0) newIndex = 0
                continue
            }

            newTimeArray[i++] = time
        }

        timeMap[runDistance] = newTimeArray
        writeData(runDistance)

        return newIndex
    }

    fun addTime(runDistance: String, runTime: String?): Int {
        if (runTime == null) { throw IllegalArgumentException() }
        if (!timeMap.containsKey(runDistance)) { throw IllegalArgumentException() }

        var i = 0
        var j = 0
        val timeArray = timeMap[runDistance]!!
        val newTimeArray = Array(timeArray.size+1) { "" }
        while (i < timeArray.size) {
            val time = timeArray[i]
            if (timeGreaterThan(time, runTime)) {
                break
            }

            i++
            newTimeArray[j++] = time
        }

        val newIndex = j
        newTimeArray[j++] = runTime

        while (i < timeArray.size) {
            val time = timeArray[i++]
            newTimeArray[j++] = time
        }

        timeMap[runDistance] = newTimeArray
        writeData(runDistance)

        return newIndex
    }

    fun replaceTime(runDistance: String, origTime: String?, newTime: String?): Int {
        if ((origTime == null) || (newTime == null)) { throw IllegalArgumentException() }
        if (!timeMap.containsKey(runDistance)) { throw IllegalArgumentException() }

        var i = 0
        var j = 0
        val timeArray = timeMap[runDistance]!!
        val newTimeArray = Array(timeArray.size) { "" }
        while (i < timeArray.size) {
            val time = timeArray[i]
            if (timeGreaterThan(time, newTime)) {
                break
            }

            i++
            if (time == origTime) {
                continue
            }

            newTimeArray[j++] = time
        }

        val newIndex = j
        newTimeArray[j++] = newTime

        while (i < timeArray.size) {
            val time = timeArray[i]

            ++i
            if (time == origTime) {
                continue
            }

            newTimeArray[j++] = time
        }

        timeMap[runDistance] = newTimeArray
        writeData(runDistance)

        return newIndex
    } */
}
