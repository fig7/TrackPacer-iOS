//
//  DistanceSelection.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 10/05/2024.
//

import Foundation

@MainActor class DistanceSelection: ObservableObject {
  @Published var selected = ""
  @Published var list: [String] = []
}
