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
  private(set) var resultData = ResultData()

  func setPacingDate()                  { resultData.runDate = Date() }
  func setRunDist(_ runDist: String)    { resultData.runDist = runDist }
  func setRunLane(_ runLane: Int)       { resultData.runLane = runLane }
  func setRunProf(_ runProf: String)    { resultData.runProf = runProf }

  func setTotalDist(_ totalDistStr: String) { resultData.totalDistStr = totalDistStr }
  func setTotalTime(_ totalTimeStr: String) { resultData.totalTimeStr = totalTimeStr }
  func setTotalPace(_ totalPaceStr: String) { resultData.totalPaceStr = totalPaceStr }

  func setActualTime(_ actualTimeStr: String) { resultData.actualTimeStr = actualTimeStr }
  func setActualPace(_ actualPaceStr: String) { resultData.actualPaceStr = actualPaceStr }
  func setEarlyLate(_ earlyLateStr: String)   { resultData.earlyLateStr  = earlyLateStr }

  func setRunNotes(_ runNotes: String) { resultData.runNotes = runNotes }
}
