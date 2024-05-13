//
//  PaceView.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 12/05/2024.
//

import SwiftUI

struct PaceView: View {
  let viewModel: PaceViewModel
  @ObservedObject var pacingStatus: PacingStatus
  @ObservedObject var pacingOptions: PacingOptions
  @ObservedObject var pacingProgress: PacingProgress

  init(viewModel: PaceViewModel) {
    self.viewModel = viewModel

    pacingStatus   = viewModel.pacingStatus
    pacingOptions  = viewModel.pacingOptions
    pacingProgress = viewModel.pacingProgress
  }

  var body: some View {
    let isPacing = pacingStatus.isPacing

    VStack(alignment: .leading, spacing: 4) {
      HStack {
        Spacer()
        Text(timeToFullString(timeInMS: pacingProgress.elapsedTime)).font(.system(size: 46, weight: .regular, design: .default)).monospacedDigit()
        Spacer()
      }

      Spacer().frame(height: 10)

      Text("Distance in lane \(pacingOptions.runLane)")
      Text("\(pacingOptions.totalDistStr) (\(pacingOptions.runLaps))").font(.system(size: 30, weight: .regular, design: .default))

      Spacer().frame(height: 10)

      Text("Target time")
      Text("\(pacingOptions.totalTimeStr) (\(pacingOptions.totalPaceStr)/km)").font(.system(size: 30, weight: .regular, design: .default))

      Spacer().frame(height: 10)

      Text("Profile")
      Text("\(pacingOptions.runProf)").font(.system(size: 30, weight: .regular, design: .default))

      Spacer()

      VStack(alignment: .leading, spacing: 2) {
        let showPacing = (pacingProgress.distRun >= 0)

        Text("Distance run (on pace):")
        Text(showPacing ? String(format: "%.2fm", pacingProgress.distRun) : " ").font(.system(size: 30, weight: .regular, design: .default))

        Spacer().frame(height: 10)

        Text("Next up: \(showPacing ? pacingProgress.waypointName : "")")
        ProgressView(value: pacingProgress.waypointProgress).progressViewStyle(PacingProgressStyle())

        Spacer().frame(height: 10)

        Text("Time to target: \(showPacing ? timeToString(timeInMS: pacingProgress.timeRemaining) : "")")
        ProgressView(value: pacingProgress.timeToProgress).progressViewStyle(PacingProgressStyle())
      }

      Spacer()

      HStack {
        Button(action: { viewModel.setPacingStatus(pacingStatus: .NotPacing) }) { Text(" ").overlay { Image(isPacing ? "stop" : "stop2") } }
          .buttonStyle(ActionButtonStyleMax(disabledCol: true)).disabled(!isPacing)

        Button(action: { viewModel.setPacingStatus(pacingStatus: .Pacing) })    { Text(" SET ") }
          .buttonStyle(ActionButtonStyleMax(disabledCol: isPacing)).disabled( isPacing)
      }.padding(.bottom, 5)
    }.toolbar() {
      ToolbarItem(placement: .navigationBarTrailing) {
        StatusView()
      }
    }.navigationBarBackButtonHidden(pacingStatus.isPacing).padding(.horizontal, 20)
  }
}
