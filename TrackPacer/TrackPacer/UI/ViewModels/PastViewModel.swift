//
//  PastViewModel.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 02/06/2024.
//

import Foundation

@MainActor class PastViewModel : ObservableObject {
  unowned var mainViewModel: MainViewModel!
  @Published var resultData: ResultData!

  func setMain(mainViewModel: MainViewModel) {
    self.mainViewModel = mainViewModel
  }

  func setResultData(_ resultData: ResultData) {
    self.resultData = resultData
  }
}
