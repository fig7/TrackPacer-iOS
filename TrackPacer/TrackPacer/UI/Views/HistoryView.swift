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

      ScrollView {
        if(viewModel.historyList.isEmpty) {
          Text("No history yet").padding()
        } else {
          Divider()
        }

        LazyVStack {
          ForEach(viewModel.historyList) { resultData in
            VStack(alignment: .leading, spacing: 0) {
              HStack(spacing: 0) {
                WeightedHStack() { proxy in
                  let runData      = resultData.runData
                  let computedData = resultData.computedData

                  Text(computedData.shortRunDist).weighted(0.24, proxy)
                  Text(computedData.shortRunDate).weighted(0.30, proxy)
                  Text(runData.actualTimeStr).weighted(0.24, proxy)
                  Text(runData.actualPaceStr + "/km").weighted(0.22, proxy)
                }

                Text("  >")
              }.padding(.vertical, 16)
               .onTapGesture { viewModel.showHistory(resultData) }
               .onLongPressGesture(perform: { viewModel.deleteHistory(resultData) })

              Divider()
            }.frame(maxWidth: .infinity)
          }
        }
      }
    }.padding(.horizontal, 20)
  }
}
