//
//  TrackPacerApp.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 10/05/2024.
//

import SwiftUI

@main struct TrackPacerApp: App {
  @State private var mainViewModel: MainViewModel

  init() {
    mainViewModel = MainViewModel()
  }

  var body: some Scene {
    WindowGroup {
      ContentView(viewModel: mainViewModel)
    }
  }
}
