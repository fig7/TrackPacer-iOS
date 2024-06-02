//
//  HistoryView.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 10/05/2024.
//

import SwiftUI

struct HistoryView: View {
  @EnvironmentObject var viewModel: HistoryViewModel

  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      Text("Pacing history").font(.largeTitle).frame(maxWidth: .infinity, alignment: .leading)
      Spacer().frame(height: 32)

      Color(.black).frame(height: 1).frame(maxWidth: .infinity)
      ScrollView {
        LazyVStack {
          ForEach($viewModel.historyList) { $resultData in
            VStack(alignment: .leading, spacing: 0) {
              HStack(spacing: 0) {
                WeightedHStack() { proxy in
                  let runData      = resultData.runData
                  let computedData = resultData.computedData

                  Text(runData.runDist).weighted(0.25, proxy)
                  Text(computedData.shortRunDate).weighted(0.28, proxy)
                  Text(runData.actualTimeStr).weighted(0.24, proxy)
                  Text(runData.actualPaceStr + "/km").weighted(0.23, proxy)
                }

                Text(">")
              }.padding(.vertical, 16).onLongPressGesture(perform: { /* TODO: Delete action */})

              Color(.black).frame(height: 1).frame(maxWidth: .infinity)
            }.frame(maxWidth: .infinity)
          }
        }
      }
    }.padding(.horizontal, 20)
  }
}
