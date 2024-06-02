//
//  HistoryManager.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 30/05/2024.
//

import Foundation

class HistoryManager {
  private let historyDir: File

  init(filesDir: URL) {
    let filesDir    = File(url: filesDir)
    self.historyDir = File(file: filesDir, child: "History", directoryHint: .isDirectory)
  }

  private var historyModified: FileTime?
  var historyList: [ResultData] = []

  func initHistory() throws {
    if(!historyDir.exists()) {
      let success = try historyDir.mkdir()
      if(!success) { throw Exception.IOException }
    }
  }

  func loadHistory() throws {
    let historyDirAttr = try historyDir.fileAttributes()
    let lastModified = historyDirAttr[FileAttributeKey.modificationDate] as? Date
    guard let lastModified else { throw FileError.FileDataError }
    if(lastModified == historyModified) {
      // Generate new ids.
      // SwiftUI forEach needs them to change
      for resultData in historyList {
        resultData.id = UUID().uuidString
      }

      return
    }

    let folderList = try historyDir.list()
    historyList.clear()

    for resultUUID in folderList {
      let resultFile = File(file: historyDir, child: resultUUID, directoryHint: .notDirectory)
      let jsonData   = try resultFile.readData()

      let jsonDecoder = JSONDecoder()
      let runData  = try jsonDecoder.decode(RunData.self, from: jsonData)

      let runDataExtra = RunDataExtra(resultUUID, runData.runDate)
      let resultData   = ResultData(runData, runDataExtra)
      historyList.add(resultData)
    }

    historyList.sort { $0.runData.runDate > $1.runData.runDate }
    historyModified = lastModified
  }

  func saveHistory(_ runData: RunData) -> Bool {
    let jsonEncoder = JSONEncoder()
    let jsonData: Data?

    do {
      jsonData = try jsonEncoder.encode(runData)
    } catch { print("saveHistory: jsonEncoding failed"); return false }

    var historyFile: File
    var resultUUID: String
    repeat {
      resultUUID = UUID().uuidString
      historyFile = File(file: historyDir, child: resultUUID, directoryHint: .notDirectory)
    } while(historyFile.exists())

    do {
      try historyFile.writeData(jsonData!)
    } catch { print("saveHistory: writeData failed"); return false }

    return true
  }

  func deleteHistory(resultIndex: Int) -> Bool {
    let resultFile = File(file: historyDir, child: historyList[resultIndex].computedData.resultUUID, directoryHint: .notDirectory)
    if(resultFile.delete()) {
      historyList.remove(at: resultIndex)
      return true
    }

    return false
  }
}
