//
//  DistanceSelection.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 10/05/2024.
//

import Foundation

@MainActor class DistanceSelection: ObservableObject {
  var delegate: SelectedChangedDelegate?

  @Published var selected = "" {
    didSet {
      delegate?.selectedChanged(selected)
    }
  }
  @Published var list: [String] = [""]
}
