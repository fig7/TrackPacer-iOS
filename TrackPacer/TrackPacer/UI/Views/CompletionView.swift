//
//  CompletionView.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 29/05/2024.
//

import SwiftUI

struct CompletionView: View {
  @EnvironmentObject var viewModel: CompletionViewModel
  @EnvironmentObject var resultData: ResultData

  var body: some View {
    VStack {
      ScrollView {
        VStack(alignment: .leading, spacing: 4) {
          let runData      = resultData.runData
          let computedData = resultData.computedData

          Text("Pacing on")
          Text(computedData.fullRunDate).font(.system(size: 30, weight: .regular, design: .default))

          Spacer().frame(height: 10)

          Text("Distance run (at \"\(runData.runProf)\")")
          Text("\(runData.totalDistStr) (\(runData.runDist) in L\(runData.runLane))").lineLimit(1).font(.system(size: 30, weight: .regular, design: .default)).minimumScaleFactor(0.5)

          Spacer().frame(height: 10)

          Text("Target time")
          Text("\(runData.totalTimeStr) (\(runData.totalPaceStr)/km)").font(.system(size: 30, weight: .regular, design: .default))

          Spacer().frame(height: 10)

          Text("Actual time")
          Text("\(runData.actualTimeStr) (\(runData.actualPaceStr)/km)").font(.system(size: 30, weight: .regular, design: .default))
          Text("\(runData.earlyLateStr)").font(.system(size: 30, weight: .regular, design: .default))

          Spacer().frame(height: 10)

          Text("Your notes:")
          TextEditor(text: $resultData.runData.runNotes)
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
