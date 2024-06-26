//
//  ContentView.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 10/05/2024.
//

import SwiftUI

struct ContentView: View {
  @EnvironmentObject var viewModel: MainViewModel
  @EnvironmentObject var mainViewStack: MainViewStack

  var body: some View {
    ZStack {
      NavigationStack(path: $mainViewStack.list) {
        TabView {
          RunView().tabItem { Label("Run", image: "baseline_run_24") }
            .environmentObject(viewModel.runViewModel)
            .environmentObject(viewModel.runViewModel.distanceSelection)
            .environmentObject(viewModel.runViewModel.laneSelection)
            .environmentObject(viewModel.runViewModel.timeSelection)
            .environmentObject(viewModel.runViewModel.profileSelection)
            .environmentObject(viewModel.runViewModel.trackSelection)
            .onAppear { viewModel.runViewModel.updateTrackOverlay() }

          HistoryView().tabItem { Label("History", image: "baseline_history_24") }
            .environmentObject(viewModel.historyViewModel)

          AudioView().tabItem { Label("Audio", image: "baseline_audio_24") }

          SettingsView().tabItem { Label("Settings", image: "baseline_settings_24") }
            .environmentObject(viewModel.settingsViewModel)
        }.navigationDestination(for: Int.self) { selection in
          switch(selection) {
          case 1:
            PaceView()
              .environmentObject(viewModel.paceViewModel)
              .environmentObject(viewModel.paceViewModel.pacingOptions)
              .environmentObject(viewModel.paceViewModel.pacingProgress)

              .environmentObject(viewModel.statusViewModel)
              .environmentObject(viewModel.statusViewModel.pacingStatus)
              .environmentObject(viewModel.statusViewModel.pacingSettings)
          case 2:
            CompletionView()
              .environmentObject(viewModel.completionViewModel)
              .environmentObject(viewModel.completionViewModel.resultData)

              .environmentObject(viewModel.statusViewModel)
              .environmentObject(viewModel.statusViewModel.pacingStatus)
              .environmentObject(viewModel.statusViewModel.pacingSettings)
              .onDisappear { viewModel.loadHistory() }

          case 3:
            PastView()
              .environmentObject(viewModel.pastViewModel)
              .environmentObject(viewModel.pastViewModel.resultData)

              .environmentObject(viewModel.statusViewModel)
              .environmentObject(viewModel.statusViewModel.pacingStatus)
              .environmentObject(viewModel.statusViewModel.pacingSettings)

          case 4:
            ProfileView()
              .environmentObject(viewModel.profileViewModel)

              .environmentObject(viewModel.statusViewModel)
              .environmentObject(viewModel.statusViewModel.pacingStatus)
              .environmentObject(viewModel.statusViewModel.pacingSettings)

          default:
            EmptyView()
          }
        }.toolbar() {
          ToolbarItem(placement: .navigationBarTrailing) {
            StatusView()
              .environmentObject(viewModel.statusViewModel)
              .environmentObject(viewModel.statusViewModel.pacingStatus)
              .environmentObject(viewModel.statusViewModel.pacingSettings)
          }
        }
      }

      Dialog()
        .environmentObject(viewModel)
        .environmentObject(viewModel.dialogContent)
        .environmentObject(viewModel.dialogResult)
        .environmentObject(viewModel.dialogVisibility)

        .environmentObject(viewModel.runViewModel)
        .environmentObject(viewModel.runViewModel.timeEdit)
        .environmentObject(viewModel.runViewModel.timeSelection)

        .environmentObject(viewModel.profileViewModel)
        .environmentObject(viewModel.profileViewModel.waypointEdit)
    }
  }
}
