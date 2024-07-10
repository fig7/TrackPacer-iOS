//
//  RT.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 27/05/2024.
//

import Foundation

let rtMap = [
  "rt_400m_l1"   : [R.string.laps_400, R.string.empty, R.string.empty, R.drawable.rt_400_l1, R.drawable.rt_400_l1_ck],
  "rt_400m_l2"   : [R.string.laps_400, R.string.empty, R.string.empty, R.drawable.rt_400_l2, R.drawable.rt_400_l2_ck],
  "rt_400m_l3"   : [R.string.laps_400, R.string.empty, R.string.empty, R.drawable.rt_400_l3, R.drawable.rt_400_l3_ck],
  "rt_400m_l4"   : [R.string.laps_400, R.string.empty, R.string.empty, R.drawable.rt_400_l4, R.drawable.rt_400_l4_ck],
  "rt_400m_l5"   : [R.string.laps_400, R.string.empty, R.string.empty, R.drawable.rt_400_l5, R.drawable.rt_400_l5_ck],
  "rt_400m_l6"   : [R.string.laps_400, R.string.empty, R.string.empty, R.drawable.rt_400_l6, R.drawable.rt_400_l6_ck],
  "rt_400m_l7"   : [R.string.laps_400, R.string.empty, R.string.empty, R.drawable.rt_400_l7, R.drawable.rt_400_l7_ck],
  "rt_400m_l8"   : [R.string.laps_400, R.string.empty, R.string.empty, R.drawable.rt_400_l8, R.drawable.rt_400_l8_ck],

  "rt_800m_l1"   : [R.string.laps_800, R.string.ll_2, R.string.empty, R.drawable.rt_400_l1, R.drawable.rt_400_l1_ck],
  "rt_800m_l2"   : [R.string.laps_800, R.string.ll_2, R.string.empty, R.drawable.rt_400_l2, R.drawable.rt_400_l2_ck],
  "rt_800m_l3"   : [R.string.laps_800, R.string.ll_2, R.string.empty, R.drawable.rt_400_l3, R.drawable.rt_400_l3_ck],
  "rt_800m_l4"   : [R.string.laps_800, R.string.ll_2, R.string.empty, R.drawable.rt_400_l4, R.drawable.rt_400_l4_ck],
  "rt_800m_l5"   : [R.string.laps_800, R.string.ll_2, R.string.empty, R.drawable.rt_400_l5, R.drawable.rt_400_l5_ck],
  "rt_800m_l6"   : [R.string.laps_800, R.string.ll_2, R.string.empty, R.drawable.rt_400_l6, R.drawable.rt_400_l6_ck],
  "rt_800m_l7"   : [R.string.laps_800, R.string.ll_2, R.string.empty, R.drawable.rt_400_l7, R.drawable.rt_400_l7_ck],
  "rt_800m_l8"   : [R.string.laps_800, R.string.ll_2, R.string.empty, R.drawable.rt_400_l8, R.drawable.rt_400_l8_ck],

  "rt_1000m_l1"  : [R.string.laps_1000, R.string.fl_200m, R.string.ll_3, R.drawable.rt_1000_l1, R.drawable.rt_1000_l1_ck],
  "rt_1000m_l2"  : [R.string.laps_1000, R.string.fl_200m, R.string.ll_3, R.drawable.rt_1000_l2, R.drawable.rt_1000_l2_ck],
  "rt_1000m_l3"  : [R.string.laps_1000, R.string.fl_200m, R.string.ll_3, R.drawable.rt_1000_l3, R.drawable.rt_1000_l3_ck],
  "rt_1000m_l4"  : [R.string.laps_1000, R.string.fl_200m, R.string.ll_3, R.drawable.rt_1000_l4, R.drawable.rt_1000_l4_ck],
  "rt_1000m_l5"  : [R.string.laps_1000, R.string.fl_200m, R.string.ll_3, R.drawable.rt_1000_l5, R.drawable.rt_1000_l5_ck],
  "rt_1000m_l6"  : [R.string.laps_1000, R.string.fl_200m, R.string.ll_3, R.drawable.rt_1000_l6, R.drawable.rt_1000_l6_ck],
  "rt_1000m_l7"  : [R.string.laps_1000, R.string.fl_200m, R.string.ll_3, R.drawable.rt_1000_l7, R.drawable.rt_1000_l7_ck],
  "rt_1000m_l8"  : [R.string.laps_1000, R.string.fl_200m, R.string.ll_3, R.drawable.rt_1000_l8, R.drawable.rt_1000_l8_ck],

  "rt_1000m (AS)_l1"  : [R.string.laps_1000, R.string.ll_200m, R.string.ll_3, R.drawable.rt_1000_l1_a, R.drawable.rt_1000_l1_a_ck],
  "rt_1000m (AS)_l2"  : [R.string.laps_1000, R.string.ll_200m, R.string.ll_3, R.drawable.rt_1000_l2_a, R.drawable.rt_1000_l2_a_ck],
  "rt_1000m (AS)_l3"  : [R.string.laps_1000, R.string.ll_200m, R.string.ll_3, R.drawable.rt_1000_l3_a, R.drawable.rt_1000_l3_a_ck],
  "rt_1000m (AS)_l4"  : [R.string.laps_1000, R.string.ll_200m, R.string.ll_3, R.drawable.rt_1000_l4_a, R.drawable.rt_1000_l4_a_ck],
  "rt_1000m (AS)_l5"  : [R.string.laps_1000, R.string.ll_200m, R.string.ll_3, R.drawable.rt_1000_l5_a, R.drawable.rt_1000_l5_a_ck],
  "rt_1000m (AS)_l6"  : [R.string.laps_1000, R.string.ll_200m, R.string.ll_3, R.drawable.rt_1000_l6_a, R.drawable.rt_1000_l6_a_ck],
  "rt_1000m (AS)_l7"  : [R.string.laps_1000, R.string.ll_200m, R.string.ll_3, R.drawable.rt_1000_l7_a, R.drawable.rt_1000_l7_a_ck],
  "rt_1000m (AS)_l8"  : [R.string.laps_1000, R.string.ll_200m, R.string.ll_3, R.drawable.rt_1000_l8_a, R.drawable.rt_1000_l8_a_ck],

  "rt_1200m_l1"  : [R.string.laps_1200, R.string.ll_3, R.string.empty, R.drawable.rt_400_l1, R.drawable.rt_400_l1_ck],
  "rt_1200m_l2"  : [R.string.laps_1200, R.string.ll_3, R.string.empty, R.drawable.rt_400_l2, R.drawable.rt_400_l2_ck],
  "rt_1200m_l3"  : [R.string.laps_1200, R.string.ll_3, R.string.empty, R.drawable.rt_400_l3, R.drawable.rt_400_l3_ck],
  "rt_1200m_l4"  : [R.string.laps_1200, R.string.ll_3, R.string.empty, R.drawable.rt_400_l4, R.drawable.rt_400_l4_ck],
  "rt_1200m_l5"  : [R.string.laps_1200, R.string.ll_3, R.string.empty, R.drawable.rt_400_l5, R.drawable.rt_400_l5_ck],
  "rt_1200m_l6"  : [R.string.laps_1200, R.string.ll_3, R.string.empty, R.drawable.rt_400_l6, R.drawable.rt_400_l6_ck],
  "rt_1200m_l7"  : [R.string.laps_1200, R.string.ll_3, R.string.empty, R.drawable.rt_400_l7, R.drawable.rt_400_l7_ck],
  "rt_1200m_l8"  : [R.string.laps_1200, R.string.ll_3, R.string.empty, R.drawable.rt_400_l8, R.drawable.rt_400_l8_ck],

  "rt_1500m_l1"  : [R.string.laps_1500, R.string.fl_300m, R.string.ll_4, R.drawable.rt_1500_l1, R.drawable.rt_1500_l1_ck],
  "rt_1500m_l2"  : [R.string.laps_1500, R.string.fl_300m, R.string.ll_4, R.drawable.rt_1500_l2, R.drawable.rt_1500_l2_ck],
  "rt_1500m_l3"  : [R.string.laps_1500, R.string.fl_300m, R.string.ll_4, R.drawable.rt_1500_l3, R.drawable.rt_1500_l3_ck],
  "rt_1500m_l4"  : [R.string.laps_1500, R.string.fl_300m, R.string.ll_4, R.drawable.rt_1500_l4, R.drawable.rt_1500_l4_ck],
  "rt_1500m_l5"  : [R.string.laps_1500, R.string.fl_300m, R.string.ll_4, R.drawable.rt_1500_l5, R.drawable.rt_1500_l5_ck],
  "rt_1500m_l6"  : [R.string.laps_1500, R.string.fl_300m, R.string.ll_4, R.drawable.rt_1500_l6, R.drawable.rt_1500_l6_ck],
  "rt_1500m_l7"  : [R.string.laps_1500, R.string.fl_300m, R.string.ll_4, R.drawable.rt_1500_l7, R.drawable.rt_1500_l7_ck],
  "rt_1500m_l8"  : [R.string.laps_1500, R.string.fl_300m, R.string.ll_4, R.drawable.rt_1500_l8, R.drawable.rt_1500_l8_ck],

  "rt_2000m_l1"  : [R.string.laps_2000, R.string.ll_5, R.string.empty, R.drawable.rt_400_l1, R.drawable.rt_400_l1_ck],
  "rt_2000m_l2"  : [R.string.laps_2000, R.string.ll_5, R.string.empty, R.drawable.rt_400_l2, R.drawable.rt_400_l2_ck],
  "rt_2000m_l3"  : [R.string.laps_2000, R.string.ll_5, R.string.empty, R.drawable.rt_400_l3, R.drawable.rt_400_l3_ck],
  "rt_2000m_l4"  : [R.string.laps_2000, R.string.ll_5, R.string.empty, R.drawable.rt_400_l4, R.drawable.rt_400_l4_ck],
  "rt_2000m_l5"  : [R.string.laps_2000, R.string.ll_5, R.string.empty, R.drawable.rt_400_l5, R.drawable.rt_400_l5_ck],
  "rt_2000m_l6"  : [R.string.laps_2000, R.string.ll_5, R.string.empty, R.drawable.rt_400_l6, R.drawable.rt_400_l6_ck],
  "rt_2000m_l7"  : [R.string.laps_2000, R.string.ll_5, R.string.empty, R.drawable.rt_400_l7, R.drawable.rt_400_l7_ck],
  "rt_2000m_l8"  : [R.string.laps_2000, R.string.ll_5, R.string.empty, R.drawable.rt_400_l8, R.drawable.rt_400_l8_ck],

  "rt_3000m_l1"  : [R.string.laps_3000, R.string.fl_200m, R.string.ll_8, R.drawable.rt_1000_l1, R.drawable.rt_1000_l1_ck],
  "rt_3000m_l2"  : [R.string.laps_3000, R.string.fl_200m, R.string.ll_8, R.drawable.rt_1000_l2, R.drawable.rt_1000_l2_ck],
  "rt_3000m_l3"  : [R.string.laps_3000, R.string.fl_200m, R.string.ll_8, R.drawable.rt_1000_l3, R.drawable.rt_1000_l3_ck],
  "rt_3000m_l4"  : [R.string.laps_3000, R.string.fl_200m, R.string.ll_8, R.drawable.rt_1000_l4, R.drawable.rt_1000_l4_ck],
  "rt_3000m_l5"  : [R.string.laps_3000, R.string.fl_200m, R.string.ll_8, R.drawable.rt_1000_l5, R.drawable.rt_1000_l5_ck],
  "rt_3000m_l6"  : [R.string.laps_3000, R.string.fl_200m, R.string.ll_8, R.drawable.rt_1000_l6, R.drawable.rt_1000_l6_ck],
  "rt_3000m_l7"  : [R.string.laps_3000, R.string.fl_200m, R.string.ll_8, R.drawable.rt_1000_l7, R.drawable.rt_1000_l7_ck],
  "rt_3000m_l8"  : [R.string.laps_3000, R.string.fl_200m, R.string.ll_8, R.drawable.rt_1000_l8, R.drawable.rt_1000_l8_ck],

  "rt_3000m (AS)_l1"  : [R.string.laps_3000, R.string.ll_200m, R.string.ll_8, R.drawable.rt_1000_l1_a, R.drawable.rt_1000_l1_a_ck],
  "rt_3000m (AS)_l2"  : [R.string.laps_3000, R.string.ll_200m, R.string.ll_8, R.drawable.rt_1000_l2_a, R.drawable.rt_1000_l2_a_ck],
  "rt_3000m (AS)_l3"  : [R.string.laps_3000, R.string.ll_200m, R.string.ll_8, R.drawable.rt_1000_l3_a, R.drawable.rt_1000_l3_a_ck],
  "rt_3000m (AS)_l4"  : [R.string.laps_3000, R.string.ll_200m, R.string.ll_8, R.drawable.rt_1000_l4_a, R.drawable.rt_1000_l4_a_ck],
  "rt_3000m (AS)_l5"  : [R.string.laps_3000, R.string.ll_200m, R.string.ll_8, R.drawable.rt_1000_l5_a, R.drawable.rt_1000_l5_a_ck],
  "rt_3000m (AS)_l6"  : [R.string.laps_3000, R.string.ll_200m, R.string.ll_8, R.drawable.rt_1000_l6_a, R.drawable.rt_1000_l6_a_ck],
  "rt_3000m (AS)_l7"  : [R.string.laps_3000, R.string.ll_200m, R.string.ll_8, R.drawable.rt_1000_l7_a, R.drawable.rt_1000_l7_a_ck],
  "rt_3000m (AS)_l8"  : [R.string.laps_3000, R.string.ll_200m, R.string.ll_8, R.drawable.rt_1000_l8_a, R.drawable.rt_1000_l8_a_ck],

  "rt_4000m_l1"  : [R.string.laps_4000, R.string.ll_10, R.string.empty, R.drawable.rt_400_l1, R.drawable.rt_400_l1_ck],
  "rt_4000m_l2"  : [R.string.laps_4000, R.string.ll_10, R.string.empty, R.drawable.rt_400_l2, R.drawable.rt_400_l2_ck],
  "rt_4000m_l3"  : [R.string.laps_4000, R.string.ll_10, R.string.empty, R.drawable.rt_400_l3, R.drawable.rt_400_l3_ck],
  "rt_4000m_l4"  : [R.string.laps_4000, R.string.ll_10, R.string.empty, R.drawable.rt_400_l4, R.drawable.rt_400_l4_ck],
  "rt_4000m_l5"  : [R.string.laps_4000, R.string.ll_10, R.string.empty, R.drawable.rt_400_l5, R.drawable.rt_400_l5_ck],
  "rt_4000m_l6"  : [R.string.laps_4000, R.string.ll_10, R.string.empty, R.drawable.rt_400_l6, R.drawable.rt_400_l6_ck],
  "rt_4000m_l7"  : [R.string.laps_4000, R.string.ll_10, R.string.empty, R.drawable.rt_400_l7, R.drawable.rt_400_l7_ck],
  "rt_4000m_l8"  : [R.string.laps_4000, R.string.ll_10, R.string.empty, R.drawable.rt_400_l8, R.drawable.rt_400_l8_ck],

  "rt_5000m_l1"  : [R.string.laps_5000, R.string.fl_200m, R.string.ll_13, R.drawable.rt_1000_l1, R.drawable.rt_1000_l1_ck],
  "rt_5000m_l2"  : [R.string.laps_5000, R.string.fl_200m, R.string.ll_13, R.drawable.rt_1000_l2, R.drawable.rt_1000_l2_ck],
  "rt_5000m_l3"  : [R.string.laps_5000, R.string.fl_200m, R.string.ll_13, R.drawable.rt_1000_l3, R.drawable.rt_1000_l3_ck],
  "rt_5000m_l4"  : [R.string.laps_5000, R.string.fl_200m, R.string.ll_13, R.drawable.rt_1000_l4, R.drawable.rt_1000_l4_ck],
  "rt_5000m_l5"  : [R.string.laps_5000, R.string.fl_200m, R.string.ll_13, R.drawable.rt_1000_l5, R.drawable.rt_1000_l5_ck],
  "rt_5000m_l6"  : [R.string.laps_5000, R.string.fl_200m, R.string.ll_13, R.drawable.rt_1000_l6, R.drawable.rt_1000_l6_ck],
  "rt_5000m_l7"  : [R.string.laps_5000, R.string.fl_200m, R.string.ll_13, R.drawable.rt_1000_l7, R.drawable.rt_1000_l7_ck],
  "rt_5000m_l8"  : [R.string.laps_5000, R.string.fl_200m, R.string.ll_13, R.drawable.rt_1000_l8, R.drawable.rt_1000_l8_ck],

  "rt_5000m (AS)_l1"  : [R.string.laps_5000, R.string.ll_200m, R.string.ll_13, R.drawable.rt_1000_l1_a, R.drawable.rt_1000_l1_a_ck],
  "rt_5000m (AS)_l2"  : [R.string.laps_5000, R.string.ll_200m, R.string.ll_13, R.drawable.rt_1000_l2_a, R.drawable.rt_1000_l2_a_ck],
  "rt_5000m (AS)_l3"  : [R.string.laps_5000, R.string.ll_200m, R.string.ll_13, R.drawable.rt_1000_l3_a, R.drawable.rt_1000_l3_a_ck],
  "rt_5000m (AS)_l4"  : [R.string.laps_5000, R.string.ll_200m, R.string.ll_13, R.drawable.rt_1000_l4_a, R.drawable.rt_1000_l4_a_ck],
  "rt_5000m (AS)_l5"  : [R.string.laps_5000, R.string.ll_200m, R.string.ll_13, R.drawable.rt_1000_l5_a, R.drawable.rt_1000_l5_a_ck],
  "rt_5000m (AS)_l6"  : [R.string.laps_5000, R.string.ll_200m, R.string.ll_13, R.drawable.rt_1000_l6_a, R.drawable.rt_1000_l6_a_ck],
  "rt_5000m (AS)_l7"  : [R.string.laps_5000, R.string.ll_200m, R.string.ll_13, R.drawable.rt_1000_l7_a, R.drawable.rt_1000_l7_a_ck],
  "rt_5000m (AS)_l8"  : [R.string.laps_5000, R.string.ll_200m, R.string.ll_13, R.drawable.rt_1000_l8_a, R.drawable.rt_1000_l8_a_ck],

  "rt_10000m_l1" : [R.string.laps_10000, R.string.ll_25, R.string.empty, R.drawable.rt_400_l1, R.drawable.rt_400_l1_ck],
  "rt_10000m_l2" : [R.string.laps_10000, R.string.ll_25, R.string.empty, R.drawable.rt_400_l2, R.drawable.rt_400_l2_ck],
  "rt_10000m_l3" : [R.string.laps_10000, R.string.ll_25, R.string.empty, R.drawable.rt_400_l3, R.drawable.rt_400_l3_ck],
  "rt_10000m_l4" : [R.string.laps_10000, R.string.ll_25, R.string.empty, R.drawable.rt_400_l4, R.drawable.rt_400_l4_ck],
  "rt_10000m_l5" : [R.string.laps_10000, R.string.ll_25, R.string.empty, R.drawable.rt_400_l5, R.drawable.rt_400_l5_ck],
  "rt_10000m_l6" : [R.string.laps_10000, R.string.ll_25, R.string.empty, R.drawable.rt_400_l6, R.drawable.rt_400_l6_ck],
  "rt_10000m_l7" : [R.string.laps_10000, R.string.ll_25, R.string.empty, R.drawable.rt_400_l7, R.drawable.rt_400_l7_ck],
  "rt_10000m_l8" : [R.string.laps_10000, R.string.ll_25, R.string.empty, R.drawable.rt_400_l8, R.drawable.rt_400_l8_ck],

  "rt_1 mile_l1" : [R.string.laps_mile, R.string.fl_mile, R.string.ll_4, R.drawable.rt_mile_l1, R.drawable.rt_mile_l1_ck],
  "rt_1 mile_l2" : [R.string.laps_mile, R.string.fl_mile, R.string.ll_4, R.drawable.rt_mile_l2, R.drawable.rt_mile_l2_ck],
  "rt_1 mile_l3" : [R.string.laps_mile, R.string.fl_mile, R.string.ll_4, R.drawable.rt_mile_l3, R.drawable.rt_mile_l3_ck],
  "rt_1 mile_l4" : [R.string.laps_mile, R.string.fl_mile, R.string.ll_4, R.drawable.rt_mile_l4, R.drawable.rt_mile_l4_ck],
  "rt_1 mile_l5" : [R.string.laps_mile, R.string.fl_mile, R.string.ll_4, R.drawable.rt_mile_l5, R.drawable.rt_mile_l5_ck],
  "rt_1 mile_l6" : [R.string.laps_mile, R.string.fl_mile, R.string.ll_4, R.drawable.rt_mile_l6, R.drawable.rt_mile_l6_ck],
  "rt_1 mile_l7" : [R.string.laps_mile, R.string.fl_mile, R.string.ll_4, R.drawable.rt_mile_l7, R.drawable.rt_mile_l7_ck],
  "rt_1 mile_l8" : [R.string.laps_mile, R.string.fl_mile, R.string.ll_4, R.drawable.rt_mile_l8, R.drawable.rt_mile_l8_ck]]

func rtKeyFromArgs(_ baseDist: String, _ runLane: Int) -> String {
  let rtKey = "rt_" + baseDist + "_l" + runLane.toString()
  return rtKey
}

func rtLaps(_ baseDist: String, _ runLane: Int) -> String {
  let rtKey   = rtKeyFromArgs(baseDist, runLane)
  let rtArray = rtMap[rtKey]!
  return rtArray[0]
}

func rtDesc1(_ baseDist: String, _ runLane: Int) -> String {
  let rtKey = rtKeyFromArgs(baseDist, runLane)
  let rtArray = rtMap[rtKey]!
  return rtArray[1]
}

func rtDesc2(_ baseDist: String, _ runLane: Int) -> String {
  let rtKey = rtKeyFromArgs(baseDist, runLane)
  let rtArray = rtMap[rtKey]!
  return rtArray[2]
}

func rtOverlay(_ runDist: String, _ runLane: Int, _ runClockwise: Bool) -> String {
  let rtKey = rtKeyFromArgs(runDist, runLane)
  let rtArray = rtMap[rtKey]!
  return runClockwise ? rtArray[4] : rtArray[3]
}

