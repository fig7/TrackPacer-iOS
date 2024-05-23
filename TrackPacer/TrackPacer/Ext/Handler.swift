//
//  Handler.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 22/05/2024.
//

import Foundation

struct Handler
{
  func post(_ runnable: @escaping Runnable) {
    Task { @MainActor in
      runnable(0)
    }
  }

  func postDelayed(_ runnable: @escaping Runnable, delayMS: Int64) {
    Task { @MainActor in
      runnable(delayMS)
    }
  }
}
