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
    resultModel.setRunNotes("")

    let pacingOptions = paceViewModel.pacingOptions
    resultModel.setRunDist(pacingOptions.runDist)
    resultModel.setRunLane(pacingOptions.runLane)
    resultModel.setRunProf(pacingOptions.runProf)

    resultModel.setTotalDist(pacingOptions.totalDistStr)
    resultModel.setTotalTime(pacingOptions.totalTimeStr)
    resultModel.setTotalPace(pacingOptions.totalPaceStr)
  }

  func setPacingResult() {
    let pacingOptions  = paceViewModel.pacingOptions
    let pacingProgress = paceViewModel.pacingProgress

    let actualTime = pacingProgress.elapsedTime
    resultModel.setActualTime(timeToAlmostFullString(timeInMS: actualTime))

    let actualPace = (1000.0 * actualTime.toDouble()) / pacingOptions.totalDist
    resultModel.setActualPace(timeToMinuteString(timeInMS: actualPace.toLong()))

    let totalTime = pacingOptions.totalTime
    var timeDiff  = actualTime - totalTime.toLong()
    if(timeDiff <= -1000) {
      timeDiff = -timeDiff

      let timeDiffRes = (timeDiff  < 60000) ? "%@ seconds early" : "%@ early"
      resultModel.setEarlyLate(String(format: timeDiffRes, timeToString(timeInMS: timeDiff)))
    } else if(timeDiff > 2000) {
      let timeDiffRes = (timeDiff  < 60000) ? "%@ seconds late" : "%@ late"
      resultModel.setEarlyLate(String(format: timeDiffRes, timeToString(timeInMS: timeDiff)))
    } else {
      resultModel.setEarlyLate("Perfect pacing!")
    }
  }

  func pacingComplete() {
    let formatter = DateFormatter()
    formatter.dateFormat = "d MMM, yyyy 'at' HH:mm"

    let resultData = resultModel.resultData
    completionViewModel.runDate  = formatter.string(from: resultData.runDate)
    completionViewModel.runNotes = resultData.runNotes

    completionViewModel.runDist = resultData.runDist
    completionViewModel.runLane = resultData.runLane
    completionViewModel.runProf = resultData.runProf

    completionViewModel.totalDist = resultData.totalDistStr
    completionViewModel.totalTime = resultData.totalTimeStr
    completionViewModel.totalPace = resultData.totalPaceStr

    completionViewModel.actualTime = resultData.actualTimeStr
    completionViewModel.actualPace = resultData.actualPaceStr
    completionViewModel.earlyLate  = resultData.earlyLateStr

    runViewStack.pushCompletionView()
  }

  func saveRun() {
    resultModel.setRunNotes(completionViewModel.runNotes)

    // TODO: Save result
    runViewStack.popCompletionView()
  }

  func finishRun() {
    runViewStack.popCompletionView()
  }
}
