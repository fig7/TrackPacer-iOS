//
//  RunView.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 10/05/2024.
//

import SwiftUI

// TODO: Add app icon
// TODO: Extract sub-views
struct RunView: View {
  @ObservedObject var distanceSelection: DistanceSelection

  @State var laneStr = "1"
  var laneList = ["1", "2", "3"]

  @State var timeStr = "1:30.00"
  var timeList = ["1:30.00", "1:45.00", "2:00.00"]

  @State var profileStr = "Fixed pace"
  var profileList = ["Fixed pace"]

  var body: some View {
    VStack(spacing: 5) {
      StatusView().frame(maxWidth: .infinity, alignment: .trailing)

      HStack {
        Text("Distance:")

        Spacer()

        Text("Lane:")

        Spacer()
      }.padding(.horizontal, 20)

      HStack {
        Picker("Choose a distance", selection: $distanceSelection.selected) {
          ForEach(distanceSelection.list, id: \.self) {
            Text($0)
          }
        }.frame(width: 150, alignment: .center)

        Spacer()

        Picker("Choose a lane", selection: $laneStr) {
          ForEach(laneList, id: \.self) {
            Text($0)
          }
        }.frame(width: 80, alignment: .center)

        Spacer()
      }.padding(.horizontal, 20)

      Spacer().frame(height: 5)

      HStack {
        Text("Time:")

        Spacer()
      }.padding(.horizontal, 20)

      HStack {
        Picker("Choose a time", selection: $timeStr) {
          ForEach(timeList, id: \.self) {
            Text($0)
          }
        }.frame(width: 150, alignment: .center)

        Spacer()

        Button("Edit") {
        }.frame(width: 80, alignment: .center)

        Spacer()
      }.padding(.horizontal, 20)

      Spacer().frame(height: 5)

      HStack {
        Text("Profile:")

        Spacer()
      }.padding(.horizontal, 20)

      HStack {
        Picker("Choose a profile", selection: $profileStr) {
          ForEach(profileList, id: \.self) {
            Text($0)
          }
        }.frame(width: 150, alignment: .center)

        Spacer()

        Button("?") {
        }.frame(width: 80, alignment: .center)

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

      Button("ON YOUR MARKS") { }

      Spacer().frame(height: 20)

    }
  }
}
