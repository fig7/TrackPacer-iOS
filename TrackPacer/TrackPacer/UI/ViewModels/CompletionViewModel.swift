//
//  CompletionViewModel.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 29/05/2024.
//

import Foundation

@MainActor class CompletionViewModel : ObservableObject {
  unowned var mainViewModel: MainViewModel!

  @Published var runDate = ""

  @Published var runDist = ""
  @Published var runLane = -1
  @Published var runProf = ""

  @Published var totalDist = ""
  @Published var totalTime = ""
  @Published var totalPace = ""

  @Published var actualTime = ""
  @Published var actualPace = ""
  @Published var earlyLate  = ""

  @Published var runNotes = ""

  func setMain(mainViewModel: MainViewModel) {
    self.mainViewModel = mainViewModel
  }

  func saveRun() {
    mainViewModel.saveRun()
  }

  func finishRun() {
    mainViewModel.finishRun()
  }
}
