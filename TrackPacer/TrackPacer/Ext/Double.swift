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

  func toIntRounded() -> Int {
    return Int(self.rounded())
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

  func roundedToP25() -> Double {
    let divisor = 4.0
    return (self * divisor).rounded() / divisor
  }

  func roundedToP5() -> Double {
    let divisor = 2.0
    return (self * divisor).rounded() / divisor
  }

  func roundedTo2() -> Double {
    let multiplier = 2.0
    return (self / multiplier).rounded() * multiplier
  }

  func roundedTo4() -> Double {
    let multiplier = 4.0
    return (self / multiplier).rounded() * multiplier
  }

  func roundedTo5() -> Double {
    let multiplier = 5.0
    return (self / multiplier).rounded() * multiplier
  }

  func roundedTo10() -> Double {
    let multiplier = 10.0
    return (self / multiplier).rounded() * multiplier
  }

  func roundedTo20() -> Double {
    let multiplier = 20.0
    return (self / multiplier).rounded() * multiplier
  }

  func roundedTo30() -> Double {
    let multiplier = 30.0
    return (self / multiplier).rounded() * multiplier
  }

  func roundedToIntvl(_ intvl: Intvl) -> Double {
    switch intvl {
    case .i50m:
      return self.roundedToP25()

    case .i100m:
      return self.roundedToP5()

    case .i200m:
      return self.rounded()

    case .i400m:
      return self.roundedTo2()

    case .i800m:
      return self.roundedTo4()

    case .i1000m, .i1km:
      return self.roundedTo5()

    case .i2000m, .i2km:
      return self.roundedTo10()

    case .i5000m, .i5km:
      return self.roundedTo30()

    // N/A Not used for profiles (freestyle only)
    case .i1200m, .i1500m, .i3000m, .i4000m, .i10000m, .i10km, .i1mile:
      return self
    }
  }
}
