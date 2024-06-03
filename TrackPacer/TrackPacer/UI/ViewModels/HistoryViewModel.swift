//
//  HistoryViewModel.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 01/06/2024.
//

import Foundation

@MainActor class HistoryViewModel : ObservableObject {
  unowned let historyModel: HistoryModel
  unowned var mainViewModel: MainViewModel!

  @Published var historyList: [ResultData] = []

  init(_ historyModel: HistoryModel) {
    self.historyModel = historyModel
  }

  func setMain(mainViewModel: MainViewModel) {
    self.mainViewModel = mainViewModel
  }

  func updateList(_ list: [ResultData]) {
    // Generate new ids. (I don't really know why this is needed)
    for resultData in list { resultData.id = UUID() }

    // Update the published list
    self.historyList = list
  }

  func showHistory(_ resultData: ResultData) {
    mainViewModel.showPastRun(resultData)
  }

  func deleteHistory(_ resultData: ResultData) {
    mainViewModel.showQuestionDialog(title: "Delete pacing",
      message: "Deleting history cannot be undone. Are you sure you want to delete this run?", action: "DELETE",
      width: 342, height: 200)
      { [weak self] in self?.completeDeleteHistory(resultData) }
  }

  func completeDeleteHistory(_ resultData: ResultData) {
    let historyManager = historyModel.historyManager
    _ = historyManager.deleteHistory(resultData)

    updateList(historyManager.historyList)
  }
}
