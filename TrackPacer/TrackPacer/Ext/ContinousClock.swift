//
//  ContinousClock.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 22/05/2024.
//

import Foundation

extension ContinuousClock {
  func elapsedRealtime() -> Instant {
    return self.now
  }
}
