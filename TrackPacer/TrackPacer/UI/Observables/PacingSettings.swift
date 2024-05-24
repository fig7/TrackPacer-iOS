//
//  PacingSettings.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 24/05/2024.
//

import SwiftUI

@MainActor class PacingSettings : ObservableObject {
  @Published var powerStart = true
  @Published var quickStart = false
  @Published var startDelay = "5.00"

}
