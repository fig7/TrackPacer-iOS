//
//  PastView.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 02/06/2024.
//

import SwiftUI

struct PastView: View {
  @EnvironmentObject var viewModel: PastViewModel
  @EnvironmentObject var resultData: ResultData

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 4) {
        let runData      = resultData.runData
        let computedData = resultData.computedData

        Spacer().frame(height: 10)

        Text("Pacing on")
        Text(computedData.fullRunDate).font(.system(size: 30, weight: .regular, design: .default))

        Spacer().frame(height: 10)

        Text("Distance run (at \"\(runData.runProf)\")")
        Text("\(runData.runDistStr) (\(runData.baseDist) in L\(runData.runLane))").lineLimit(1).font(.system(size: 30, weight: .regular, design: .default)).minimumScaleFactor(0.5)

        Spacer().frame(height: 10)

        Text("Target time")
        Text("\(runData.runTimeStr) (\(runData.runPaceStr)/km)").font(.system(size: 30, weight: .regular, design: .default))

        Spacer().frame(height: 10)

        Text("Actual time")
        Text("\(runData.actualTimeStr) (\(runData.actualPaceStr)/km)").font(.system(size: 30, weight: .regular, design: .default))
        Text("\(runData.earlyLateStr)").font(.system(size: 30, weight: .regular, design: .default))

        Spacer().frame(height: 10)

        Text("Your notes:")

        let runNotes = resultData.runData.runNotes
        Text(runNotes.isEmpty ? "*No notes added*" : runNotes)
          .padding(5).frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
      }
    }.toolbar() {
      ToolbarItem(placement: .navigationBarTrailing) {
        StatusView()
      }
    }.navigationBarBackButtonHidden(false).padding(.horizontal, 20)
  }
}
