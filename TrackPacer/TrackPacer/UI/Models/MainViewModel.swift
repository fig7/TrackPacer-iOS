//
//  MainViewModel.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 10/05/2024.
//

import Foundation

@MainActor class MainViewModel {
  var runViewModel: RunViewModel
  var paceViewModel: PaceViewModel

  init() {
    runViewModel  = RunViewModel()
    paceViewModel = PaceViewModel()

    runViewModel.setMain(mainViewModel: self)
    paceViewModel.setMain(mainViewModel: self)
  }
}
