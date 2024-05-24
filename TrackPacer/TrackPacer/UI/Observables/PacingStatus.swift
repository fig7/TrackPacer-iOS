//
//  PacingStatus.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 12/05/2024.
//

import SwiftUI

enum PacingStatusVal { case NotPacing, ServiceStart, PacingWait, PacingStart, Pacing, PacingPause, PacingPaused, ServiceResume, PacingResume, PacingComplete, PacingCancel }

@MainActor class PacingStatus : ObservableObject {
  @Published var status: PacingStatusVal = .NotPacing {
    didSet {
      isPacing = ((status == .PacingStart) || (status == .PacingResume) ||
                  (status == .PacingWait)  || (status == .Pacing))
    }
  }
  
  @Published var isPacing = false
}
