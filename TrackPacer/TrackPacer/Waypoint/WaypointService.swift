//
//  WaypointService.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 22/05/2024.
//

import Foundation
import AVKit

private class MPWaitDelegate : NSObject, AVAudioPlayerDelegate {
  weak var service: WaypointService?

  init(service: WaypointService) {
    self.service = service
  }

  @MainActor func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    service?.playNextWaitClip()
  }
}

private class MPFinishDelegate : NSObject, AVAudioPlayerDelegate {
  weak var service: WaypointService?

  init(service: WaypointService) {
    self.service = service
  }

  @MainActor func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    service?.playFinalClip()
  }
}

private class MPFinalDelegate : NSObject, AVAudioPlayerDelegate {
  weak var service: WaypointService?

  init(service: WaypointService) {
    self.service = service
  }

  @MainActor func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    service?.terminate()
  }
}

@MainActor class WaypointService {
  private let handler = Handler()

  private var quickStart = false
  private var startRealtime: ContinuousClock.Instant!
  private var prevTime = -1.0

  private func waypointRunnable(delayMS: Int64) {
    handleWaypoint(delayMS)
  }

  private func waitRunnable(delayMS: Int64) {
    handleWait(delayMS)
  }

  private func startRunnable(delayMS: Int64) {
    if(delayMS == 0) { mpStart.play() } else { mpStart.play(atTime: mpStart.deviceCurrentTime + (Double(delayMS) / 1000.0)) }
  }

  private func resumeRunnable(_: Int64) {
    mpResume.play()
  }

  private var mpStart: AVAudioPlayer!
  private var mpStart1: AVAudioPlayer!
  private var mpStart2: AVAudioPlayer!
  private var mpResume: AVAudioPlayer!
  private var mpFinal: AVAudioPlayer!
  private var mpWaypoint: [AVAudioPlayer]!

  private var waypointTime = 0.0
  private var waypointWait = 0.0
  private var mpWaitStart: AVAudioPlayer!
  private var mpWait30: AVAudioPlayer!
  private var mpWait10: AVAudioPlayer!
  private var mpWaitGo: AVAudioPlayer!
  private var mpWaitGo1: AVAudioPlayer!
  private var mpWaitGo3: AVAudioPlayer!

  private var finishDelegate: AVAudioPlayerDelegate!
  private var finalDelegate: AVAudioPlayerDelegate!

  private var waitDelegate: AVAudioPlayerDelegate!

  private var waypointCalculator = WaypointCalculator()
  private var waypointIndexList: [Int]!

  private unowned let serviceConnection: ServiceConnection

  init(serviceConnection: ServiceConnection) {
    self.serviceConnection = serviceConnection
    onCreate()

    Task { @MainActor [weak self] in
      self?.serviceConnection.onServiceConnected()
    }
  }

  func beginPacing(_ pacingOptions: PacingOptions, _ waypoints: [WaypointData]) {
    waypointIndexList = waypointsFor(pacingOptions.baseDist)
    waypointCalculator.initRun(pacingOptions.baseDist, pacingOptions.runLane, pacingOptions.baseTime, waypoints)
  }

  func delayStart(startDelayMS: Int64, quickStart: Bool) -> Bool {
    self.quickStart = quickStart
    mpStart  = if(quickStart) { mpStart2 } else { mpStart1 }
    mpWaitGo = if(quickStart) { mpWaitGo1 } else { mpWaitGo3 }

    if(quickStart) {
      startRealtime = SystemClock.elapsedRealtime() + .milliseconds(Go1ClipDuration)
      handler.post(startRunnable)
    } else {
      startRealtime = SystemClock.elapsedRealtime() + .milliseconds(startDelayMS)
      handler.postDelayed(startRunnable, delayMS: startDelayMS - Go3ClipDuration)
    }

    return true
  }

  func powerStart(quickStart: Bool) -> Bool {
    self.quickStart = quickStart
    mpStart = if(quickStart) { mpStart2 } else { mpStart1 }

    if(quickStart) {
      startRealtime = SystemClock.elapsedRealtime() + .milliseconds(Go1ClipDuration)
      handler.post(startRunnable)
    } else {
      startRealtime = SystemClock.elapsedRealtime() + .milliseconds(PowerStartOffset)
      handler.postDelayed(startRunnable, delayMS: PowerClipOffset)
    }

    return true
  }

  func resumePacing(_ pacingOptions: PacingOptions, _ resumeTime: Int64) -> Bool {
    waypointIndexList = waypointsFor(pacingOptions.baseDist)

    prevTime      = waypointCalculator.initResume(pacingOptions.baseDist, pacingOptions.runLane, pacingOptions.baseTime, resumeTime.toDouble())
    startRealtime = SystemClock.elapsedRealtime() - .milliseconds(resumeTime)
    handler.post(resumeRunnable)
    return true
  }

  func beginRun() {
    prevTime = 0.0
    (waypointTime, waypointWait) = waypointCalculator.nextWaypoint()

    let runnable = (waypointWait > 0.0) ? waitRunnable : waypointRunnable
    let delay    = waypointTime.toLong() - elapsedTime()
    handler.postDelayed(runnable, delayMS: delay)
  }

  func elapsedTime() -> Int64 {
    let diff = (SystemClock.elapsedRealtime() - startRealtime).components
    return diff.seconds*1000 + diff.attoseconds/1000000000000000
  }

  func waitingTime() -> Int64 {
    return waypointCalculator.runWaitingTime()
  }

  func timeRemaining(_ elapsedTime: Int64) -> Int64 {
    return waypointCalculator.runTotalTime() - elapsedTime
  }

  func waitRemaining(_ elapsedTime: Int64) -> Int64 {
    let waitLeft = (waypointTime + waypointWait).toLong() - elapsedTime
    if(waitLeft > waypointWait.toLong()) { return 0 }

    return max(0, waitLeft)
  }

  func distOnPace() -> Double {
    return waypointCalculator.distOnPace()
  }

  func distOnPace(_ elapsedTime: Int64) -> Double {
    return waypointCalculator.distOnPace(elapsedTime.toDouble())
  }

  func waypointName() -> String {
      let waypointNum = waypointCalculator.waypointNum()
      return waypointNames[waypointIndexList[waypointNum]]
  }

  func waypointProgress(_ elapsedTime: Int64) -> Double {
    let waypointTime = waypointCalculator.waypointTime()
    return min(1.0, (elapsedTime.toDouble() - prevTime) / (waypointTime - prevTime))
  }

  func onCreate() {
    do {
    /* mNM = getSystemService(NOTIFICATION_SERVICE) as NotificationManager
    val channel = NotificationChannel("TrackPacer_NC", "TrackPacer", NotificationManager.IMPORTANCE_LOW)
    channel.description = "TrackPacer notifications"
    mNM.createNotificationChannel(channel)

    val pendingIntent: PendingIntent =
      Intent(this, MainActivity::class.java).let { notificationIntent ->
        PendingIntent.getActivity(this, 0, notificationIntent, PendingIntent.FLAG_IMMUTABLE)
      }

    val notification: Notification = Notification.Builder(this, "TrackPacer_NC")
      .setContentTitle(getText(R.string.app_name))
      .setContentText(getText(R.string.app_pacing))
      .setSmallIcon(R.drawable.play_small)
      .setContentIntent(pendingIntent)
      .build()

    startForeground(1, notification) */

      let url321 = Bundle.main.url(forResource: "threetwoone", withExtension: ".m4a")!
      mpStart1    = try AVAudioPlayer(contentsOf: url321)

      let urlGo = Bundle.main.url(forResource: "go", withExtension: ".m4a")!
      mpStart2   = try AVAudioPlayer(contentsOf: urlGo)

      let urlResumed = Bundle.main.url(forResource: "resumed", withExtension: ".m4a")!
      mpResume        = try AVAudioPlayer(contentsOf: urlResumed)

      mpWaypoint = try (0 ..< clipList.size).map { (i: Int) in
        let url = Bundle.main.url(forResource: clipList[i], withExtension: ".m4a")!
        return try AVAudioPlayer(contentsOf: url)
      }

      let urlStop = Bundle.main.url(forResource: "stop", withExtension: ".m4a")!
      mpWaitStart = try AVAudioPlayer(contentsOf: urlStop)

      let url30 = Bundle.main.url(forResource: "30",   withExtension: ".m4a")!
      let url10 = Bundle.main.url(forResource: "10",   withExtension: ".m4a")!
      mpWait30  = try AVAudioPlayer(contentsOf: url30)
      mpWait10  = try AVAudioPlayer(contentsOf: url10)
      mpWaitGo1 = try AVAudioPlayer(contentsOf: urlGo)
      mpWaitGo3 = try AVAudioPlayer(contentsOf: url321)

      let urlComplete = Bundle.main.url(forResource: "complete", withExtension: ".m4a")!
      mpFinal = try AVAudioPlayer(contentsOf: urlComplete)

      finishDelegate = MPFinishDelegate(service: self)
      mpWaypoint[fL].delegate = finishDelegate

      waitDelegate = MPWaitDelegate(service: self)
      mpWaitStart.delegate = waitDelegate
      mpWait30.delegate = waitDelegate
      mpWait10.delegate = waitDelegate

      finalDelegate = MPFinalDelegate(service: self)
      mpFinal.delegate = finalDelegate
    } catch { }
  }

  deinit {
   // handler.removeCallbacks(startRunnable)
   // handler.removeCallbacks(waypointRunnable)

    mpStart1.stop()
    mpStart2.stop()
    mpResume.stop()
    for mp in mpWaypoint { mp.stop() }

    mpWaitStart.stop()
    mpWait30.stop()
    mpWait10.stop()
    mpWaitGo1.stop()
    mpWaitGo3.stop()

    /* audioManager.abandonAudioFocusRequest(focusRequest)
    mNM.cancel(1) */
  }

  /* func onAudioFocusChange(focusChange: Int) {
    if ((focusChange == AUDIOFOCUS_LOSS) || (focusChange == AUDIOFOCUS_LOSS_TRANSIENT) || (focusChange == AUDIOFOCUS_LOSS_TRANSIENT_CAN_DUCK)) {
      if (mpStart.isPlaying)  { mpStart.stop(); mpStart.prepare() }
      if (mpResume.isPlaying) { mpResume.stop(); mpResume.prepare() }
      for (mp in mpWaypoint) { if (mp.isPlaying) { mp.stop(); mp.prepare() } }

      audioManager.abandonAudioFocusRequest(focusRequest)
      handler.removeCallbacks(startRunnable)
    }
  } */

  private func handleWaypoint(_ delayMS: Int64) {
    let i = waypointIndexList[waypointCalculator.waypointNum()]
    // let res = audioManager.requestAudioFocus(focusRequest)
    // if(res == AUDIOFOCUS_REQUEST_GRANTED) {
      mpResume.stop()
      mpWaypoint[i].play(atTime: mpWaypoint[i].deviceCurrentTime + delayMS.toDouble()/1000.0)
    // }
  }

  private func handleWait(_ delayMS: Int64) {
    mpResume.stop()
    mpWaitStart.play(atTime: mpWaitStart.deviceCurrentTime + delayMS.toDouble()/1000.0)
  }

  func nextWaypoint() {
    if(waypointCalculator.waypointsRemaining()) {
      prevTime = waypointTime + waypointWait
      (waypointTime, waypointWait) = waypointCalculator.nextWaypoint()

      let delay    = waypointTime.toLong() - elapsedTime()
      let runnable = (waypointWait > 0)  ? waitRunnable : waypointRunnable
      handler.postDelayed(runnable, delayMS: delay)
    }
  }

  fileprivate func playFinalClip() {
    // Complete pacing if the user doesn't stop the pacing after another 6 minutes
    mpFinal.play(atTime: mpFinal.deviceCurrentTime + 360.0)
  }

  fileprivate func terminate() {
    serviceConnection.onServiceDisconnected()
  }

  fileprivate func playNextWaitClip() {
    let delay = (waypointTime + waypointWait).toLong() - elapsedTime()
    switch(delay) {
    case _ where delay > 30000:
      mpWait30.play(atTime: mpWait30.deviceCurrentTime + (delay - 30000).toDouble()/1000.0)

    case _ where delay > 10000:
      mpWait10.play(atTime: mpWait10.deviceCurrentTime + (delay - 10000).toDouble()/1000.0)

    default:
      mpWaitGo.play(atTime: mpWaitGo.deviceCurrentTime + (delay - (quickStart ? Go1ClipDuration : Go3ClipDuration)).toDouble()/1000.0)
    }
  }
}
