//
//  ClipSelection.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 19/07/2024.
//

import Foundation

@MainActor class ClipSelection: ObservableObject {
  var selectedCallback: (_ newSelected: String) -> Void = { _ in }

  @Published var selected = ""
  { didSet { selectedCallback(selected) } }

  @Published var list: [String] = [""]
  @Published var clipsEnabled = true
}
