//
//  TimeSelection.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 25/05/2024.
//

import Foundation

@MainActor class TimeSelection: ObservableObject {
  @Published var selected       = ""
  @Published var list: [String] = [""]
}
