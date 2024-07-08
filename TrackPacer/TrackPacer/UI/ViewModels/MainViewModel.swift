//
//  MainViewModel.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 10/05/2024.
//

import Foundation
import CoreTelephony
import AVKit
import UIKit

@MainActor class MainViewModel : ObservableObject {
  unowned let runModel: RunModel
  unowned let pacingModel: PacingModel
  unowned let resultModel: ResultModel

  unowned let historyModel: HistoryModel
  unowned let settingsModel: SettingsModel

  var mainViewStack: MainViewStack
  var statusViewModel: StatusViewModel

  var runViewModel: RunViewModel
  var paceViewModel: PaceViewModel
  var profileViewModel: ProfileViewModel
  var completionViewModel: CompletionViewModel

  var historyViewModel: HistoryViewModel
  var pastViewModel: PastViewModel

  var settingsViewModel: SettingsViewModel

  let dialogVisibility: DialogVisibility
  let dialogContent: DialogContent
  let dialogResult: DialogResult
  var dialogCompletion: () -> ()

  // Hack until I find a better way to deal with custom dialogs
  // Maybe they need their own view models, etc.
  @Published var disableReminder = false

  var handlingSettingsError = false
  var screenReceiverActive  = false
  let uiApp = UIApplication.shared
  var appPlayer: AVAudioPlayer!

  init(_ runModel: RunModel, _ pacingModel: PacingModel, _ resultModel: ResultModel, _ historyModel: HistoryModel, _ settingsModel: SettingsModel) {
    self.runModel    = runModel
    self.pacingModel = pacingModel
    self.resultModel = resultModel

    self.historyModel   = historyModel
    self.settingsModel  = settingsModel
    let settingsManager = settingsModel.settingsManager

    mainViewStack = MainViewStack()

    statusViewModel = StatusViewModel()
    statusViewModel.setFromSettings(settingsManager)

    runViewModel        = RunViewModel(runModel)
    profileViewModel    = ProfileViewModel()
    paceViewModel       = PaceViewModel(pacingModel)
    completionViewModel = CompletionViewModel()

    historyViewModel = HistoryViewModel(historyModel)
    pastViewModel    = PastViewModel()

    settingsViewModel = SettingsViewModel()
    settingsViewModel.setFromSettings(settingsManager)

    dialogVisibility = DialogVisibility()
    dialogContent    = DialogContent()
    dialogResult     = DialogResult()
    dialogCompletion = { }

    runViewModel.setMain(mainViewModel: self)
    paceViewModel.setMain(mainViewModel: self)
    profileViewModel.setMain(mainViewModel: self)
    completionViewModel.setMain(mainViewModel: self)
    historyViewModel.setMain(mainViewModel: self)
    settingsViewModel.setMain(mainViewModel: self)

    if(!runModel.runModelOK) {
      showErrorDialog(title: "Initialization error",
        message:
        "An error occurred while reading distances and times.\n\n" +

        "Please try re-starting the app.\n" +
        "If that doesn't work, re-install it.",
        width: 342, height: 200)

      return
    }

    if(!historyModel.historyDataOK) {
      showErrorDialog(title: "Initialization error",
        message:
        "An error occurred while accessing pacing history.\n\n" +

        "Please try re-starting the app.\n" +
        "If that doesn't work, re-install it.",
        width: 342, height: 200)

      return
    }

    if(!settingsModel.settingsDataOK) {
      showErrorDialog(title: "Initialization error",
        message:
       "An error occurred while reading settings.\n\n" +

       "Please try re-starting the app.\n" +
       "If that doesn't work, re-install it.",
        width: 342, height: 200)

      return
    }

    loadHistory()
    initRunView()
  }

  func loadHistory() {
    historyModel.loadHistory()
    if(!historyModel.historyDataOK) {
      showErrorDialog(title: "Loading error",
        message:
        "An error occurred while reading pacing history.\n\n" +

        "Please try re-starting the app.\n" +
        "If that doesn't work, re-install it.",
        width: 342, height: 200)
    }

    let historyManager = historyModel.historyManager
    historyViewModel.updateList(historyManager.historyList)
  }

  func initRunView() {
    let distanceManager = runModel.distanceModel.distanceManager
    let distanceArray   = distanceManager.distanceArray!
    let profileMap      = distanceManager.profileMap

    do {
      // Initialise with 400m
      let profileArray = profileMap[distanceArray[0]]!.map { $0.0 }
      try runViewModel.initDistances(distanceArray, profileArray)
    } catch {
      showErrorDialog(title: "Loading error",
        message:
        "An error occurred while accessing distances and times.\n\n" +

        "Please try re-starting the app.\n" +
        "If that doesn't work, re-install it.",
        width: 342, height: 200)
    }
  }

  func showErrorDialog(title: String, message: String, width: Int, height: Int) {
    dialogContent.dialogType = .Error

    dialogContent.dialogTitle = title
    dialogContent.dialogText  = message

    dialogContent.dialogWidth   = CGFloat(width)
    dialogContent.dialogHeight  = CGFloat(height)
    dialogContent.dialogPadding = CGFloat(20)

    dialogVisibility.visible = true
  }

  func showInfoDialog(title: String, message: String, width: Int, height: Int, completion: @escaping () -> () = { }) {
    dialogContent.dialogType = .Info

    dialogContent.dialogTitle = title
    dialogContent.dialogText  = message

    dialogContent.dialogWidth   = CGFloat(width)
    dialogContent.dialogHeight  = CGFloat(height)
    dialogContent.dialogPadding = CGFloat(20)

    dialogCompletion = completion
    dialogVisibility.visible = true
  }

  func showQuestionDialog(title: String, message: String, action: String, width: Int, height: Int, completion: @escaping () -> ()) {
    dialogContent.dialogType = .Question

    dialogContent.dialogTitle  = title
    dialogContent.dialogText   = message
    dialogContent.dialogAction = action

    dialogContent.dialogWidth   = CGFloat(width)
    dialogContent.dialogHeight  = CGFloat(height)
    dialogContent.dialogPadding = CGFloat(20)

    dialogCompletion = completion
    dialogVisibility.visible = true
  }

  func showEditTimeDialog(width: Int, height: Int) {
    dialogContent.dialogType = .Edit

    dialogContent.dialogWidth   = CGFloat(width)
    dialogContent.dialogHeight  = CGFloat(height)
    dialogContent.dialogPadding = CGFloat(8)

    dialogVisibility.visible = true
  }

  func showEditWaypointDialog(width: Int, height: Int) {
    dialogContent.dialogType = .Waypoint

    dialogContent.dialogWidth   = CGFloat(width)
    dialogContent.dialogHeight  = CGFloat(height)
    dialogContent.dialogPadding = CGFloat(8)

    dialogVisibility.visible = true
  }

  func dismissDialog() {
    let dialogType = dialogContent.dialogType

    dialogContent.dialogType = .None
    dialogVisibility.visible = false

    switch(dialogType) {
    case .Info, .Question:
      if(dialogResult.action == .UserContinue) {
        let completion = dialogCompletion

        dialogCompletion = { }
        dialogResult.action = .UserCancel

        Task { @MainActor in
          completion()
        }
      }

    case .Edit:
      runViewModel.performTimeEdit()

    default:
      break
    }
  }

  func editProfile(_ runDist: String, _ runProfile: String) {
    do {
      let distanceManager = runModel.distanceModel.distanceManager
      let waypoints       = try distanceManager.waypointsFor(runDist, runProfile)

      let settingsManager = settingsModel.settingsManager
      let refPace = settingsManager.refPace

      profileViewModel.setProfileOptions(runDist, runProfile, waypoints, refPace)
      mainViewStack.pushProfileView()
    } catch { }
  }

  private func showFMRDialog(width: Int, height: Int) {
    dialogContent.dialogType = .FMR

    dialogContent.dialogWidth   = CGFloat(width)
    dialogContent.dialogHeight  = CGFloat(height)
    dialogContent.dialogPadding = CGFloat(8)

    dialogVisibility.visible = true
  }

  func updateReminder() {
    if(!disableReminder) { return }

    let settingsManager = settingsModel.settingsManager
    _ = settingsManager.setFlightMode(false)

    settingsViewModel.flightMode = settingsManager.flightMode
  }

  func openSettings() {
    let url = URL(string: UIApplication.openSettingsURLString)
    guard let url else { return }

    uiApp.open(url)
  }

  private func isAirplaneModeEnabled() -> Bool {
    let networkInfo = CTTelephonyNetworkInfo()
    guard let radioAccessTechnology = networkInfo.serviceCurrentRadioAccessTechnology else {
      return true
    }
    return radioAccessTechnology.isEmpty
  }

  func onYourMarks(_ runDist: String, _ runLane: Int, _ runTime: Double, _ runProf: String) {
    paceViewModel.setPacingOptions(runDist, runLane, runTime, runProf)

    let settingsManager    = settingsModel.settingsManager
    let flightModeReminder = settingsManager.flightMode
    if(!isAirplaneModeEnabled() && flightModeReminder) {
      disableReminder = false
      showFMRDialog(width: 342, height: 260)
      return
    }

    launchPacing()
  }

  func launchPacing() {
    do {
      let urlOYM  = Bundle.main.url(forResource: "oym", withExtension: ".m4a")!
      appPlayer = try AVAudioPlayer(contentsOf: urlOYM)
      appPlayer.play()
    } catch { }

    mainViewStack.pushPacingView()
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
    resultModel.setBaseDist(pacingOptions.baseDist)
    resultModel.setRunLane(pacingOptions.runLane)
    resultModel.setRunProf(pacingOptions.runProf)

    resultModel.setRunDist(pacingOptions.runDistStr)
    resultModel.setRunTime(pacingOptions.runTimeStr)
    resultModel.setRunPace(pacingOptions.runPaceStr)
  }

  func setPacingResult() {
    let pacingOptions  = paceViewModel.pacingOptions
    let pacingProgress = paceViewModel.pacingProgress

    let actualRunTime = pacingProgress.elapsedTime - pacingOptions.waitingTime
    resultModel.setActualTime(timeToAlmostFullString(timeInMS: actualRunTime))

    let actualPace = (1000.0 * actualRunTime.toDouble()) / pacingOptions.runDist
    resultModel.setActualPace(timeToMinuteString(timeInMS: actualPace.toLong()))

    let runTime = pacingOptions.runTime
    var timeDiff  = actualRunTime - runTime.toLong()
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
    completionViewModel.setRunData(resultModel.runData)
    mainViewStack.pushCompletionView()
  }

  func saveRun() {
    resultModel.setRunNotes(completionViewModel.runNotes())

    let historyManager = historyModel.historyManager
    if(!historyManager.saveHistory(resultModel.runData)) {
      showInfoDialog(title: "Error saving result",
        message:
        "An error occurred while saving the pacing result.\n\n" +

        "The result was not saved.\n" +
        "Please try saving again.",
        width: 342, height: 200)

      return
    }

    mainViewStack.popCompletionView()
  }

  func finishRun() {
    mainViewStack.popCompletionView()
  }

  private func completeSaveProfile(_ profileDist: String, _ profileName: String, _ waypointData: [WaypointData]) throws {
    // TODO: Handle errors
    let distanceManager = runModel.distanceModel.distanceManager
    let profileArray    = try distanceManager.saveProfile(profileDist, profileName, waypointData)
    runViewModel.updateProfiles(profileArray)
  }

  func saveProfile(_ profileDist: String, _ profileName: String, _ waypointData: [WaypointData]) {
    do {
      var profileName = profileName

      let settingsManager = settingsModel.settingsManager
      let alternateStart  = settingsManager.alternateStart && hasAlternateStart(profileDist)
      if(alternateStart) { profileName = profileName + "__AS__" }

      let distanceManager = runModel.distanceModel.distanceManager
      if(distanceManager.profileExists(profileDist, profileName)) {
        showQuestionDialog(title: "Replace existing profile",
          message: "Are you sure you want to make changes to an existing profile?", action: "REPLACE", width: 342, height: 240,
          completion: { [weak self] in
            guard let self else { return }

            try! completeSaveProfile(profileDist, profileName, waypointData)
            mainViewStack.popProfileView()
          })

        return
      }

      try completeSaveProfile(profileDist, profileName, waypointData)
    } catch { }

    mainViewStack.popProfileView()
  }

  func completeDeleteProfile(_ profileDist: String, _ profileName: String) throws {
    // TODO: Handle errors
    let distanceManager = runModel.distanceModel.distanceManager
    let profileArray    = try distanceManager.deleteProfile(profileDist, profileName)
    runViewModel.updateProfiles(profileArray)
  }

  func deleteProfile(_ profileDist: String, _ profileName: String) {
    do {
      let distanceManager = runModel.distanceModel.distanceManager
      if(distanceManager.profileExists(profileDist, profileName)) {
        showQuestionDialog(title: "Delete existing profile",
          message: "Are you sure you want to delete this profile? This operation cannot be undone.", action: "DELETE", width: 342, height: 240,
          completion: { [weak self] in
            guard let self else { return }

            try! completeDeleteProfile(profileDist, profileName)
            mainViewStack.popProfileView()
          })

        return
      }

      try completeDeleteProfile(profileDist, profileName)
    } catch { }

    mainViewStack.popProfileView()
  }

  func showPastRun(_ resultData: ResultData) {
    pastViewModel.setResultData(resultData)
    mainViewStack.pushPastView()
  }

  func handleDistanceError() {
    // We need to let the edit dialog disappear (or partially disappear)
    // So, run a task that starts with a slight delay (half a second seems to be enough)
    Task { @MainActor in
      try await Task.sleep(nanoseconds: 500000000)

      showInfoDialog(title: "Error editing times",
      message:
        "An error occurred while saving the new times.\n\n" +

        "The changes were not saved.\n" +
        "Please try again.",
        width: 342, height: 225)
    }
  }

  func handleSettingsError() {
    handlingSettingsError = true

    showInfoDialog(title: "Error saving settings",
      message:
      "An error occurred while saving the new settings.\n\n" +

      "The changes were not saved.\n" +
      "Please try again.",
      width: 342, height: 225,
      completion: { [weak self] in
        guard let self else { return }

        let settingsManager = settingsModel.settingsManager
        statusViewModel.setFromSettings(settingsManager)
        settingsViewModel.setFromSettings(settingsManager)
    })
  }

  func setStartDelay(_ newStartDelay: String) {
    if(handlingSettingsError) { handlingSettingsError = false; return }

    let settingsManager = settingsModel.settingsManager
    if(!settingsManager.setStartDelay(newStartDelay)) {
      handleSettingsError()
      return
    }

    statusViewModel.pacingSettings.startDelay = settingsManager.startDelay
  }

  func setPowerStart(_ newPowerStart: Bool) {
    if(handlingSettingsError) { handlingSettingsError = false; return }

    let settingsManager = settingsModel.settingsManager
    if(!settingsManager.setPowerStart(newPowerStart)) {
      handleSettingsError()
      return
    }

    statusViewModel.pacingSettings.powerStart = settingsManager.powerStart
  }

  func setQuickStart(_ newQuickStart: Bool) {
    if(handlingSettingsError) { handlingSettingsError = false; return }

    let settingsManager = settingsModel.settingsManager
    if(!settingsManager.setQuickStart(newQuickStart)) {
      handleSettingsError()
      return
    }

    statusViewModel.pacingSettings.quickStart = settingsManager.quickStart
  }

  func setAlternateStart(_ newAlternateStart: Bool) {
    if(handlingSettingsError) { handlingSettingsError = false; return }

    let settingsManager = settingsModel.settingsManager
    if(!settingsManager.setAlternateStart(newAlternateStart)) {
      handleSettingsError()
      return
    }

    statusViewModel.pacingSettings.alternateStart = settingsManager.alternateStart
  }

  func setFlightMode(_ newFlightMode: Bool) {
    if(handlingSettingsError) { handlingSettingsError = false; return }

    let settingsManager = settingsModel.settingsManager
    if(!settingsManager.setFlightMode(newFlightMode)) {
      handleSettingsError()
      return
    }
  }

  func setRefPace(_ newRefPace: String) {
    if(handlingSettingsError) { handlingSettingsError = false; return }

    let settingsManager = settingsModel.settingsManager
    if(!settingsManager.setRefPace(newRefPace)) {
      handleSettingsError()
      return
    }
  }

  private func startScreenReceiver() {
    screenReceiverActive      = true
    uiApp.isIdleTimerDisabled = true
  }

  private func stopScreenReceiver() {
    if(!screenReceiverActive) { return }

    screenReceiverActive      = false
    uiApp.isIdleTimerDisabled = false
  }

  func onServiceStarted() {
    let pacingSettings = statusViewModel.pacingSettings
    if(!pacingSettings.powerStart) { return }

    startScreenReceiver()
  }

  func onServiceStopped() {
    stopScreenReceiver()
  }
}
