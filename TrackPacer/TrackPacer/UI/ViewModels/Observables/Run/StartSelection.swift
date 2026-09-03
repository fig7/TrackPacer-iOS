//
//  StartSelection.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 16/04/2026.
//

import Foundation

@MainActor class StartSelection: ObservableObject {
  var selectedCallback: (_ newSelected: String) -> Void = { _ in }

  @Published var selected = "Home"
  { didSet { selectedCallback(selected) } }

  @Published var list: [String] = ["Home"]

  func contains(_ timeStr: String) -> Bool
  { return list.contains(timeStr) }
}
