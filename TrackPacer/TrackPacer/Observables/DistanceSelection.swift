//
//  DistanceSelection.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 10/05/2024.
//

import Foundation

@MainActor class DistanceSelection: ObservableObject {
  @Published var selected = "400m"
  @Published var list = ["400m", "800m", "1000m"]
}
