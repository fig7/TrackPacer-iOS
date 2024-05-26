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
}
