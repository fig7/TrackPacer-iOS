//
//  ClipsViewModel.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 19/07/2024.
//

import Foundation

@MainActor class ClipsViewModel : ObservableObject {
  unowned var mainViewModel: MainViewModel!
  var clipSelection: ClipSelection = ClipSelection()

  func setMain(mainViewModel: MainViewModel) {
    self.mainViewModel = mainViewModel
  }
}
