//
//  MainViewModel.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 10/05/2024.
//

import Foundation

@MainActor class MainViewModel {
  unowned let runModel: RunModel
  unowned let paceModel: PaceModel

  var runViewModel: RunViewModel
  var paceViewModel: PaceViewModel
  var statusViewModel: StatusViewModel

  let dialogVisibility: DialogVisibility
  let dialogContent: DialogContent

  init(_ runModel: RunModel, _ paceModel: PaceModel) {
    self.runModel  = runModel
    self.paceModel = paceModel

    runViewModel    = RunViewModel(runModel)
    paceViewModel   = PaceViewModel(paceModel)
    statusViewModel = StatusViewModel()

    dialogVisibility = DialogVisibility()
    dialogContent    = DialogContent()

    runViewModel.setMain(mainViewModel: self)
    paceViewModel.setMain(mainViewModel: self)
  }

  func showInfoDialog(title: String, message: String, width: Int, height: Int) {
    dialogContent.dialogType = .Info

    dialogContent.dialogTitle = title
    dialogContent.dialogText  = message

    dialogContent.dialogWidth  = CGFloat(width)
    dialogContent.dialogHeight = CGFloat(height)

    dialogVisibility.visible = true
  }

  func dismissDialog() {
    dialogVisibility.visible = false
  }

  func handleIncomingIntent(begin: Bool, silent: Bool) {
    let pacingStatus = statusViewModel.pacingStatus.status
    if(begin) {
      if(pacingStatus != .PacingWait) { return }
      paceViewModel.powerStart()
    } else {
      switch(pacingStatus) {
      case .NotPacing, .PacingPaused:
        return

      case .Pacing:
        paceViewModel.pausePacing(silent: silent)

      default:
        paceViewModel.stopPacing(silent: silent)
      }
    }
  }
}
