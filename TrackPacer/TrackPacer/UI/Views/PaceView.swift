//
//  PaceView.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 12/05/2024.
//

import SwiftUI

struct PaceView: View {
  @EnvironmentObject var viewModel: PaceViewModel

  @EnvironmentObject var pacingOptions: PacingOptions
  @EnvironmentObject var pacingProgress: PacingProgress

  @EnvironmentObject var pacingStatus: PacingStatus
  @EnvironmentObject var pacingSettings: PacingSettings

  var body: some View {
    VStack(alignment: .leading, spacing: 4) {
      HStack {
        Spacer()
        Text(timeToFullString(timeInMS: pacingProgress.elapsedTime)).font(.system(size: 46, weight: .regular, design: .default)).monospacedDigit()
        Spacer()
      }

      Spacer().frame(height: 10)

      Text("Distance in lane \(pacingOptions.runLane)")
      Text("\(pacingOptions.runDistStr) (\(pacingOptions.runLaps))").lineLimit(1).font(.system(size: 30, weight: .regular, design: .default)).minimumScaleFactor(0.5)

      Spacer().frame(height: 10)

      Text("Target time")
      Text("\(pacingOptions.runTimeStr) (\(pacingOptions.runPaceStr)/km)").font(.system(size: 30, weight: .regular, design: .default))

      Spacer().frame(height: 10)

      Text("Profile")
      Text("\(pacingOptions.runProf)").font(.system(size: 30, weight: .regular, design: .default))

      Spacer()

      VStack(alignment: .leading, spacing: 2) {
        let hidePacing = (pacingProgress.timeRemaining == nil)
        let running    = (pacingProgress.waitRemaining == 0)

        Text("Distance run (on pace):")
        Text(hidePacing ? " " : String(format: "%.2fm", pacingProgress.distRun)).font(.system(size: 30, weight: .regular, design: .default)).monospacedDigit()

        Spacer().frame(height: 10)

        Text("\(running ? "Next up: " + pacingProgress.waypointName : "Waiting: " + timeToString(timeInMS: pacingProgress.waitRemaining))").monospacedDigit()
        ProgressView(value: pacingProgress.waypointProgress).progressViewStyle(PacingProgressStyle())

        Spacer().frame(height: 10)

        Text("Time to target: \(hidePacing ? "" : timeToString(timeInMS: pacingProgress.timeRemaining!))").monospacedDigit()
        ProgressView(value: pacingProgress.timeToProgress).progressViewStyle(PacingProgressStyle())
      }

      Spacer()

      HStack {
        let goText         = (!pacingSettings.quickStart || pacingSettings.powerStart) ? " SET " : " GO! "
        let pacingOver     = ((pacingProgress.timeRemaining ?? -1) < 0)
        let pacingStatus   = pacingStatus.status

        switch(pacingStatus) {
        case .NotPacing:
          Button(action: { }) { Text(" ").overlay { Image("stop2") } }
            .buttonStyle(ActionButtonStyleMax(disabledCol: true)).disabled(true)
          Button(action: { viewModel.beginPacing() }) { Text(goText) }
            .buttonStyle(ActionButtonStyleMax(disabledCol: false)).disabled(false)

        case .ServiceStart:
          Button(action: { viewModel.stopPacing(silent: false) }) { Text(" ").overlay { Image("stop") } }
            .buttonStyle(ActionButtonStyleMax(disabledCol: true)).disabled(false)
          Button(action: { }) { Text(goText) }
            .buttonStyle(ActionButtonStyleMax(disabledCol: true)).disabled(true)

        case .PacingWait:
          Button(action: { viewModel.stopPacing(silent: false) }) { Text(" ").overlay { Image("stop") } }
            .buttonStyle(ActionButtonStyleMax(disabledCol: true)).disabled(false)
          Button(action: { }) { Text(goText) }
            .buttonStyle(ActionButtonStyleMax(disabledCol: true)).disabled(true)

        case .PacingStart:
          Button(action: { viewModel.stopPacing(silent: false) }) { Text(" ").overlay { Image("stop") } }
            .buttonStyle(ActionButtonStyleMax(disabledCol: true)).disabled(false)
          Button(action: { }) { Text(goText) }
            .buttonStyle(ActionButtonStyleMax(disabledCol: true)).disabled(true)

        case .Pacing:
          Button(action: { viewModel.stopPacing(silent: false) }) { Text(" ").overlay { Image("stop") } }
            .buttonStyle(ActionButtonStyleMax(disabledCol: true)).disabled(false)
          Button(action: { viewModel.pausePacing(silent: false) }) { Text(" ").overlay { Image("pause") } }
            .buttonStyle(ActionButtonStyleMax(disabledCol: true)).disabled(false)

        case .PacingPause:
          Button(action: { }) { Text(" ").overlay { Image("stop2") } }
            .buttonStyle(ActionButtonStyleMax(disabledCol: true)).disabled(true)
          Button(action: { }) { Text(" ").overlay { Image("pause2") } }
            .buttonStyle(ActionButtonStyleMax(disabledCol: true)).disabled(true)

        case .PacingPaused:
          Button(action: { viewModel.stopPacing(silent: false) }) { Text(" ").overlay { Image("stop") } }
            .buttonStyle(ActionButtonStyleMax(disabledCol: true)).disabled(false)
          Button(action: { viewModel.resumePacing() }) { Text(" ").overlay { Image(pacingOver ? "resume2" : "resume") } }
            .buttonStyle(ActionButtonStyleMax(disabledCol: true)).disabled(pacingOver)

        case .ServiceResume:
          Button(action: { viewModel.stopPacing(silent: false) }) { Text(" ").overlay { Image("stop") } }
            .buttonStyle(ActionButtonStyleMax(disabledCol: true)).disabled(false)
          Button(action: { }) { Text(" ").overlay { Image("resume2") } }
            .buttonStyle(ActionButtonStyleMax(disabledCol: true)).disabled(true)

        case .PacingResume:
          Button(action: { viewModel.stopPacing(silent: false) }) { Text(" ").overlay { Image("stop") } }
            .buttonStyle(ActionButtonStyleMax(disabledCol: true)).disabled(false)
          Button(action: { }) { Text(" ").overlay { Image("resume2") } }
            .buttonStyle(ActionButtonStyleMax(disabledCol: true)).disabled(true)

        case .PacingComplete:
          Button(action: { }) { Text(" ").overlay { Image("stop2") } }
            .buttonStyle(ActionButtonStyleMax(disabledCol: true)).disabled(true)
          Button(action: { }) { Text(goText) }
            .buttonStyle(ActionButtonStyleMax(disabledCol: true)).disabled(true)

        case .PacingCancel:
          Button(action: { }) { Text(" ").overlay { Image("stop2") } }
            .buttonStyle(ActionButtonStyleMax(disabledCol: true)).disabled(true)
          Button(action: { }) { Text(goText) }
            .buttonStyle(ActionButtonStyleMax(disabledCol: true)).disabled(true)
        }
      }.padding(.bottom, 5)
    }.toolbar() {
      ToolbarItem(placement: .navigationBarTrailing) {
        StatusView()
      }
    }.navigationBarBackButtonHidden(pacingStatus.status != .NotPacing).padding(.horizontal, 20)
  }
}
