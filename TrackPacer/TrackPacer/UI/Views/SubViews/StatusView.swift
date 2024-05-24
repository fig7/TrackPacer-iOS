//
//  StatusView.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 10/05/2024.
//

import SwiftUI

struct StatusView: View {
  let viewModel: StatusViewModel
  @ObservedObject var pacingStatus: PacingStatus
  @ObservedObject var pacingSettings: PacingSettings

  init(viewModel: StatusViewModel) {
    self.viewModel = viewModel
    self.pacingStatus = viewModel.pacingStatus
    self.pacingSettings = viewModel.pacingSettings
  }

    var body: some View {
      HStack {
        switch(pacingStatus.status) {
        case .NotPacing, .ServiceStart, .PacingCancel, .PacingComplete:
          pacingSettings.powerStart ? Image("power_stop_small") : Image("stop_small")

        case .PacingWait:
          Image("power_small")

        case .PacingStart:
          pacingSettings.powerStart ? Image("power_small") : Image("stop_small")

        case .Pacing, .PacingPause:
          Image("play_small")

        case .PacingPaused, .ServiceResume, .PacingResume:
          Image("pause_small")
        }

        Image("baseline_phone_20")

        let delayText = if(pacingSettings.quickStart) { "QCK" } else if(pacingSettings.powerStart) {"PWR" } else { pacingSettings.startDelay }
        Text(delayText)
      }.padding(.vertical, 5)
    }
}
