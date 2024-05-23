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

    /* do {
      let audioSession = AVAudioSession.sharedInstance()
      try audioSession.setActive(false)
    } catch { } */
  }
}

@MainActor class PaceViewModel {
  var mainViewModel: MainViewModel!
  var pacingStatus: PacingStatus
  var pacingOptions: PacingOptions
  var pacingProgress: PacingProgress

  private var waypointService: WaypointService?
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
    pacingStatus   = PacingStatus()
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
    self.mainViewModel = mainViewModel
  }

  func onServiceConnected() {
    if(pacingStatus.status == .PacingStart) {
      waypointService!.beginPacing(runDist: "400m", runLane: 1, runTime: 80000, alternateStart: false)

      // If delay start (otherwise, power start) TODO: Add waypoint service callback, like Android
      if(waypointService!.delayStart(startDelay: 5000, quickStart: false)) {
        handler.postDelayed(pacingRunnable, delayMS: 113)
       }
    }
    else if(pacingStatus.status == .PacingResume) {
      if(waypointService!.resumePacing(runDist: "400m", runLane: 1, runTime: 80000, alternateStart: false, resumeTime: pacingProgress.elapsedTime)) {
        handler.postDelayed(pacingRunnable, delayMS: 113)
      }
    }
  }

  func setPacingStatus(pacingStatus: PacingStatusVal) {
    self.pacingStatus.status = pacingStatus

    // TODO: Move this out, and move pacing status into StatusModel
    // TODO: Move functions into PacingModel (aka Android PacingActivity)
    if(pacingStatus == .PacingStart) {
      pacingProgress.setDistRun(-1.0)
      pacingProgress.setElapsedTime(0)

      waypointService = WaypointService(serviceConnectedCallback: onServiceConnected)
    } else if(pacingStatus == .NotPacing) {
      stopService()
    }
  }

  func powerStart() {
    guard let waypointService else { return }

    if(waypointService.powerStart(quickStart: false)) {
      timer = Timer.scheduledTimer(withTimeInterval: 0.113, repeats: true) { _ in
        Task { @MainActor in
          self.handleTimeUpdate()
        }
      }
    }
  }

  func handleTimeUpdate() {
    guard let waypointService else { return }
    let elapsedTime = waypointService.elapsedTime()
    if(elapsedTime >= 0) {
      let pacingStatus = pacingStatus.status
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
    timer?.invalidate()
    timer = nil

    waypointService = nil
  }

  func pausePacing() {
    guard let waypointService else { return }

    let elapsedTime = waypointService.elapsedTime()
    pacingProgress.setElapsedTime(elapsedTime)

    let distRun = waypointService.distOnPace(elapsedTime)
    pacingProgress.setDistRun(distRun)

    let name          = waypointService.waypointName()
    let progress      = waypointService.waypointProgress(elapsedTime)
    let remainingTime = waypointService.timeRemaining(elapsedTime)
    pacingProgress.setWaypointProgress(name, progress, remainingTime)

    stopService()

    // if(silent) {
    //     statusModel.setPacingStatus(PacingStatus.PacingPaused)
    // } else {
        // statusModel.setPacingStatus(PacingStatus.PacingPause)
        setPacingStatus(pacingStatus: .PacingPause)
        mpPacingPaused.play()
    // }
  }

  func stopPacing() {
    // TODO: Add status model
    // TODO: And result model

    let silent = false
    let isPacing = pacingStatus.isPacing
    let pacingStatus = pacingStatus.status
    if(isPacing) {
      stopService()

      if(silent) {
        setPacingStatus(pacingStatus: .NotPacing)
      } else if ((pacingStatus == .Pacing) && (pacingProgress.elapsedTime >= 40000)) {
        // resultModel.setPacingResult(resources, pacingModel)
        // statusModel.setPacingStatus(pacingStatus: .PacingComplete)
        setPacingStatus(pacingStatus: .PacingComplete)
        mpPacingComplete.play()
      } else {
        setPacingStatus(pacingStatus: .PacingCancel)
        mpPacingCancelled.play()
      }
    } else if((pacingStatus == .PacingPaused) && !silent) {
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
    setPacingStatus(pacingStatus: .PacingResume)

    // TODO: Make this like Android, have a callback for when the waypointService is up
    // TODO: Just setup the right states here
    waypointService = WaypointService(serviceConnectedCallback: onServiceConnected)
  }
}
