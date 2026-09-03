//
//  TimeEdit.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 28/05/2024.
//

import Foundation

enum EditResponse { case UserCancel, UserDelete, UserAdd, UserSet }

@MainActor class TimeEdit: ObservableObject {
  unowned let timeSelection: TimeSelection

  init(_ timeSelection: TimeSelection) {
    self.timeSelection = timeSelection
  }

  var unit = "Pace"
  @Published var dist = "400m"
  @Published var mins = 0 { didSet { updateComputed() } }
  @Published var secs = 0 { didSet { updateComputed() } }
  @Published var hths = 0 { didSet { updateComputed() } }

  @Published var timeStr  = ""
  @Published var editOK   = true
  @Published var deleteOK = true

  @Published var editAction: EditResponse = .UserCancel

  private func timeInvalid() -> Bool {
    // TODO: This should really use a waypoint check (e.g. min 5s between waypoints)
    return (unit == "Pace") ? ((mins < 1) || ((mins == 1) && (secs < 40))) : ((mins == 0) && (secs < 40))
  }

  private func timeDuplicate() -> Bool {
    return timeSelection.contains(timeStr)
  }

  private func updateComputed() {
    timeStr  = strFromMSH(mins, secs, hths)

    editOK   = !timeInvalid() && !timeDuplicate()
    deleteOK = (timeSelection.list.count > 1)
  }
}
