//
//  StringProtocol.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 14/06/2024.
//

import Foundation

extension StringProtocol {
  func toInt() throws -> Int {
    let result = Int(self)
    guard let result else { throw Exception.NumberFormatException }

    return result
  }

  func toInt64() throws -> Int64
  {
    let result = Int64(self)
    guard let result else { throw Exception.NumberFormatException }

    return result
  }

  func toLong() throws -> Int64
  { return try toInt64() }

  func toDouble() throws -> Double {
    let result = Double(self)
    guard let result else { throw Exception.NumberFormatException }

    return result
  }
}
