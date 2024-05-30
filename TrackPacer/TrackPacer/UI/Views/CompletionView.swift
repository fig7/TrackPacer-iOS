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
    VStack {
      ScrollView {
        VStack(alignment: .leading, spacing: 4) {
          Text("Pacing on")
          Text(viewModel.runDate).font(.system(size: 30, weight: .regular, design: .default))

          Spacer().frame(height: 10)

          Text("Distance run (at \"\(viewModel.runProf)\")")
          Text("\(viewModel.totalDist) (\(viewModel.runDist) in L\(viewModel.runLane))").lineLimit(1).font(.system(size: 30, weight: .regular, design: .default)).minimumScaleFactor(0.5)

          Spacer().frame(height: 10)

          Text("Target time")
          Text("\(viewModel.totalTime) (\(viewModel.totalPace)/km)").font(.system(size: 30, weight: .regular, design: .default))

          Spacer().frame(height: 10)

          Text("Actual time")
          Text("\(viewModel.actualTime) (\(viewModel.actualPace)/km)").font(.system(size: 30, weight: .regular, design: .default))
          Text("\(viewModel.earlyLate)").font(.system(size: 30, weight: .regular, design: .default))

          Spacer().frame(height: 10)

          Text("Your notes:")
          TextEditor(text: $viewModel.runNotes)
            .padding(.top, 4).padding(.bottom, 5).frame(height: 142.0).border(.blue)
        }
      }.scrollDismissesKeyboard(.interactively)

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
