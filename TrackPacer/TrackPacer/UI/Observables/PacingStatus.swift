//
//  PacingStatus.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 12/05/2024.
//

import SwiftUI

enum PacingStatusVal { case NotPacing, Pacing }

@MainActor class PacingStatus : ObservableObject {
  @Published var status: PacingStatusVal = .NotPacing {
    didSet {
      isPacing = (status == .Pacing)
    }
  }
  
  @Published var isPacing = false
}
