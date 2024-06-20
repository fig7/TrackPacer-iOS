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
    viewModel.setPacingStatus(.PacingPaused)
  }
}

private class MPCancelledDelegate : NSObject, AVAudioPlayerDelegate {
  let viewModel: PaceViewModel

  init(viewModel: PaceViewModel) {
    self.viewModel = viewModel
  }

  @MainActor func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    viewModel.setPacingStatus(.NotPacing)
  }
}

private class MPCompletionDelegate : NSObject, AVAudioPlayerDelegate {
  let viewModel: PaceViewModel

  init(viewModel: PaceViewModel) {
    self.viewModel = viewModel
  }

  @MainActor func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    viewModel.setPacingStatus(.NotPacing)
    viewModel.pacingComplete()
  }
}

@MainActor class PaceViewModel : ObservableObject, ServiceConnection {
  unowned let paceModel: PacingModel

  unowned var mainViewModel: MainViewModel!
  unowned var pacingStatus: PacingStatus!
  unowned var pacingSettings: PacingSettings!

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
  var appPlayer: AVAudioPlayer!

  private func pacingRunnable(delayMS: Int64) {
    timer = Timer.scheduledTimer(withTimeInterval: delayMS.toDouble()/1000.0, repeats: true) { _ in
      Task { @MainActor in
        self.handleTimeUpdate()
      }
    }
  }

  init(_ paceModel: PacingModel) {
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
    self.mainViewModel = mainViewModel

    let statusViewModel = mainViewModel.statusViewModel
    self.pacingStatus   = statusViewModel.pacingStatus
    self.pacingSettings = statusViewModel.pacingSettings
  }

  func setPacingOptions(_ runDist: String, _ runLane: Int, _ runTime: Double, _ runProf: String) {
    pacingOptions.runDist = runDist
    pacingOptions.runLane = runLane
    pacingOptions.runTime = runTime
    pacingOptions.runProf = runProf
    pacingProgress.resetProgress()
  }

  func onServiceConnected() {
    let pacingStatus = pacingStatus.status
    if(pacingStatus == .ServiceStart) {
      let distanceManager = mainViewModel.runModel.distanceModel.distanceManager
      let waypoints = try! distanceManager.waypointsFor(pacingOptions.runDist, pacingOptions.runProf)
      waypointService.beginPacing(pacingOptions, pacingSettings.alternateStart, waypoints)

      if(pacingSettings.powerStart) {
        setPacingStatus(.PacingWait)

        // TODO: Ideally, notify the controller that the service is up and then start the screen receiver
        mainViewModel.startScreenReceiver()
      } else {
        // Delay start
        setPacingStatus(.PacingStart)

        let startDelay = try! pacingSettings.startDelay.toDouble()
        if(waypointService.delayStart(startDelayMS: (startDelay * 1000.0).toLong(), quickStart: pacingSettings.quickStart)) {
          handler.postDelayed(pacingRunnable, delayMS: 113)
        }  else {
          stopPacing(silent: true)
        }
      }
    } else if(pacingStatus == .ServiceResume) {
      setPacingStatus(.PacingResume)
      if(pacingSettings.powerStart) { mainViewModel.startScreenReceiver() }

      if(waypointService.resumePacing(pacingOptions, pacingSettings.alternateStart, pacingProgress.elapsedTime)) {
        handler.postDelayed(pacingRunnable, delayMS: 113)
      } else {
        stopPacing(silent: true)
      }
    }
  }

  func onServiceDisconnected() {
    stopPacing(silent: true)
  }

  func setPacingStatus(_ newPacingStatus: PacingStatusVal) {
    pacingStatus.status = newPacingStatus
  }

  func powerStart() {
    guard let waypointService else { return }

    setPacingStatus(.PacingStart)
    if(waypointService.powerStart(quickStart: pacingSettings.quickStart)) {
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
      let pacingStatus = pacingStatus.status
      if((pacingStatus == .PacingStart) || (pacingStatus == .PacingResume)) {
        setPacingStatus(.Pacing)
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
    let powerStart = pacingSettings.powerStart
    if(powerStart) { mainViewModel.stopScreenReceiver() }

    timer?.invalidate()
    timer = nil

    waypointService = nil
  }

  func beginPacing() {
    let powerStart = pacingSettings.powerStart
    let quickStart = pacingSettings.quickStart
    if(!quickStart || powerStart) {
      do {
        let urlOYM  = Bundle.main.url(forResource: "set", withExtension: ".m4a")!
        appPlayer = try AVAudioPlayer(contentsOf: urlOYM)
        appPlayer.play()
      } catch { }
    }

    pacingProgress.resetProgress()
    setPacingStatus(.ServiceStart)

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
      setPacingStatus(.PacingPaused)
    } else {
      setPacingStatus(.PacingPause)
      mpPacingPaused.play()
    }
  }

  func stopPacing(silent: Bool) {
    if(pacingStatus.isPacing) {
      stopService()

      if(silent) {
        setPacingStatus(.NotPacing)
      } else if ((pacingStatus.status == .Pacing) && (pacingProgress.elapsedTime >= 40000)) {
        mainViewModel.setPacingResult()
        setPacingStatus(.PacingComplete)
        mpPacingComplete.play()
      } else {
        setPacingStatus(.PacingCancel)
        mpPacingCancelled.play()
      }
    } else if((pacingStatus.status == .PacingPaused) && !silent) {
      if(pacingProgress.elapsedTime >= 40000) {
        mainViewModel.setPacingResult()
        setPacingStatus(.PacingComplete)
        mpPacingComplete.play()
      } else {
        setPacingStatus(.PacingCancel)
        mpPacingCancelled.play()
      }
    } else {
      setPacingStatus(.NotPacing)
    }
  }

  func resumePacing() {
    setPacingStatus(.ServiceResume)
    waypointService = WaypointService(serviceConnection: self)
  }

  func pacingComplete() {
    mainViewModel.pacingComplete()
  }
}
