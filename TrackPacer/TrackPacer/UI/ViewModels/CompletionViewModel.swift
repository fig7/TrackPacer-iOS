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
