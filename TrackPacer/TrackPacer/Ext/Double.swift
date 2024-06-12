//
//  Double.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 22/05/2024.
//

import Foundation

extension Double {
  func toInt() -> Int {
    return Int(self)
  }

  func toLong() -> Int64 {
    return Int64(self)
  }

  func toLongRounded() -> Int64 {
    return Int64(self.rounded())
  }

  func rounded(toPlaces places: Int) -> Double {
    let divisor = pow(10.0, Double(places))
    return (self * divisor).rounded() / divisor
  }

  func roundedToFifth() -> Double {
    let divisor = 5.0
    return (self * divisor).rounded() / divisor
  }
}
