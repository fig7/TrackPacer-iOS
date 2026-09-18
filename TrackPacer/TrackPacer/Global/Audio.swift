//
//  Audio.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 27/05/2024.
//

import Foundation

// Clips for the waypoints (see waypointNames in Waypoint.swift)
let clipList = [
  "",

  "fifty", "onehundred", "onehundredandfifty", "twohundred", "twohundredandfifty", "threehundred", "threehundredandfifty",

  "lap2",  "lap3",  "lap4",  "lap5",  "lap6",  "lap7",  "lap8",  "lap9",
  "lap10", "lap11", "lap12", "lap13", "lap14", "lap15", "lap16", "lap17",
  "lap18", "lap19", "lap20", "lap21", "lap22", "lap23", "lap24", "lap25",

  "1000m_110", "2000m_110", "3000m_110", "4000m_110", "5000m_115", "6000m_115", "7000m_114", "8000m_110", "9000m_115",

  "finish", "silent", "silent10"]

let Go1ClipDuration: Int64  = 400
let Go3ClipDuration: Int64  = 3000
let PowerStartOffset: Int64 = 4000

let PowerClipOffset: Int64  = 1000
let ResumeClipOffset: Int64 = 1000
