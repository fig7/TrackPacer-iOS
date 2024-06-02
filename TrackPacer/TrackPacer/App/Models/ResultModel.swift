//
//  ResultModel.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 29/05/2024.
//

import Foundation

class ResultModel {
  private(set) var runData      = RunData()
  private(set) var runDataExtra = RunDataExtra()

  func setPacingDate()                  { runData.runDate = Date() }
  func setRunDist(_ runDist: String)    { runData.runDist = runDist }
  func setRunLane(_ runLane: Int)       { runData.runLane = runLane }
  func setRunProf(_ runProf: String)    { runData.runProf = runProf }

  func setTotalDist(_ totalDistStr: String) { runData.totalDistStr = totalDistStr }
  func setTotalTime(_ totalTimeStr: String) { runData.totalTimeStr = totalTimeStr }
  func setTotalPace(_ totalPaceStr: String) { runData.totalPaceStr = totalPaceStr }

  func setActualTime(_ actualTimeStr: String) { runData.actualTimeStr = actualTimeStr }
  func setActualPace(_ actualPaceStr: String) { runData.actualPaceStr = actualPaceStr }
  func setEarlyLate(_ earlyLateStr: String)   { runData.earlyLateStr  = earlyLateStr }

  func setRunNotes(_ runNotes: String) { runData.runNotes = runNotes }
}
