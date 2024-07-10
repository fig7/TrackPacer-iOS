//
//  TrackSelection.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 26/05/2024.
//

import Foundation

@MainActor class TrackSelection: ObservableObject {
  @Published var runDist = "400m"

  @Published var lapCounter    = "1 lap"
  @Published var lapDesc1      = ""
  @Published var lapDesc2      = ""

  @Published var trackOverlay  = "rt_400_l1"
}
