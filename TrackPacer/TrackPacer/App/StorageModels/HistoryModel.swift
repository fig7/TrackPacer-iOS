//
//  HistoryModel.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 30/05/2024.
//

import Foundation

class HistoryModel {
  let historyManager = HistoryManager(filesDir: URL.documentsDirectory)
  var historyDataOK = true

  init() {
    do {
      try historyManager.initHistory()
    } catch {
      historyDataOK = false
      print("Failed to initialize history. Error: \(error.localizedDescription)")
    }
  }

  func loadHistory() {
    do {
      try historyManager.loadHistory()
    } catch {
      historyDataOK = false
      print("Failed to load history. Error: \(error.localizedDescription)")
    }
 }
}
