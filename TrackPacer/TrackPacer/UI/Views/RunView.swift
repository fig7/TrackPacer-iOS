//
//  RunView.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 10/05/2024.
//

import SwiftUI

struct RunView: View {
  @EnvironmentObject var viewModel: RunViewModel
  
  @EnvironmentObject var distanceSelection: DistanceSelection
  @EnvironmentObject var startSelection: StartSelection
  @EnvironmentObject var laneSelection: LaneSelection

  @EnvironmentObject var timeSelection: TimeSelection
  @EnvironmentObject var paceSelection: PaceSelection

  @EnvironmentObject var profileSelection: ProfileSelection
  @EnvironmentObject var intervalSelection: IntervalSelection

  @EnvironmentObject var trackSelection: TrackSelection

  var body: some View {
    let trackRun = (trackSelection.trackOverlay != "")

    VStack(spacing: 5) {
      HStack {
        let distanceString = (trackRun) ? "Distance (lane 1):" : "Distance:"
        Text(distanceString).frame(width: 150, alignment: .leading)
        Text("Start:").frame(width: 105, alignment: .leading)
        if(trackRun) { Text("Lane:") }

        Spacer()
      }.padding(.horizontal, 20)

      HStack {
        TPPicker(selected: $distanceSelection.selectedPadded, list: distanceSelection.list)
          .frame(width: 165, height: 42, alignment: .center)
        TPPicker(selected: $startSelection.selected, list: startSelection.list)
          .frame(width: 110, height: 42, alignment: .center)

        if(trackRun) {
          TPPicker(selected: $laneSelection.selected, list: laneSelection.list)
            .frame(width: 80, height: 42, alignment: .center)
        }

        Spacer()
      }.padding(.horizontal, 20)

      Spacer().frame(height: 5)

      HStack {
        Text("Unit:")
        Spacer().frame(width: 80)

        switch paceSelection.selected {
        case "Pace":
          Text("Time (per km):").frame(width: 160, alignment: .leading)

        case "Goal":
          Text("Time (for \(distanceSelection.selected)):").frame(width: 160, alignment: .leading)

        case "Actual":
          Text("Time (for \(distanceSelection.runDist)):").frame(width: 160, alignment: .leading)

        default:
          Text("Error: Unknown unit").frame(width: 160, alignment: .leading)
        }

        Spacer()
      }.padding(.horizontal, 20)

      HStack {
        TPPicker(selected: $paceSelection.selected, list: paceSelection.list).frame(width: 110, height: 42, alignment: .center)
        Spacer().frame(width: 10)

        TPPicker(selected: $timeSelection.selected, list: timeSelection.list).frame(width: 165, height: 42, alignment: .center)

        TPButton(iconName: "baseline_edit_42") {
          viewModel.editTime()
        }.frame(width: 60, height: 42, alignment: .center)

        Spacer()
      }.padding(.horizontal, 20)

      Spacer().frame(height: 5)

      HStack {
        Text("Interval:")
        Spacer().frame(width: 60)

        Text("Profile:").frame(width: 160, alignment: .leading)
        Spacer()
      }.padding(.horizontal, 20)

      HStack {
        TPPicker(selected: $intervalSelection.selected, list: intervalSelection.list).frame(width: 110, height: 42, alignment: .center)
        Spacer().frame(width: 10)

        TPPicker(selected: $profileSelection.selected, list: profileSelection.list).frame(width: 165, height: 42, alignment: .center)

        if(profileSelection.profilesEnabled) {
          TPButton(iconName: "baseline_edit_42") {
            viewModel.editProfile()
          }.frame(width: 60, height: 42, alignment: .center)
        } else {
          TPButton(iconName: "baseline_help_outline_42") {
            viewModel.showProfileHelp()
          }.frame(width: 60, height: 42, alignment: .center)
        }
        Spacer()
      }.padding(.horizontal, 20)

      if(trackRun) {
        Spacer()

        VStack {
          HStack {
            Text("Start to Finish (\(trackSelection.runDist)):")

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
      }
      else {
        Spacer().frame(height: 40)
        Text(trackSelection.lapCounter)
          .font(.title)

        Spacer().frame(height: 5)
        Text(trackSelection.lapDesc1)
      }

      Spacer()

      Button(" ON  YOUR  MARKS ") {
        viewModel.onYourMarks()
      }.buttonStyle(ActionButtonStyle())
    }
  }
}
