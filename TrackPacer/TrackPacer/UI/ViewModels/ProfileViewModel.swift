//
//  ProfileViewModel.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 09/06/2024.
//

import Foundation

@MainActor class ProfileViewModel : ObservableObject {
  unowned var mainViewModel: MainViewModel!

  func setMain(mainViewModel: MainViewModel) {
    self.mainViewModel = mainViewModel
  }

  func saveProfile() {
    mainViewModel.saveProfile()
  }

  func finishProfile() {
    mainViewModel.finishProfile()
  }
}
