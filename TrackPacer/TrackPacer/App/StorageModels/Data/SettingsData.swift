//
//  SettingsData.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 03/06/2024.
//

import Foundation

struct SettingsData: Codable {
  var startDelay     = "5.00"
  var powerStart     = false
  var quickStart     = false
  var alternateStart = false
  var flightMode     = true
}
