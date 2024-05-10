//
//  TrackPacerApp.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 10/05/2024.
//

import SwiftUI

@main struct TrackPacerApp: App {
  @State private var tpDataModel: TPDataModel

  init() {
    let distanceSelection = DistanceSelection()
    tpDataModel           = TPDataModel(distanceSelection: distanceSelection)
  }

  var body: some Scene {
    WindowGroup {
      ContentView(model: tpDataModel)
    }
  }
}
