//
//  WaypointService.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 22/05/2024.
//

import Foundation
import AVKit

private let clipList = [
  "fifty",
  "onehundred",
  "onehundredandfifty",
  "twohundred",
  "twohundredandfifty",
  "threehundred",
  "threehundredandfifty",
  "lap2",
  "lap3",
  "lap4",
  "lap5",
  "lap6",
  "lap7",
  "lap8",
  "lap9",
  "lap10",
  "lap11",
  "lap12",
  "lap13",
  "lap14",
  "lap15",
  "lap16",
  "lap17",
  "lap18",
  "lap19",
  "lap20",
  "lap21",
  "lap22",
  "lap23",
  "lap24",
  "lap25",
  "finish"]

private let clipNames = [
  "50m",    "100m",   "150m",   "200m",   "250m",   "300m",   "350m",
  "Lap 2",  "Lap 3",  "Lap 4",  "Lap 5",  "Lap 6",  "Lap 7",  "Lap 8",  "Lap 9",
  "Lap 10", "Lap 11", "Lap 12", "Lap 13", "Lap 14", "Lap 15", "Lap 16", "Lap 17",
  "Lap 18", "Lap 19", "Lap 20", "Lap 21", "Lap 22", "Lap 23", "Lap 24", "Lap 25", "Finish line"]

private let fL = clipList.size - 1
private let clipMap = [
  "400m"    : [0, 1, 2, 3, 4, 5 ,6, fL],
  "800m"    : [0, 1, 2, 3, 4, 5 ,6,  7, 0, 1, 2, 3, 4, 5, 6, fL],
  "1000m"   : [            0, 1, 2,  7, 0, 1, 2, 3, 4, 5, 6,  8, 0, 1, 2, 3, 4, 5, 6, fL],
  "1000m_a" : [0, 1, 2, 3, 4, 5, 6,  7, 0, 1, 2, 3, 4, 5, 6,  8, 0, 1, 2, fL],
  "1200m"   : [0, 1, 2, 3, 4, 5 ,6,  7, 0, 1, 2, 3, 4, 5, 6,  8, 0, 1, 2, 3, 4, 5, 6, fL],
  "1500m"   : [      0, 1, 2, 3 ,4,  7, 0, 1, 2, 3, 4, 5, 6,  8, 0, 1, 2, 3, 4, 5, 6,  9, 0, 1, 2, 3, 4, 5, 6, fL],
  "2000m"   : [0, 1, 2, 3, 4, 5 ,6,  7, 0, 1, 2, 3, 4, 5, 6,  8, 0, 1, 2, 3, 4, 5, 6,  9, 0, 1, 2, 3, 4, 5, 6, 10, 0, 1, 2, 3, 4, 5, 6, fL],
  "3000m"   : [            0, 1, 2,  7, 0, 1 ,2, 3, 4, 5, 6,  8, 0, 1, 2, 3, 4, 5, 6,  9, 0, 1, 2, 3, 4, 5, 6, 10,
               0, 1 ,2, 3, 4, 5, 6, 11, 0, 1, 2, 3, 4, 5, 6, 12, 0, 1, 2, 3, 4, 5, 6, 13, 0, 1, 2, 3, 4, 5, 6, fL],
  "3000m_a" : [0, 1, 2, 3, 4, 5, 6,  7, 0, 1 ,2, 3, 4, 5, 6,  8, 0, 1, 2, 3, 4, 5, 6,  9, 0, 1, 2, 3, 4, 5, 6, 10,
               0, 1 ,2, 3, 4, 5, 6, 11, 0, 1, 2, 3, 4, 5, 6, 12, 0, 1, 2, 3, 4, 5, 6, 13, 0, 1, 2, fL],
  "4000m"   : [0, 1, 2, 3, 4, 5 ,6,  7, 0, 1, 2, 3, 4, 5, 6,  8, 0, 1, 2, 3, 4, 5, 6,  9, 0, 1, 2, 3, 4, 5, 6, 10,
               0, 1, 2, 3, 4, 5, 6, 11, 0, 1, 2, 3, 4, 5 ,6, 12, 0, 1, 2, 3, 4, 5, 6, 13, 0, 1, 2, 3, 4, 5, 6, 14,
               0, 1, 2, 3, 4, 5, 6, 15, 0, 1, 2, 3, 4, 5, 6, fL],
  "5000m"   : [            0, 1, 2,  7, 0, 1 ,2, 3, 4, 5, 6,  8, 0, 1, 2, 3, 4, 5, 6,  9, 0, 1, 2, 3, 4, 5, 6, 10,
               0, 1, 2, 3, 4, 5, 6, 11, 0, 1, 2, 3, 4, 5, 6, 12, 0, 1, 2, 3, 4, 5, 6, 13, 0, 1, 2, 3, 4, 5, 6, 14,
               0, 1, 2, 3, 4, 5, 6, 15, 0, 1, 2, 3, 4, 5, 6, 16, 0, 1, 2, 3, 4, 5, 6, 17, 0, 1, 2, 3, 4, 5, 6, 18, 0, 1, 2, 3, 4, 5, 6, fL],
  "5000m_a" : [0, 1, 2, 3, 4, 5, 6,  7, 0, 1 ,2, 3, 4, 5, 6,  8, 0, 1, 2, 3, 4, 5, 6,  9, 0, 1, 2, 3, 4, 5, 6, 10,
               0, 1, 2, 3, 4, 5, 6, 11, 0, 1, 2, 3, 4, 5, 6, 12, 0, 1, 2, 3, 4, 5, 6, 13, 0, 1, 2, 3, 4, 5, 6, 14,
               0, 1, 2, 3, 4, 5, 6, 15, 0, 1, 2, 3, 4, 5, 6, 16, 0, 1, 2, 3, 4, 5, 6, 17, 0, 1, 2, 3, 4, 5, 6, 18, 0, 1, 2, fL],
  "10000m"  : [0, 1, 2, 3, 4, 5 ,6,  7, 0, 1, 2, 3, 4, 5, 6,  8, 0, 1, 2, 3, 4, 5, 6,  9, 0, 1, 2, 3, 4, 5, 6, 10,
               0, 1, 2, 3, 4, 5, 6, 11, 0, 1, 2, 3, 4, 5, 6, 12, 0, 1, 2, 3, 4, 5, 6, 13, 0, 1, 2, 3, 4, 5, 6, 14,
               0, 1, 2, 3, 4, 5, 6, 15, 0, 1, 2, 3, 4, 5, 6, 16, 0, 1, 2, 3, 4, 5, 6, 17, 0, 1, 2, 3, 4, 5, 6, 18,
               0, 1, 2, 3, 4, 5, 6, 19, 0, 1, 2, 3, 4, 5, 6, 20, 0, 1, 2, 3, 4, 5, 6, 21, 0, 1, 2, 3, 4, 5, 6, 22,
               0, 1, 2, 3, 4, 5, 6, 23, 0, 1, 2, 3, 4, 5, 6, 24, 0, 1, 2, 3, 4, 5, 6, 25, 0, 1, 2, 3, 4, 5, 6, 26,
               0, 1, 2, 3, 4, 5, 6, 27, 0, 1, 2, 3, 4, 5, 6, 28, 0, 1, 2, 3, 4, 5, 6, 29, 0, 1, 2, 3, 4, 5, 6, 30, 0, 1, 2, 3, 4, 5, 6, fL],
  "1 mile"  : [0, 1, 2, 3, 4, 5 ,6,  7, 0, 1, 2, 3, 4, 5, 6,  8, 0, 1, 2, 3, 4, 5, 6,  9, 0, 1, 2, 3, 4, 5, 6, fL]]

private let Go1ClipDuration: Int64  = 400
private let Go4ClipDuration: Int64  = 3000
private let PowerStartOffset: Int64 = 4000
private let PowerClipOffset: Int64  = 1000

private let SystemClock = ContinuousClock()

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

@MainActor class WaypointService /* : OnAudioFocusChangeListener */ {
  private var startRealtime: ContinuousClock.Instant!
  private var prevTime = -1.0

  // private lateinit var mNM: NotificationManager
  // private lateinit var audioManager: AudioManager
  // private lateinit var focusRequest: AudioFocusRequest

  private let handler = Handler()

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

  private let waypointCalculator = WaypointCalculator()
  private var clipIndexList: [Int]!

  private weak var serviceConnection: ServiceConnection?

  init(serviceConnection: ServiceConnection?) {
    self.serviceConnection = serviceConnection
    onCreate()

    Task { @MainActor in
      serviceConnection?.onServiceConnected()
    }
  }

  private func clipKeyFromArgs(_ runDist: String, _ alternateStart: Bool) -> String {
    var clipKey = runDist
    if(alternateStart && (["1000m", "3000m", "5000m"].contains(runDist))) {
      clipKey += "_a"
    }

    return clipKey
  }

  func beginPacing(runDist: String, runLane: Int, runTime: Double, alternateStart: Bool) {
    let clipKey   = clipKeyFromArgs(runDist, alternateStart)
    clipIndexList = clipMap[clipKey]!
    prevTime      = 0.0

    waypointCalculator.initRun(runDist, runTime, runLane)
  }

  func delayStart(startDelay: Int64, quickStart: Bool) -> Bool {
    mpStart = if(quickStart) { mpStart2 } else { mpStart1 }

    if(quickStart) {
      startRealtime = SystemClock.elapsedRealtime() + .milliseconds(Go1ClipDuration)
      handler.post(startRunnable)
    } else {
      startRealtime = SystemClock.elapsedRealtime() + .milliseconds(startDelay)
      handler.postDelayed(startRunnable, delayMS: startDelay - Go4ClipDuration)
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

  func resumePacing(runDist: String, runLane: Int, runTime: Double, alternateStart: Bool, resumeTime: Int64) -> Bool {
    let clipKey   = clipKeyFromArgs(runDist, alternateStart)
    clipIndexList = clipMap[clipKey]!
    prevTime      = waypointCalculator.initResume(runDist, runTime, runLane, resumeTime.toDouble())

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
      return clipNames[clipIndexList[waypointNum]]
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
    let i = clipIndexList[waypointCalculator.waypointNum()]
    // let res = audioManager.requestAudioFocus(focusRequest)
    // if(res == AUDIOFOCUS_REQUEST_GRANTED) {
      mpResume.stop()
      mpWaypoint[i].play(atTime: mpWaypoint[i].deviceCurrentTime + delayMS.toDouble()/1000.0)
    // }

    /* if(waypointCalculator.waypointsRemaining()) {
     prevTime = waypointCalculator.waypointTime()
     
     let waypointTime = waypointCalculator.nextWaypoint()
     handler.postDelayed(waypointRunnable, delayMS: waypointTime.toLong()-elapsedTime())
    } */
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
    serviceConnection?.onServiceDisconnected()
  }
}
