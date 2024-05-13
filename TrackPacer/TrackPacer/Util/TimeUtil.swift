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
let baseTimeAll = "%@%@:%@:%@.%@"

func timeToString(timeInMS: Int64) -> String {
  var timeLeft = abs(timeInMS)
  let sgnStr   = (timeInMS < 0) ? "-" : ""

  var hrs = timeLeft / 3600000
  timeLeft -= hrs * 3600000

  var mins = timeLeft / 60000
  timeLeft -= mins * 60000

  var secs = timeLeft / 1000
  timeLeft -= secs * 1000

  if(((hrs > 0) || (mins > 0)) && (timeLeft > 0)) {
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
