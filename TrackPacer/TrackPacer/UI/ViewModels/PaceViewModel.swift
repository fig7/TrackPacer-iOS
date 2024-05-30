//
//  PaceViewModel.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 12/05/2024.
//

import Foundation
import AVKit

private class MPPausingDelegate : NSObject, AVAudioPlayerDelegate {
  let viewModel: PaceViewModel

  init(viewModel: PaceViewModel) {
    self.viewModel = viewModel
  }

  @MainActor func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    viewModel.setPacingStatus(pacingStatus: .PacingPaused)
  }
}

private class MPCancelledDelegate : NSObject, AVAudioPlayerDelegate {
  let viewModel: PaceViewModel

  init(viewModel: PaceViewModel) {
    self.viewModel = viewModel
  }

  @MainActor func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    viewModel.setPacingStatus(pacingStatus: .NotPacing)
  }
}

private class MPCompletionDelegate : NSObject, AVAudioPlayerDelegate {
  let viewModel: PaceViewModel

  init(viewModel: PaceViewModel) {
    self.viewModel = viewModel
  }

  @MainActor func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    viewModel.setPacingStatus(pacingStatus: .NotPacing)
    viewModel.pacingComplete()
  }
}

@MainActor class PaceViewModel : ObservableObject, ServiceConnection {
  unowned let paceModel: PaceModel
  unowned var mainViewModel: MainViewModel!

  unowned var statusViewModel: StatusViewModel!

  var pacingOptions: PacingOptions
  var pacingProgress: PacingProgress

  private var waypointService: WaypointService!
  private var timer: Timer?

  private var mpPacingPaused: AVAudioPlayer!

  private var mpPacingComplete: AVAudioPlayer!
  private var mpPacingCancelled: AVAudioPlayer!

  private var pausingDelegate: AVAudioPlayerDelegate!
  private var cancelledDelegate: AVAudioPlayerDelegate!
  private var completionDelegate: AVAudioPlayerDelegate!

  private let handler = Handler()

  private func pacingRunnable(delayMS: Int64) {
    timer = Timer.scheduledTimer(withTimeInterval: delayMS.toDouble()/1000.0, repeats: true) { _ in
      Task { @MainActor in
        self.handleTimeUpdate()
      }
    }
  }

  init(_ paceModel: PaceModel) {
    self.paceModel = paceModel

    pacingOptions  = PacingOptions()
    pacingProgress = PacingProgress()

    do {
      let urlCancelled  = Bundle.main.url(forResource: "cancelled", withExtension: ".m4a")!
      mpPacingCancelled = try AVAudioPlayer(contentsOf: urlCancelled)

      let urlPaused  = Bundle.main.url(forResource: "paused", withExtension: ".m4a")!
      mpPacingPaused = try AVAudioPlayer(contentsOf: urlPaused)

      let urlComplete  = Bundle.main.url(forResource: "complete", withExtension: ".m4a")!
      mpPacingComplete = try AVAudioPlayer(contentsOf: urlComplete)

      pausingDelegate = MPPausingDelegate(viewModel: self)
      mpPacingPaused.delegate = pausingDelegate

      cancelledDelegate = MPCancelledDelegate(viewModel: self)
      mpPacingCancelled.delegate = cancelledDelegate

      completionDelegate = MPCompletionDelegate(viewModel: self)
      mpPacingComplete.delegate  = completionDelegate
    } catch { }
  }

  func setMain(mainViewModel: MainViewModel) {
    self.mainViewModel   = mainViewModel
    self.statusViewModel = mainViewModel.statusViewModel
  }

  func setPacingOptions(_ runDist: String, _ runLane: Int, _ runTime: Double) {
    pacingOptions.runDist = runDist
    pacingOptions.runLane = runLane
    pacingOptions.runTime = runTime
    pacingProgress.resetProgress()
  }

  func startScreenReceiver() {
    statusViewModel.screenReceiverActive = true
  }

  func onServiceConnected() {
    let pacingStatus   = statusViewModel.pacingStatus.status
    let pacingSettings = statusViewModel.pacingSettings
    if(pacingStatus == .ServiceStart) {
      waypointService.beginPacing(pacingOptions.runDist, pacingOptions.runLane, pacingOptions.runTime, false)

      if(pacingSettings.powerStart) {
        // Power start
        setPacingStatus(pacingStatus: .PacingWait)

        // window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
        startScreenReceiver()
      } else {
        // Delay start
        setPacingStatus(pacingStatus: .PacingStart)

        if(waypointService.delayStart(startDelay: 5000, quickStart: pacingSettings.quickStart)) {
          handler.postDelayed(pacingRunnable, delayMS: 113)
        }  else {
          stopPacing(silent: true)
        }
      }
    } else if(pacingStatus == .ServiceResume) {
      setPacingStatus(pacingStatus: .PacingResume)

      if(pacingSettings.powerStart) {
        startScreenReceiver()
      }

      if(waypointService.resumePacing(pacingOptions.runDist, pacingOptions.runLane, pacingOptions.runTime, false, pacingProgress.elapsedTime)) {
        handler.postDelayed(pacingRunnable, delayMS: 113)
      } else {
        stopPacing(silent: true)
      }
    }
  }

  func onServiceDisconnected() {
    stopPacing(silent: true)
  }

  func setPacingStatus(pacingStatus: PacingStatusVal) {
    statusViewModel.setPacingStatus(pacingStatus: pacingStatus)
  }

  func powerStart() {
    guard let waypointService else { return }

    setPacingStatus(pacingStatus: .PacingStart)
    if(waypointService.powerStart(quickStart: statusViewModel.pacingSettings.quickStart)) {
      timer = Timer.scheduledTimer(withTimeInterval: 0.113, repeats: true) { _ in
        Task { @MainActor in
          self.handleTimeUpdate()
        }
      }
    } else {
      stopPacing(silent: true)
    }
  }

  func handleTimeUpdate() {
    guard let waypointService else { return }
    let elapsedTime = waypointService.elapsedTime()
    if(elapsedTime >= 0) {
      let pacingStatus = statusViewModel.pacingStatus.status
      if((pacingStatus == .PacingStart) || (pacingStatus == .PacingResume)) {
        setPacingStatus(pacingStatus: .Pacing)
        if(pacingStatus == .PacingStart) { mainViewModel.initPacingResult() }
      } else {
        let distRun = waypointService.distOnPace(elapsedTime)
        pacingProgress.setDistRun(distRun)

        let name          = waypointService.waypointName()
        let progress      = waypointService.waypointProgress(elapsedTime)
        let remainingTime = waypointService.timeRemaining(elapsedTime)
        pacingProgress.setWaypointProgress(name, progress, remainingTime)
      }
    }

    pacingProgress.setElapsedTime(elapsedTime)
  }

  func stopService() {
    let pacingSettings = statusViewModel.pacingSettings
    if(pacingSettings.powerStart) {
      // window.clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
      statusViewModel.screenReceiverActive = false
    }

    timer?.invalidate()
    timer = nil

    waypointService = nil
  }

  func beginPacing() {
    pacingProgress.resetProgress()
    setPacingStatus(pacingStatus: .ServiceStart)

    waypointService = WaypointService(serviceConnection: self)
  }

  func pausePacing(silent: Bool) {
    guard let waypointService else { return }

    // Record the pacing progress
    let elapsedTime = waypointService.elapsedTime()
    pacingProgress.setElapsedTime(elapsedTime)

    let distRun = waypointService.distOnPace(elapsedTime)
    pacingProgress.setDistRun(distRun)

    let name          = waypointService.waypointName()
    let progress      = waypointService.waypointProgress(elapsedTime)
    let remainingTime = waypointService.timeRemaining(elapsedTime)
    pacingProgress.setWaypointProgress(name, progress, remainingTime)

    // Stop the service
    stopService()

    // Update the status
    if(silent) {
      setPacingStatus(pacingStatus: .PacingPaused)
    } else {
      setPacingStatus(pacingStatus: .PacingPause)
      mpPacingPaused.play()
    }
  }

  func stopPacing(silent: Bool) {
    let pacingStatus = statusViewModel.pacingStatus
    if(pacingStatus.isPacing) {
      stopService()

      if(silent) {
        setPacingStatus(pacingStatus: .NotPacing)
      } else if ((pacingStatus.status == .Pacing) && (pacingProgress.elapsedTime >= 40000)) {
        mainViewModel.setPacingResult()
        setPacingStatus(pacingStatus: .PacingComplete)
        mpPacingComplete.play()
      } else {
        setPacingStatus(pacingStatus: .PacingCancel)
        mpPacingCancelled.play()
      }
    } else if((pacingStatus.status == .PacingPaused) && !silent) {
      if(pacingProgress.elapsedTime >= 40000) {
        mainViewModel.setPacingResult()
        setPacingStatus(pacingStatus: .PacingComplete)
        mpPacingComplete.play()
      } else {
        setPacingStatus(pacingStatus: .PacingCancel)
        mpPacingCancelled.play()
      }
    } else {
      setPacingStatus(pacingStatus: .NotPacing)
    }
  }

  func resumePacing() {
    setPacingStatus(pacingStatus: .ServiceResume)
    waypointService = WaypointService(serviceConnection: self)
  }

  func pacingComplete() {
    mainViewModel.pacingComplete()
  }
}
