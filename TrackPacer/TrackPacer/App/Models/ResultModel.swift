//
//  ResultModel.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 29/05/2024.
//

import Foundation

struct ResultData {
  var runVersion: String = TPVersion
  var resultUUID: String = ""

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

class ResultModel {
  var resultData = ResultData()

  func setPacingDate() { resultData.runDate = Date() }
}
