//
//  LaneSelection.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 24/05/2024.
//

import Foundation

@MainActor class LaneSelection: ObservableObject {
  var selectedCallback: (_ newSelected: String) -> Void = { _ in }

  @Published var selected = "1"
  { didSet { selectedCallback(selected) } }

  @Published var list: [String] = ["1", "2", "3", "4", "5", "6", "7", "8"]
}
