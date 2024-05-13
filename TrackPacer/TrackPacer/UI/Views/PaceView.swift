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
    let isPacing = pacingStatus.isPacing

    VStack(spacing: 5) {
      Spacer()

      HStack {
        Button(action: { viewModel.setPacingStatus(pacingStatus: .NotPacing) }) { Text(" STOP ").opacity(0.0).overlay { Image(isPacing ? "stop" : "stop2") } }
          .buttonStyle(ActionButtonStyleMax(disabledCol: true)).disabled(!isPacing)

        Button(action: { viewModel.setPacingStatus(pacingStatus: .Pacing) })    { Text(" SET ") }
          .buttonStyle(ActionButtonStyleMax(disabledCol: isPacing)).disabled( isPacing)
      }.padding(.horizontal, 20).padding(.bottom, 5)
    }.toolbar() {
      ToolbarItem(placement: .navigationBarTrailing) {
        StatusView()
      }
    }.navigationBarBackButtonHidden(pacingStatus.isPacing)
  }
}
