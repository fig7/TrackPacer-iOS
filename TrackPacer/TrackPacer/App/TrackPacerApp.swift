//
//  TrackPacerApp.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 10/05/2024.
//

import SwiftUI
import AVKit

private var mainViewModel: MainViewModel!

class AppDelegate: NSObject, UIApplicationDelegate {
  @objc func onAppWillResignActive(notification: NSNotification) {
    if(mainViewModel.screenReceiverActive) {
      mainViewModel.handleIncomingIntent(begin: true, silent: false)
    }
  }

  @objc func onAppDidBecomeActive(notification: NSNotification) {
    let audioSession = AVAudioSession.sharedInstance()

    do {
      try audioSession.setCategory(.playback, options: [.duckOthers])
      try audioSession.setActive(true)
    } catch { }
  }

  @objc func onAudioInterruption(notification: Notification) {
    mainViewModel.handleIncomingIntent(begin: false, silent: true)
  }

  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    let application = UIApplication.shared
    if(application.applicationState != .active) {
      if(mainViewModel.screenReceiverActive) {
        mainViewModel.handleIncomingIntent(begin: false, silent: false)
      }
    }
  }

  func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    let nc = NotificationCenter.default
    nc.addObserver(self, selector: #selector(onAppWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)
    nc.addObserver(self, selector: #selector(onAppDidBecomeActive),  name: UIApplication.didBecomeActiveNotification,  object: nil)
    nc.addObserver(self, selector: #selector(onAudioInterruption),   name: AVAudioSession.interruptionNotification,    object: nil)

    let audioSession = AVAudioSession.sharedInstance()
    audioSession.addObserver(self, forKeyPath: "outputVolume", options: [], context: nil);

    return true
  }
}

@main struct TrackPacerApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

  private let runModel: RunModel
  private let pacingModel: PacingModel
  private let resultModel: ResultModel

  private let historyModel: HistoryModel
  private let settingsModel: SettingsModel

  init() {
    runModel      = RunModel()
    historyModel  = HistoryModel()
    settingsModel = SettingsModel()

    pacingModel   = PacingModel()
    resultModel   = ResultModel()
    mainViewModel = MainViewModel(runModel, pacingModel, resultModel, historyModel, settingsModel)
  }

  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(mainViewModel)
        .environmentObject(mainViewModel.mainViewStack)
    }
  }
}
