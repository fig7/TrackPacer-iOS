//
//  ClipsManager.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 16/07/2024.
//

import Foundation

private let clipVersion = "1.0"

class ClipsManager {
  private let clipDir: File

  private var clipCatArray: [String]     = []
  private var clipMap: [String : [File]] = [:]

  private var currentVersion: String!

  init(filesDir: URL) {
    let filesDir = File(url: filesDir)
    self.clipDir = File(file: filesDir, child: "Clips", directoryHint: .isDirectory)
  }

  func initClips(_ defaultClips: [DefaultClipCat]) throws {
    if(clipDir.exists()) {
      try readVersion()
      try readData()

      if(currentVersion != clipVersion) {
        try updateData()
      }
    } else {
      try initData(defaultClips)
    }
  }

  func clipsForCat(clipCat: String) throws -> [File] {
    let clips = clipMap[clipCat]
    guard let clips else { throw Exception.IllegalArgumentException }

    return clips
  }

  private func readVersion() throws {
    let versionFile = File(file: clipDir, child: "version.dat", directoryHint: .notDirectory)
    if(!versionFile.exists()) { throw Exception.IOException }

    currentVersion = try versionFile.readText()
  }

  private func writeVersion() throws {
    let versionFile = File(file: clipDir, child: "version.dat", directoryHint: .notDirectory)
    try versionFile.writeText(clipVersion)
  }

  private func initData(_ defaultClips: [DefaultClipCat]) throws {
    let resourceURL = Bundle.main.resourceURL
    guard let resourceURL else { throw Exception.IOException }

    let success = try clipDir.mkdir()
    guard success else { throw Exception.IOException }

    let fm = FileManager.default
    for i in defaultClips.indices {
      let clipCat = defaultClips[i]

      let clipCatName   = clipCat.0
      let clipCatFolder = String(format: "Cat_%03d_%@", i, clipCatName)
      let clipCatDir    = File(file: clipDir, child: clipCatFolder, directoryHint: .isDirectory)

      let success = try clipCatDir.mkdir()
      guard success else { throw Exception.IOException }

      var clipList: [File] = clipMap[clipCatName] ?? []
      let clipCatList = clipCat.1
      for clipPair in clipCatList {
        let clipFile: File
        let clipMP3 = (clipPair.1.1 == "")
        if(clipMP3) {
          clipFile = File(file: clipCatDir, child: clipPair.0 + ".m4a", directoryHint: .notDirectory)

          let resFile = File(url: resourceURL, child: clipPair.1.0  + ".m4a", directoryHint: .notDirectory)
          try fm.copyItem(at: resFile.url, to: clipFile.url)
        } else {
          clipFile = File(file: clipCatDir, child: clipPair.0 + ".tts", directoryHint: .notDirectory)

          let outputData = clipPair.1.1
          try clipFile.writeText(outputData)
        }

        clipList.add(clipFile)
      }

      clipCatArray.add(clipCatName)
      clipMap[clipCatName] = clipList
    }

    try writeVersion()
  }

  private func readData() throws {
    let folderList  = try clipDir.list()

    let catFilter = { (clipCat: String) in clipCat.hasPrefix("Cat") }
    var folderArray = folderList.filter(catFilter)
    folderArray.sort()

    for catFolder in folderArray {
      let catDir      = File(file: clipDir, child: catFolder, directoryHint: .isDirectory)
      let clipCatName = catFolder.substring(8)

      var clipList = clipMap[clipCatName] ?? []
      let catFiles = try catDir.listFiles()
      for catFile in catFiles {
        clipList.add(catFile)
      }

      clipCatArray.add(clipCatName)
      clipMap[clipCatName] = clipList
    }
  }

  private func updateData() throws {
    throw Exception.IllegalArgumentException
  }
}
