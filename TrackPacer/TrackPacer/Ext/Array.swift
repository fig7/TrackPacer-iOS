//
//  Array.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 22/05/2024.
//

import Foundation

extension Array {
  var size: Int {
    get {
      return count
    }
  }

  mutating func add(_ element: Element) {
    append(element)
  }

  mutating func clear()
  { removeAll() }
}
