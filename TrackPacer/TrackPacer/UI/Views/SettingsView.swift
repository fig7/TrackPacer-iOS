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
  @FocusState var startDelayFocus

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

              TextField("", text: $viewModel.startDelay).lineLimit(1).multilineTextAlignment(.center).keyboardType(.decimalPad)
                .foregroundColor(viewModel.startDelayValid ? .primary : .red).focused($startDelayFocus)
                .padding(12).frame(width: 75).border(startDelayFocus ? .blue : viewModel.startDelayValid ? .secondary : .red)
                .onChange(of: viewModel.startDelay) { viewModel.startDelayChanged() }

              // This doesn't work. Adding an onSubmit callback somehow breaks the onChange()
              // IDK, in any case it doesn't really matter.
              // .onSubmit { viewModel.onSubmit() }
            }.padding(.horizontal, 1).padding(.vertical, 16)

            Divider()
          }

          VStack(alignment:.leading, spacing: 0) {
            HStack {
              VStack(alignment: .leading, spacing: 5) {
                Text("Power start").fontWeight(.bold)
                Text("Power button to start").font(.caption)
                Text("Change volume to pause").font(.caption)
              }

              Spacer()

              Toggle("", isOn: $viewModel.powerStart).padding(2).labelsHidden()
                .onChange(of: viewModel.powerStart) { viewModel.powerStartChanged() }
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

              Toggle("", isOn: $viewModel.quickStart).padding(2).labelsHidden()
                .onChange(of: viewModel.quickStart) { viewModel.quickStartChanged() }
            }.padding(.horizontal, 1).padding(.vertical, 16)

            Divider()
          }

          VStack(alignment:.leading, spacing: 0) {
            HStack {
              VStack(alignment: .leading, spacing: 5) {
                Text("Alternate start").fontWeight(.bold)
                Text("Swap start and finish for 1, 3, and 5km").font(.caption)
              }

              Spacer()

              Toggle("", isOn: $viewModel.alternateStart).padding(2).labelsHidden()
                .onChange(of: viewModel.alternateStart) { viewModel.alternateStartChanged() }
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

              Toggle("", isOn: $viewModel.flightMode).padding(2).labelsHidden()
                .onChange(of: viewModel.flightMode) { viewModel.flightModeChanged() }
            }.padding(.horizontal, 1).padding(.vertical, 16)

            Divider()
          }
        }
      }
    }.padding(.horizontal, 20).scrollDismissesKeyboard(.interactively)
  }
}
