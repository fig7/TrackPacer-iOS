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

  func setPacingDate()                 { runData.runDate  = Date() }
  func setBaseDist(_ baseDist: String) { runData.baseDist = baseDist }
  func setRunLane(_ runLane: Int)      { runData.runLane  = runLane }
  func setRunProf(_ runProf: String)   { runData.runProf  = runProf }

  func setRunDist(_ runDistStr: String) { runData.runDistStr = runDistStr }
  func setRunTime(_ runTimeStr: String) { runData.runTimeStr = runTimeStr }
  func setRunPace(_ runPaceStr: String) { runData.runPaceStr = runPaceStr }

  func setActualTime(_ actualTimeStr: String) { runData.actualTimeStr = actualTimeStr }
  func setActualPace(_ actualPaceStr: String) { runData.actualPaceStr = actualPaceStr }
  func setEarlyLate(_ earlyLateStr: String)   { runData.earlyLateStr  = earlyLateStr }

  func setRunNotes(_ runNotes: String) { runData.runNotes = runNotes }
}
