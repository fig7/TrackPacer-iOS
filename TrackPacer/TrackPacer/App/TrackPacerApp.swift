//
//  TrackPacerApp.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 10/05/2024.
//

import SwiftUI
import AVKit

var mainViewModel: MainViewModel!

class AppDelegate: NSObject, UIApplicationDelegate {
  @objc func onAppWillResignActive(notification: NSNotification) {
    // Have a bool enabled or something in the statusViewModel (so, the code basically matches Android)
    let statusViewModel = mainViewModel.statusViewModel
    if(statusViewModel.screenReceiverActive) {
      mainViewModel.handleIncomingIntent(begin: true, silent: false)
    }
  }

  func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    NotificationCenter.default.addObserver(self, selector: #selector(onAppWillResignActive),   name: UIApplication.willResignActiveNotification, object: nil)

    do {
      let audioSession = AVAudioSession.sharedInstance();
      try audioSession.setCategory(.playback, options: [.duckOthers])
      try audioSession.setActive(true)

      audioSession.addObserver(self, forKeyPath: "outputVolume", options: [], context: nil);
    } catch { }

    return true
  }

  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    let application = UIApplication.shared
    if(application.applicationState != .active) {
      let statusViewModel = mainViewModel.statusViewModel
      if(statusViewModel.screenReceiverActive) {
        mainViewModel.handleIncomingIntent(begin: false, silent: false)
      }
    }
  }
}

@main struct TrackPacerApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

  private let runModel: RunModel
  private let paceModel: PaceModel

  private let resultModel: ResultModel
  private let historyModel: HistoryModel

  init() {
    runModel = RunModel()
    if(!runModel.runModelOK) {
      //TODO:
      // val dialog = DistanceErrorDialog.newDialog("initializing", true)
      // dialog.show(supportFragmentManager, "DISTANCE_ERROR_DIALOG")
    }

    historyModel = HistoryModel()
    if(!historyModel.historyDataOK) {
      // TODO:
      // val dialog = HistoryErrorDialog.newDialog("initializing", true)
      // dialog.show(supportFragmentManager, "HISTORY_ERROR_DIALOG")
    }

    paceModel     = PaceModel()
    resultModel   = ResultModel()
    mainViewModel = MainViewModel(runModel, paceModel, resultModel, historyModel)

    initialiseApp()
  }

  private func initialiseApp() {
    mainViewModel.initDistances()
    mainViewModel.loadHistory()
  }

  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(mainViewModel)
        .environmentObject(mainViewModel.mainViewStack)
    }
  }
}
