//
//  String.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 25/05/2024.
//

import Foundation

extension String {
  func trim() -> String { return self.trimmingCharacters(in: .whitespaces) }

  func substring(_ from: Int) -> String {
    let startIndex = self.index(self.startIndex, offsetBy: from)
    return String(self[startIndex...])
  }
}
