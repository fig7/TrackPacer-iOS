//
//  ClipsModel.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 16/07/2024.
//

import Foundation

typealias DefaultClipCat = (String, [(String, (String, String))])

private let defaultClips: [DefaultClipCat] = [
  ("Get ready"   , [("On your marks", (R.raw.oym, "")),
                   ("Set",           (R.raw.set, ""))]),

  ("Start"       , [("321Go!",       (R.raw.threetwoone, "")),
                   ("321Go! (tts)", ("",                "{ \"locale\":\"Default\", \"voice\":\"\", \"rate\":\"1.0\", \"text\":\"3 2 1 Go!\" }"))]),

  ("Quick start" , [("Go!",       (R.raw.go, "")),
                   ("Go! (tts)", ("",       "{ \"locale\":\"Default\", \"voice\":\"\", \"rate\":\"1.0\", \"text\":\"Go!\" }"))]),

  ("Waypoints"   , [("50m",  (R.raw.fifty,                "")),
                   ("100m", (R.raw.onehundred,           "")),
                   ("150m", (R.raw.onehundredandfifty,   "")),
                   ("200m", (R.raw.twohundred,           "")),
                   ("250m", (R.raw.twohundredandfifty,   "")),
                   ("300m", (R.raw.threehundred,         "")),
                   ("350m", (R.raw.threehundredandfifty, ""))]),

  ("Laps"        , [("Lap 2",  (R.raw.lap2,  "")),
                   ("Lap 3",  (R.raw.lap3,  "")),
                   ("Lap 4",  (R.raw.lap4,  "")),
                   ("Lap 5",  (R.raw.lap5,  "")),
                   ("Lap 6",  (R.raw.lap6,  "")),
                   ("Lap 7",  (R.raw.lap7,  "")),
                   ("Lap 8",  (R.raw.lap8,  "")),
                   ("Lap 9",  (R.raw.lap9,  "")),
                   ("Lap 10", (R.raw.lap10, "")),
                   ("Lap 11", (R.raw.lap11, "")),
                   ("Lap 12", (R.raw.lap12, "")),
                   ("Lap 13", (R.raw.lap13, "")),
                   ("Lap 14", (R.raw.lap14, "")),
                   ("Lap 15", (R.raw.lap15, "")),
                   ("Lap 16", (R.raw.lap16, "")),
                   ("Lap 17", (R.raw.lap17, "")),
                   ("Lap 18", (R.raw.lap18, "")),
                   ("Lap 19", (R.raw.lap19, "")),
                   ("Lap 20", (R.raw.lap20, "")),
                   ("Lap 21", (R.raw.lap21, "")),
                   ("Lap 22", (R.raw.lap22, "")),
                   ("Lap 23", (R.raw.lap23, "")),
                   ("Lap 24", (R.raw.lap24, "")),
                   ("Lap 25", (R.raw.lap25, ""))]),

  // Add these as tts (Make ones for waypoints and laps too)
  ("Distance"    , [("50m",    ("", "{ \"locale\":\"Default\", \"voice\":\"\", \"rate\":\"1.0\", \"text\":\"fifty metres\" }")),
                   ("100m",   (R.raw.onehundred,           "")),
                   ("150m",   (R.raw.onehundredandfifty,   "")),
                   ("200m",   (R.raw.twohundred,           "")),
                   ("250m",   (R.raw.twohundredandfifty,   "")),
                   ("300m",   (R.raw.threehundred,         "")),
                   ("350m",   (R.raw.threehundredandfifty, ""))]),

  ("Profile"     , [("Stop and wait", (R.raw.stop, "")),
                   ("30 seconds",    (R.raw.thirty,      "")),
                   ("10 seconds",    (R.raw.ten,         ""))]),

  ("Motivation"  , []),

  ("Finish"      , [("Finish line", (R.raw.finish, ""))]),

  ("Status"      , [("Pacing paused",    (R.raw.paused,    "")),
                   ("Pacing cancelled", (R.raw.cancelled, "")),
                   ("Pacing complete",  (R.raw.complete,  ""))])]

class ClipsModel {
  let clipsManager = ClipsManager(filesDir: URL.documentsDirectory)
  var clipsDataOK = true

  init() {
    do {
      try clipsManager.initClips(defaultClips)
    } catch {
      clipsDataOK = false
      print("Failed to initialize clips. Error: \(error.localizedDescription)")
    }
  }
}
