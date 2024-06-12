//
//  WaypointEdit.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 12/06/2024.
//

import Foundation

@MainActor class WaypointEdit: ObservableObject {
  var waypointIndex = -1
  @Published var atEnd: Bool = false

  @Published var name = ""
  @Published var waypointTime = ""

  @Published var waypointWaitMM = ""
  @Published var waypointWaitSS = ""
}
