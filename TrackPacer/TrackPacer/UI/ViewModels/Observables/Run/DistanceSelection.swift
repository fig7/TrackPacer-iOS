//
//  DistanceSelection.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 10/05/2024.
//

import Foundation

@MainActor class DistanceSelection: ObservableObject {
  var selectedCallback: (_ newSelected: String) -> Void = { _ in }

  @Published var selected = ""
  { didSet { selectedCallback(selected) } }

  @Published var list: [String] = [""]
}
