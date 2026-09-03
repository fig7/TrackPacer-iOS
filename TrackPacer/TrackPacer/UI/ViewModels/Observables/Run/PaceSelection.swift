//
//  PaceSelection.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 15/04/2026.
//

import Foundation

@MainActor class PaceSelection: ObservableObject {
  var selectedCallback: (_ newSelected: String) -> Void = { _ in }

  @Published var selected = "Pace"
  { didSet { selectedCallback(selected) } }

  @Published var list: [String] = ["Pace", "Goal", "Actual"]

  func contains(_ timeStr: String) -> Bool
  { return list.contains(timeStr) }
}
