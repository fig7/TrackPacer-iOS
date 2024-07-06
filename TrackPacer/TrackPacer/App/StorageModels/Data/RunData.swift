//
//  RunData.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 01/06/2024.
//

import Foundation

struct RunData: Codable {
  var runVersion: String = TPVersion

  var runDate: Date!

  var runDist: String = ""
  var runLane: Int    = -1
  var runProf: String = ""

  var totalDistStr: String = ""
  var totalTimeStr: String = ""
  var totalPaceStr: String = ""

  var actualTimeStr: String = ""
  var actualPaceStr: String = ""
  var earlyLateStr:  String = ""

  var runNotes: String = ""
}

struct RunDataExtra {
  var resultUUID: UUID?

  var shortRunDist: String = ""
  var shortRunDate: String = ""
  var fullRunDate: String  = ""

  init() { }

  init(_ runDist: String, _ runDate: Date) {
    shortRunDist = runDist.hasSuffix(" (AS)") ? String(runDist.dropLast(5)) : runDist

    let formatter = DateFormatter()
    formatter.dateFormat = "d MMM, yyyy 'at' HH:mm"
    fullRunDate  = formatter.string(from: runDate)

    formatter.dateFormat = nil
    formatter.dateStyle = .short
    shortRunDate = formatter.string(from: runDate)
  }

  init(_ resultUUID: UUID, _ runDist: String, _ runDate: Date) {
    self.init(runDist, runDate)
    self.resultUUID = resultUUID
  }
}
