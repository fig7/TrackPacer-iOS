//
//  LaneSelection.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 24/05/2024.
//

import Foundation

@MainActor class LaneSelection: ObservableObject {
  @Published var selected = "1"
  @Published var list     = ["1", "2", "3", "4", "5", "6", "7", "8"]
}

