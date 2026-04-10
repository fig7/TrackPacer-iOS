//
//  IntervalSelection.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 27/01/2026.
//

import Foundation

@MainActor class IntervalSelection: ObservableObject {
  var selectedCallback: (_ newSelected: String) -> Void = { _ in }

  @Published var selected = ""
  { didSet { selectedCallback(selected) } }

  @Published var list: [String] = [""]
}
