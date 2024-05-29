//
//  CompletionView.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 29/05/2024.
//

import SwiftUI

struct CompletionView: View {
  @EnvironmentObject var viewModel: CompletionViewModel

    var body: some View {
      VStack(alignment: .leading) {
        Text("Pacing on")
        Text(viewModel.runDate).font(.system(size: 30, weight: .regular, design: .default))

        Spacer()

        HStack {
          Button(action: { viewModel.finishRun() }) { Text(" ").overlay { Image("baseline_delete_forever_48") } }
            .buttonStyle(ActionButtonStyleMax(disabledCol: true)).disabled(false)
          Button(action: { viewModel.saveRun() }) { Text(" SAVE ") }
            .buttonStyle(ActionButtonStyleMax(disabledCol: false)).disabled(false)
        }.padding(.bottom, 5)
      }.toolbar() {
        ToolbarItem(placement: .navigationBarTrailing) {
          StatusView()
        }
      }.navigationBarBackButtonHidden(true).padding(.horizontal, 20)
    }
}

