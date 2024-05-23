//
//  TrackPacerApp.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 10/05/2024.
//

import SwiftUI

import AVKit
import BackgroundTasks

var mainViewModel: MainViewModel?

class AppDelegate: NSObject, UIApplicationDelegate {
  @objc func onAppDidBecomeActive(notification: NSNotification) {
    print("Become active:")
  }

  @objc func onAppWillResignActive(notification: NSNotification) {
    print("Resign active:")

    let pacingStatus = mainViewModel!.paceViewModel.pacingStatus.status
    if(pacingStatus != .Pacing) {
      mainViewModel!.paceViewModel.powerStart()
    }
  }

  func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    NotificationCenter.default.addObserver(self, selector: #selector(onAppWillResignActive),   name: UIApplication.willResignActiveNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(onAppDidBecomeActive),   name: UIApplication.didBecomeActiveNotification, object: nil)

    do {
      let audioSession = AVAudioSession.sharedInstance();
      try audioSession.setCategory(.playback, options: [.duckOthers])
      try audioSession.setActive(true)

      audioSession.addObserver(self, forKeyPath: "outputVolume", options: [], context: nil);
    } catch { }

    return true
  }

  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    print("Observing: \(String(describing: keyPath))")

    let application = UIApplication.shared
    if(application.applicationState != .active) {
      // TODO: Implement with Android's handleIncomingIntent
      let pacingStatus = mainViewModel!.paceViewModel.pacingStatus.status
      if((pacingStatus == .NotPacing) || (pacingStatus == .PacingPaused)) { return }
      if(pacingStatus == .Pacing) {
        mainViewModel!.paceViewModel.pausePacing()
      } else {
        mainViewModel!.paceViewModel.stopPacing()
      }
    }
  }
}

@main struct TrackPacerApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

  init() {
    mainViewModel = MainViewModel()
  }

  var body: some Scene {
    WindowGroup {
      ContentView(viewModel: mainViewModel!)
    }
  }
}
