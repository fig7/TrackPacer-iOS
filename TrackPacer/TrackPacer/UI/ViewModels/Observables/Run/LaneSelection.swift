//
//  LaneSelection.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 24/05/2024.
//

import Foundation

@MainActor class LaneSelection: ObservableObject {
  var selectedCallback: (_ newSelected: String) -> Void = { _ in }

  @Published var selected = ""
  { didSet { selectedCallback(selected) } }

  @Published var list: [String] = [""]
}
