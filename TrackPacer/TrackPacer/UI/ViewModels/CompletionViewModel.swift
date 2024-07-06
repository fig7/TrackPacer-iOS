//
//  CompletionViewModel.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 29/05/2024.
//

import Foundation

@MainActor class CompletionViewModel : ObservableObject {
  unowned var mainViewModel: MainViewModel!
  var resultData: ResultData!

  func setMain(mainViewModel: MainViewModel) {
    self.mainViewModel = mainViewModel
  }

  func saveRun() {
    mainViewModel.saveRun()
  }

  func finishRun() {
    mainViewModel.finishRun()
  }

  func setRunData(_ runData: RunData) {
    resultData = ResultData(runData, RunDataExtra(runData.runDist, runData.runDate))
  }

  func runNotes() -> String
  { return resultData.runData.runNotes }
}
