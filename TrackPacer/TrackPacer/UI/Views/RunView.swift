//
//  RunView.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 10/05/2024.
//

import SwiftUI

struct RunView: View {
  let viewModel: RunViewModel

  @ObservedObject var distanceSelection: DistanceSelection
  @ObservedObject var laneSelection: LaneSelection
  @ObservedObject var timeSelection: TimeSelection

  @State var profileStr = "Fixed pace"
  var profileList = ["Fixed pace"]

  @ObservedObject var trackSelection: TrackSelection

  init(viewModel: RunViewModel) {
    self.viewModel = viewModel

    self.distanceSelection = viewModel.distanceSelection
    self.laneSelection     = viewModel.laneSelection
    self.timeSelection     = viewModel.timeSelection

    self.trackSelection    = viewModel.trackSelection
  }

  var body: some View {
    VStack(spacing: 5) {
      HStack {
        Text("Distance:").frame(width: 180, alignment: .leading)

        Spacer().frame(width: 15)

        Text("Lane:")

        Spacer()
      }.padding(.horizontal, 20)

      HStack {
        TPPicker(selected: $distanceSelection.selected, list: distanceSelection.list).frame(width: 180, height: 42, alignment: .center)
        Spacer().frame(width: 15)

        TPPicker(selected: $laneSelection.selected, list: laneSelection.list).frame(width: 80, height: 42, alignment: .center)

        Spacer()
      }.padding(.horizontal, 20)

      Spacer().frame(height: 5)

      HStack {
        Text("Time:")

        Spacer()
      }.padding(.horizontal, 20)

      HStack {
        TPPicker(selected: $timeSelection.selected, list: timeSelection.list).frame(width: 200, height: 42, alignment: .center)
        Spacer().frame(width: 15)

        TPButton(iconName: "baseline_edit_42") { }.frame(width: 60, height: 42, alignment: .center)

        Spacer()
      }.padding(.horizontal, 20)

      Spacer().frame(height: 5)

      HStack {
        Text("Profile:")

        Spacer()
      }.padding(.horizontal, 20)

      HStack {
        TPPicker(selected: $profileStr, list: profileList).frame(width: 200, height: 42, alignment: .center)
        Spacer().frame(width: 15)

        TPButton(iconName: "baseline_help_outline_42") { viewModel.showProfileHelp() } .frame(width: 60, height: 42, alignment: .center)

        Spacer()
      }.padding(.horizontal, 20)

      Spacer()

      VStack {
        HStack {
          Text("Start to Finish (\(trackSelection.totalDist)):")

          Spacer()
        }.padding(.horizontal, 20)

        Spacer().frame(height: 10)

        ZStack {
          Image("running_track")
          Image(trackSelection.trackOverlay)
          VStack {
            Text(trackSelection.lapCounter)
            Text(trackSelection.lapDesc1)
            Text(trackSelection.lapDesc2)
          }
        }
      }

      Spacer()

      NavigationLink(" ON  YOUR  MARKS ", value: 1).buttonStyle(ActionButtonStyle())
    }
  }
}
