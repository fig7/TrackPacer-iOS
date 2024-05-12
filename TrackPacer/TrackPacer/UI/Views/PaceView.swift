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

  init(viewModel: PaceViewModel) {
    self.viewModel = viewModel

    pacingStatus = viewModel.pacingStatus
  }

  var body: some View {
    VStack(spacing: 5) {
      Spacer()

      HStack {
        let stopDisabled = !pacingStatus.isPacing
        Button(" STOP ") { viewModel.setPacingStatus(pacingStatus: .NotPacing) }.buttonStyle(ActionButtonStyleMax(disabled: stopDisabled)).disabled(stopDisabled)
        Button(" SET ")  { viewModel.setPacingStatus(pacingStatus: .Pacing) }.buttonStyle(ActionButtonStyleMax(disabled: !stopDisabled))
      }.padding(.horizontal, 20).padding(.bottom, 5)
    }.toolbar() {
      ToolbarItem(placement: .navigationBarTrailing) {
        StatusView()
      }
    }.navigationBarBackButtonHidden(pacingStatus.isPacing)
  }
}
