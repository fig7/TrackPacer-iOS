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

private class MPFinishingDelegate : NSObject, AVAudioPlayerDelegate {
  let viewModel: PaceViewModel

  init(viewModel: PaceViewModel) {
    self.viewModel = viewModel
  }

  @MainActor func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    viewModel.setPacingStatus(pacingStatus: .NotPacing)
  }
}

@MainActor class PaceViewModel : ServiceConnection {
  var mainViewModel: MainViewModel!
  var statusViewModel: StatusViewModel!

  var pacingOptions: PacingOptions
  var pacingProgress: PacingProgress

  private var waypointService: WaypointService!
  private var timer: Timer?

  private var mpPacingPaused: AVAudioPlayer!

  private var mpPacingComplete: AVAudioPlayer!
  private var mpPacingCancelled: AVAudioPlayer!

  private var pausingDelegate: AVAudioPlayerDelegate!
  private var finishingDelegate: AVAudioPlayerDelegate!

  private let handler = Handler()

  private func pacingRunnable(delayMS: Int64) {
    timer = Timer.scheduledTimer(withTimeInterval: delayMS.toDouble()/1000.0, repeats: true) { _ in
      Task { @MainActor in
        self.handleTimeUpdate()
      }
    }
  }

  init() {
    mainViewModel = nil
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

      finishingDelegate = MPFinishingDelegate(viewModel: self)
      mpPacingCancelled.delegate = finishingDelegate
      mpPacingComplete.delegate  = finishingDelegate
    } catch { }
  }

  func setMain(mainViewModel: MainViewModel) {
    self.mainViewModel   = mainViewModel
    self.statusViewModel = mainViewModel.statusViewModel
  }

  func startScreenReceiver() {
    statusViewModel.screenReceiverActive = true
  }

  func onServiceConnected() {
    let pacingStatus   = statusViewModel.pacingStatus.status
    let pacingSettings = statusViewModel.pacingSettings
    if(pacingStatus == .ServiceStart) {
      waypointService.beginPacing(runDist: "400m", runLane: 1, runTime: 80000, alternateStart: false)

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

      if(waypointService.resumePacing(runDist: "400m", runLane: 1, runTime: 80000, alternateStart: false, resumeTime: pacingProgress.elapsedTime)) {
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
    pacingProgress.setElapsedTime(0)
    pacingProgress.resetWaypointProgress()

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
        // resultModel.setPacingResult(resources, pacingModel)
        // statusModel.setPacingStatus(pacingStatus: .PacingComplete)
        setPacingStatus(pacingStatus: .PacingComplete)
        mpPacingComplete.play()
      } else {
        setPacingStatus(pacingStatus: .PacingCancel)
        mpPacingCancelled.play()
      }
    } else if((pacingStatus.status == .PacingPaused) && !silent) {
      if(pacingProgress.elapsedTime >= 40000) {
        // resultModel.setPacingResult(resources, pacingModel)
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
}
