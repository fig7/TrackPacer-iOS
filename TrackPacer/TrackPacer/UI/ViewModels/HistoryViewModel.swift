//
//  HistoryViewModel.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 01/06/2024.
//

import Foundation

class HistoryViewModel : ObservableObject {
  @Published var historyList: [ResultData] = []

  func initList(_ list: [ResultData]) {
    self.historyList = list
  }
}
