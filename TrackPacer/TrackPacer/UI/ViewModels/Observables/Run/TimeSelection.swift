//
//  TimeSelection.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 25/05/2024.
//

import Foundation

@MainActor class TimeSelection: ObservableObject {
  var selectedCallback: (_ newSelected: String) -> Void = { _ in }

  @Published var selected = ""
  { didSet { selectedCallback(selected) } }

  @Published var list: [String] = [""]

  func contains(_ timeStr: String) -> Bool
  {
    for timeEntry in list {
      let trimmed = timeEntry.trim()
      if(trimmed == timeStr) { return true }
    }

    return false
  }
}
