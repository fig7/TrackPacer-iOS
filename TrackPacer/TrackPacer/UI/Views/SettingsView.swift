//
//  SettingsView.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 10/05/2024.
//

import SwiftUI

extension StringProtocol {
  func ranges<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Range<Index>] {
    var result: [Range<Index>] = []
    var startIndex = self.startIndex
    while startIndex < endIndex, let range = self[startIndex...].range(of: string, options: options) {
       result.append(range)
       startIndex = range.lowerBound < range.upperBound ? range.upperBound :
       index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
    }

    return result
  }
}

struct SettingsView: View {
  @EnvironmentObject var viewModel: SettingsViewModel

  var body: some View {
    VStack {
      Text("Settings").font(.largeTitle).frame(maxWidth: .infinity, alignment: .leading)
      Spacer().frame(height: 32)

      ScrollView {
        VStack(alignment:.leading, spacing: 0) {
          Divider()

          VStack(alignment:.leading, spacing: 0) {
            HStack {
              VStack(alignment: .leading, spacing: 5) {
                Text("Start delay").fontWeight(.bold)
                Text("Seconds to delay the start by").font(.caption)
                Text("(between 5.00 and 30.00)").font(.caption)
              }

              Spacer()

              HStack {
                TextField("", text: $viewModel.startDelaySS).foregroundStyle(viewModel.startDelayValid ? .black : .red).textFieldStyle(.roundedBorder).frame(width: 50)
                  .lineLimit(1).multilineTextAlignment(.trailing).keyboardType(.numberPad)

                Text(".")
                
                TextField("", text: $viewModel.startDelayHH).foregroundStyle(viewModel.startDelayValid ? .black : .red).textFieldStyle(.roundedBorder).frame(width: 50)
                  .lineLimit(1).multilineTextAlignment(.trailing).keyboardType(.numberPad)
              }
            }.padding(.horizontal, 1).padding(.vertical, 16)

            Divider()
          }
            .textFieldSelectAll()

          VStack(alignment:.leading, spacing: 0) {
            HStack {
              VStack(alignment: .leading, spacing: 5) {
                Text("Power start").fontWeight(.bold)
                Text("Power button to start").font(.caption)
                Text("Change volume to pause").font(.caption)
              }

              Spacer()

              Toggle("", isOn: $viewModel.powerStart).labelsHidden().padding(2)
            }.padding(.horizontal, 1).padding(.vertical, 16)

            Divider()
          }

          VStack(alignment:.leading, spacing: 0) {
            HStack {
              VStack(alignment: .leading, spacing: 5) {
                Text("Quick start").fontWeight(.bold)
                Text("Start is not delayed, just \"Go!\"").font(.caption)
              }

              Spacer()

              Toggle("", isOn: $viewModel.quickStart).labelsHidden().padding(2)
            }.padding(.horizontal, 1).padding(.vertical, 16)

            Divider()
          }

          VStack(alignment: .leading, spacing: 0) {
            HStack {
              VStack(alignment: .leading, spacing: 5) {
                Text("Run clockwise").fontWeight(.bold)
                Text("Run in the opposite direction").font(.caption)
              }

              Spacer()

              Toggle("", isOn: $viewModel.runClockwise).labelsHidden().padding(2)
            }.padding(.horizontal, 1).padding(.vertical, 16)

            Divider()
          }

          VStack(alignment:.leading, spacing: 0) {
            HStack {
              VStack(alignment: .leading, spacing: 5) {
                Text("Flight mode").fontWeight(.bold)
                Text("Show a reminder for flight mode").font(.caption)
              }

              Spacer()

              Toggle("", isOn: $viewModel.flightMode).labelsHidden().padding(2)
            }.padding(.horizontal, 1).padding(.vertical, 16)

            Divider()
          }

          VStack(alignment:.leading, spacing: 0) {
            HStack {
              VStack(alignment: .leading, spacing: 5) {
                Text("Reference pace").fontWeight(.bold)
                Text("Pace used with profiles").font(.caption)
                Text("(between 2:30/km and 15:00/km)").font(.caption)
              }

              Spacer()

              HStack {
                TextField("", text: $viewModel.refPaceMM).foregroundStyle(viewModel.refPaceValid ? .black : .red).textFieldStyle(.roundedBorder).frame(width: 50)
                  .lineLimit(1).multilineTextAlignment(.trailing).keyboardType(.numberPad)

                Text(":")

                TextField("", text: $viewModel.refPaceSS).foregroundStyle(viewModel.refPaceValid ? .black : .red).textFieldStyle(.roundedBorder).frame(width: 50)
                  .lineLimit(1).multilineTextAlignment(.trailing).keyboardType(.numberPad)
              }
            }.padding(.horizontal, 1).padding(.vertical, 16)

              Divider()
            }
            .textFieldSelectAll()
        }
      }
      .onChange(of: viewModel.startDelaySS) { viewModel.startDelayChanged() }
      .onChange(of: viewModel.startDelayHH) { viewModel.startDelayChanged() }
      .onChange(of: viewModel.powerStart)   { viewModel.powerStartChanged() }
      .onChange(of: viewModel.quickStart)   { viewModel.quickStartChanged() }
      .onChange(of: viewModel.runClockwise) { viewModel.runClockwiseChanged() }
      .onChange(of: viewModel.flightMode)   { viewModel.flightModeChanged() }
      .onChange(of: viewModel.refPaceMM)    { viewModel.refPaceChanged() }
      .onChange(of: viewModel.refPaceSS)    { viewModel.refPaceChanged() }
    }.padding(.horizontal, 20).scrollDismissesKeyboard(.interactively)
  }
}
