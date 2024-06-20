//
//  WaypointService.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 22/05/2024.
//

import Foundation
import AVKit

private class MPStartDelegate : NSObject, AVAudioPlayerDelegate {
  weak var service: WaypointService?

  init(service: WaypointService) {
    self.service = service
  }

  @MainActor func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    service?.beginRun()
  }
}

private class MPWaypointDelegate : NSObject, AVAudioPlayerDelegate {
  weak var service: WaypointService?

  init(service: WaypointService) {
    self.service = service
  }

  @MainActor func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    service?.nextWaypoint()
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

  private var startRealtime: ContinuousClock.Instant!
  private var prevTime = -1.0

  private func waypointRunnable(delayMS: Int64) {
    handleWaypoint(delayMS)
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

  private var startDelegate: AVAudioPlayerDelegate!
  private var waypointDelegate: AVAudioPlayerDelegate!

  private var finishDelegate: AVAudioPlayerDelegate!
  private var finalDelegate: AVAudioPlayerDelegate!

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

  func beginPacing(_ pacingOptions: PacingOptions, _ alternateStart: Bool, _ waypoints: [WaypointData]) {
    waypointIndexList  = waypointsFor(pacingOptions.runDist, alternateStart)
    prevTime           = 0.0

    waypointCalculator.initRun(pacingOptions.runDist, pacingOptions.runLane, pacingOptions.runTime, waypoints)
  }

  func delayStart(startDelayMS: Int64, quickStart: Bool) -> Bool {
    mpStart = if(quickStart) { mpStart2 } else { mpStart1 }

    if(quickStart) {
      startRealtime = SystemClock.elapsedRealtime() + .milliseconds(Go1ClipDuration)
      handler.post(startRunnable)
    } else {
      startRealtime = SystemClock.elapsedRealtime() + .milliseconds(startDelayMS)
      handler.postDelayed(startRunnable, delayMS: startDelayMS - Go4ClipDuration)
    }

    return true
  }

  func powerStart(quickStart: Bool) -> Bool {
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

  func resumePacing(_ pacingOptions: PacingOptions, _ alternateStart: Bool, _ resumeTime: Int64) -> Bool {
    waypointIndexList = waypointsFor(pacingOptions.runDist, alternateStart)

    prevTime      = waypointCalculator.initResume(pacingOptions.runDist, pacingOptions.runLane, pacingOptions.runTime, resumeTime.toDouble())
    startRealtime = SystemClock.elapsedRealtime() - .milliseconds(resumeTime)
    handler.post(resumeRunnable)
    return true
  }

  fileprivate func beginRun() {
    let nextTime   = waypointCalculator.waypointTime()
    let updateTime = (nextTime - elapsedTime().toDouble()).toLong()
    if(updateTime >= 0) {handler.postDelayed(waypointRunnable, delayMS: updateTime) }
  }

  func elapsedTime() -> Int64 {
    let diff = (SystemClock.elapsedRealtime() - startRealtime).components
    return diff.seconds*1000 + diff.attoseconds/1000000000000000
  }

  func timeRemaining(_ elapsedTime: Int64) -> Int64 {
    return waypointCalculator.runTime() - elapsedTime
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

      let urlComplete = Bundle.main.url(forResource: "complete", withExtension: ".m4a")!
      mpFinal = try AVAudioPlayer(contentsOf: urlComplete)

      /* audioManager = getSystemService(Context.AUDIO_SERVICE) as AudioManager
       focusRequest = AudioFocusRequest.Builder(AUDIOFOCUS_GAIN).run {
       setAudioAttributes(AudioAttributes.Builder().run {
          setUsage(AudioAttributes.USAGE_ASSISTANCE_NAVIGATION_GUIDANCE)
          setContentType(AudioAttributes.CONTENT_TYPE_SPEECH)
          setFocusGain(AUDIOFOCUS_GAIN_TRANSIENT_MAY_DUCK)
          build()
       })
       setOnAudioFocusChangeListener(this@WaypointService, handler)
       build()
     } */

      startDelegate = MPStartDelegate(service: self)
      mpStart1.delegate = startDelegate
      mpStart2.delegate = startDelegate
      mpResume.delegate = startDelegate

      waypointDelegate = MPWaypointDelegate(service: self)
      for i in 0..<fL { mpWaypoint[i].delegate = waypointDelegate }

      finishDelegate = MPFinishDelegate(service: self)
      mpWaypoint[fL].delegate = finishDelegate

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

  fileprivate func nextWaypoint() {
    if(waypointCalculator.waypointsRemaining()) {
     prevTime = waypointCalculator.waypointTime()

     let waypointTime = waypointCalculator.nextWaypoint()
     handler.postDelayed(waypointRunnable, delayMS: waypointTime.toLong()-elapsedTime())
    }
  }

  fileprivate func playFinalClip() {
    // Complete pacing if the user doesn't stop the pacing after another 6 minutes
    mpFinal.play(atTime: mpFinal.deviceCurrentTime + 360.0)
  }

  fileprivate func terminate() {
    serviceConnection.onServiceDisconnected()
  }
}
