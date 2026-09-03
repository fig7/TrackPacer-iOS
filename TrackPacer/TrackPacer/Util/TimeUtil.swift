//
//  TimeUtil.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 13/05/2024.
//

import Foundation

let baseTimeS   = "%@%@.%@"
let baseTimeMS  = "%@%@:%@"
let baseTimeHMS = "%@%@:%@:%@"
let baseTimeMSS = "%@%@:%@.%@"
let baseTimeAll = "%@%@:%@:%@.%@"

let editTimeS  = "%@.%@"
let editTimeMS = "%@:%@.%@"

func timeToString(timeInMS: Int64, roundUp: Bool = true) -> String {
  var timeLeft = abs(timeInMS)
  let sgnStr   = (timeInMS < 0) ? "-" : ""

  var hrs = timeLeft / 3600000
  timeLeft -= hrs * 3600000

  var mins = timeLeft / 60000
  timeLeft -= mins * 60000

  var secs = timeLeft / 1000
  timeLeft -= secs * 1000

  let roundUp2 = roundUp || (timeLeft >= 500)
  if(roundUp2 && ((hrs > 0) || (mins > 0)) && (timeLeft > 0)) {
    secs += 1
    if(secs == 60) {
      secs = 0
      mins += 1
      if(mins == 60) {
        mins = 0
        hrs += 1
      }
    }
  }

  if(hrs > 0) {
    let hrsStr  = String(format: "%d", hrs)
    let minsStr = String(format: "%02d", mins)
    let secsStr = String(format: "%02d", secs)
    return String(format: baseTimeHMS, sgnStr, hrsStr, minsStr, secsStr)
  } else if(mins > 0) {
    let minsStr = String(format: "%d", mins)
    let secsStr = String(format: "%02d", secs)
    return String(format: baseTimeMS, sgnStr, minsStr, secsStr)
  } else {
    let secsStr = String(format: "%d", secs)
    let msStr   = String(format: "%03d", timeLeft)
    return String(format: baseTimeS, sgnStr, secsStr, msStr)
    }
}

func timeToMinuteString(timeInMS: Int64) -> String {
  var timeLeft = abs(timeInMS)
  let sgnStr   = (timeInMS < 0) ? "-" : ""

  var hrs = timeLeft / 3600000
  timeLeft -= hrs * 3600000

  var mins = timeLeft / 60000
  timeLeft -= mins * 60000

  var secs = timeLeft / 1000

  // Round up
  secs += 1
  if(secs == 60) {
    secs = 0
    mins += 1
    if(mins == 60) {
      mins = 0
      hrs += 1
    }
  }

  if(hrs > 0) {
    let hrsStr  = String(format: "%d", hrs)
    let minsStr = String(format: "%02d", mins)
    let secsStr = String(format: "%02d", secs)
    return String(format: baseTimeHMS, sgnStr, hrsStr, minsStr, secsStr)
  } else {
    let minsStr = String(format: "%d", mins)
    let secsStr = String(format: "%02d", secs)
    return String(format: baseTimeMS, sgnStr, minsStr, secsStr)
  }
}

func timeToMinuteString2(timeInMS: Int64) -> String {
  var timeLeft = abs(timeInMS)
  let sgnStr   = (timeInMS < 0) ? "-" : ""

  let hrs = timeLeft / 3600000
  timeLeft -= hrs * 3600000

  let mins = timeLeft / 60000
  timeLeft -= mins * 60000

  let secs = timeLeft / 1000
  timeLeft -= secs * 1000

  if(hrs > 0) {
    let hrsStr  = String(format: "%d", hrs)
    let minsStr = String(format: "%02d", mins)
    let secsStr = String(format: "%02d", secs)
    return String(format: baseTimeHMS, sgnStr, hrsStr, minsStr, secsStr)
  } else {
    let minsStr = String(format: "%d", mins)
    let secsStr = String(format: "%02d", secs)
    return String(format: baseTimeMS, sgnStr, minsStr, secsStr)
  }
}

func timeToAlmostFullString(timeInMS: Int64) -> String {
  var timeLeft = abs(timeInMS)
  let sgnStr   = (timeInMS < 0) ? "-" : ""

  let hrs = timeLeft / 3600000
  timeLeft -= hrs * 3600000

  let mins = timeLeft / 60000
  timeLeft -= mins * 60000

  let secs = timeLeft / 1000
  timeLeft -= secs * 1000

  let msStr = String(format: "%02d", timeLeft/10)
  if(hrs > 0) {
    let hrsStr  = String(format: "%d", hrs)
    let minsStr = String(format: "%02d", mins)
    let secsStr = String(format: "%02d", secs)
    return String(format: baseTimeAll, sgnStr, hrsStr, minsStr, secsStr, msStr)
  } else {
    let minsStr = String(format: "%d", mins)
    let secsStr = String(format: "%02d", secs)
    return String(format: baseTimeMSS, sgnStr, minsStr, secsStr, msStr)
  }
}

func timeToFullString(timeInMS: Int64) -> String {
  var timeLeft = abs(timeInMS)
  let sgnStr   = (timeInMS < 0) ? "-" : ""

  let hrs    = timeLeft / 3600000
  let hrsStr = String(format: "%02d", hrs)
  timeLeft -= hrs * 3600000

  let mins    = timeLeft / 60000
  let minsStr = String(format: "%02d", mins)
  timeLeft -= mins * 60000

  let secs    = timeLeft / 1000
  let secsStr = String(format: "%02d", secs)
  timeLeft -= secs * 1000

  let msStr = String(format: "%03d", timeLeft)
  return String(format: baseTimeAll, sgnStr, hrsStr, minsStr, secsStr, msStr)
}

func setTimeFor(_ selectedTime: String) throws -> Double {
  let setTimeSplit = selectedTime.split(separator: ":")
  let setTime0 = try String(setTimeSplit[0]).trim().toLong()
  let setTime1 = try String(setTimeSplit[1]).trim().toDouble()
  return 1000.0*(setTime0.toDouble()*60.0 + setTime1)
}

func mshFromRunTime(_ runTime: Double) -> (mins: Int, secs: Int, hths: Int) {
  let mins = (runTime / 60000.0).toInt()
  let secs = ((runTime - mins.toDouble()*60000.0) / 1000.0).toInt()
  let hths = ((runTime - mins.toDouble()*60000.0 - secs.toDouble()*1000.0)/10.0).toInt()
  return (mins, secs, hths)
}

func strFromMSH(_ mins: Int, _ secs: Int, _ hths: Int) -> String {

  return (mins > 0) ? String(format: editTimeMS, mins.toString(), String(format:"%02d", secs), String(format: "%02d", hths))
                    : String(format: editTimeS,  String(format:"%02d", secs), String(format: "%02d", hths))
}
