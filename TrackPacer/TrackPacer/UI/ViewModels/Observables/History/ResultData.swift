//
//  ResultDataComplete.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 01/06/2024.
//

import Foundation

class ResultData : ObservableObject, Identifiable, Hashable {
  static func == (lhs: ResultData, rhs: ResultData) -> Bool {
    return (lhs.computedData.resultUUID == rhs.computedData.resultUUID)
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }

  var id = UUID().uuidString
  @Published var runData: RunData
  @Published var computedData: RunDataExtra

  init(_ resultData: RunData, _ computedData: RunDataExtra) {
    self.runData      = resultData
    self.computedData = computedData
  }
}
