//
//  ContentView.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 10/05/2024.
//

import SwiftUI

struct ContentView: View {
  let viewModel: MainViewModel

  init(viewModel: MainViewModel) {
    self.viewModel = viewModel
  }

  var body: some View {
    NavigationStack {
      TabView {
        RunView(viewModel: viewModel.runViewModel).tabItem {
          Label("Run", image: "baseline_run_24")
        }

        HistoryView().tabItem {
          Label("History", image: "baseline_history_24")
        }

        AudioView().tabItem {
          Label("Audio", image: "baseline_audio_24")
        }

        SettingsView().tabItem {
          Label("Settings", image: "baseline_settings_24")
        }
      }.navigationDestination(for: Int.self) { selection in
        PaceView(viewModel: viewModel.paceViewModel, runViewModel: viewModel.runViewModel)
      }.toolbar() {
        ToolbarItem(placement: .navigationBarTrailing) {
          StatusView(viewModel: viewModel.statusViewModel)
        }
      }
    }
  }
}
