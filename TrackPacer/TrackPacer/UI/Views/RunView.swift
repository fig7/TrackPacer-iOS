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

  @State var laneStr = "1"
  var laneList = ["1", "2", "3"]

  @State var timeStr = "1:30.00"
  var timeList = ["1:30.00", "1:45.00", "2:00.00"]

  @State var profileStr = "Fixed pace"
  var profileList = ["Fixed pace"]

  init(viewModel: RunViewModel) {
    self.viewModel = viewModel
    
    self.distanceSelection = viewModel.distanceSelection
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

        TPPicker(selected: $laneStr, list: laneList).frame(width: 80, height: 42, alignment: .center)

        Spacer()
      }.padding(.horizontal, 20)

      Spacer().frame(height: 5)

      HStack {
        Text("Time:")

        Spacer()
      }.padding(.horizontal, 20)

      HStack {
        TPPicker(selected: $timeStr, list: timeList).frame(width: 200, height: 42, alignment: .center)
        Spacer().frame(width: 15)

        TPButton(iconName: "baseline_edit_42").frame(width: 60, height: 42, alignment: .center)

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

        TPButton(iconName: "baseline_help_outline_42").frame(width: 60, height: 42, alignment: .center)

        Spacer()
      }.padding(.horizontal, 20)

      Spacer()

      VStack {
        HStack {
          Text("Start to Finish (400m):")

          Spacer()
        }.padding(.horizontal, 20)

        Spacer().frame(height: 10)

        ZStack {
          Image("running_track")
          Image("rt_400_l1")
          VStack {
            Text("1 lap")
            Text("")
            Text("")
          }
        }
      }

      Spacer()

      NavigationLink(" ON  YOUR  MARKS ", value: 1).buttonStyle(ActionButtonStyle())
    }
  }
}
