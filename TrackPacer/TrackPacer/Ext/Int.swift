//
//  Int.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 23/05/2024.
//

import Foundation

extension Int {
  func toDouble() -> Double {
    return Double(self)
  }

  func toString() -> String {
    return "\(self)"
  }

  func toString2() -> String {
    return "\(String(format: "%02d", self))"
  }
}
