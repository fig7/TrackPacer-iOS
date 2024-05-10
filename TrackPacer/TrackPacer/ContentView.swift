//
//  ContentView.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 10/05/2024.
//

import SwiftUI

struct ContentView: View {
  let model: TPDataModel

  var body: some View {
    TabView {
      RunView(distanceSelection: model.distanceSelection).tabItem {
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
    }
  }
}
