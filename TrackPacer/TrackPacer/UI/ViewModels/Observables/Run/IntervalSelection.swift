//
//  IntervalSelection.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 27/01/2026.
//

import Foundation

@MainActor class IntervalSelection: ObservableObject {
  var selectedCallback: (_ newSelected: String) -> Void = { _ in }

  @Published var selected = "50m"
  { didSet { selectedCallback(selected) } }

  @Published var list: [String] = ["50m", "100m", "200m", "400m"];
}
