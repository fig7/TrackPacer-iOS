//
//  MainViewModel.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 10/05/2024.
//

import Foundation

@MainActor class MainViewModel : ObservableObject {
  unowned let runModel: RunModel
  unowned let paceModel: PaceModel
  unowned let resultModel: ResultModel

  var runViewModel: RunViewModel
  var runViewStack: RunViewStack

  var paceViewModel: PaceViewModel
  var completionViewModel: CompletionViewModel
  var statusViewModel: StatusViewModel

  let dialogVisibility: DialogVisibility
  let dialogContent: DialogContent

  init(_ runModel: RunModel, _ paceModel: PaceModel, _ resultModel: ResultModel) {
    self.runModel    = runModel
    self.paceModel   = paceModel
    self.resultModel = resultModel

    runViewModel = RunViewModel(runModel)
    runViewStack = RunViewStack()

    paceViewModel       = PaceViewModel(paceModel)
    completionViewModel = CompletionViewModel()
    statusViewModel     = StatusViewModel()

    dialogVisibility = DialogVisibility()
    dialogContent    = DialogContent()

    runViewModel.setMain(mainViewModel: self)
    paceViewModel.setMain(mainViewModel: self)
    completionViewModel.setMain(mainViewModel: self)
  }

  func showInfoDialog(title: String, message: String, width: Int, height: Int) {
    dialogContent.dialogType = .Info

    dialogContent.dialogTitle = title
    dialogContent.dialogText  = message

    dialogContent.dialogWidth   = CGFloat(width)
    dialogContent.dialogHeight  = CGFloat(height)
    dialogContent.dialogPadding = CGFloat(20)

    dialogVisibility.visible = true
  }

  func showEditTimeDialog(width: Int, height: Int) {
    dialogContent.dialogType = .Edit

    dialogContent.dialogWidth   = CGFloat(width)
    dialogContent.dialogHeight  = CGFloat(height)
    dialogContent.dialogPadding = CGFloat(8)

    dialogVisibility.visible = true
  }

  func dismissDialog() {
    dialogContent.dialogType = .None
    dialogVisibility.visible = false
  }

  func onYourMarks(_ runDist: String, _ runLane: Int, _ runTime: Double) {
    paceViewModel.setPacingOptions(runDist, runLane, runTime)
    runViewStack.pushPacingView()
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

  func initPacingResult()
  {
    resultModel.setPacingDate()

    /* resultData.runDist   = pacingModel.runDist
    resultData.runLane   = pacingModel.runLane
    resultData.runProf   = pacingModel.runProf

    resultData.totalDistStr = pacingModel.totalDistStr
    resultData.totalTimeStr = pacingModel.totalTimeStr
    resultData.totalPaceStr = pacingModel.totalPaceStr */
  }

  func pacingComplete() {
    // TODO: Init result model
    let resultData = resultModel.resultData

    let formatter        = DateFormatter()
    formatter.dateFormat = "d MMM, yyyy 'at' HH:mm"
    completionViewModel.runDate = formatter.string(from: resultData.runDate)

    runViewStack.pushCompletionView()
  }

  func saveRun() {
    // TODO: Save run
    runViewStack.popCompletionView()
  }

  func finishRun() {
    runViewStack.popCompletionView()
  }
}
