//
//  Dialog.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 27/05/2024.
//

import SwiftUI

struct CloseButton: View {
  let closeAction: () -> ()

  var body: some View {
    Button(action: closeAction) { Image("baseline_close_48") }
  }
}

struct ErrorDialog: View {
  @EnvironmentObject var dialogContent: DialogContent

  var body: some View {
    Text(dialogContent.dialogTitle).bold().frame(maxWidth: .infinity, alignment: .leading)
    Spacer().frame(height: 20)

    Text(dialogContent.dialogText)
  }
}

struct InfoDialog: View {
  @EnvironmentObject var dialogContent: DialogContent
  @EnvironmentObject var dialogResult: DialogResult
  let closeAction: () -> ()

  init(_ closeAction: @escaping () -> ()) {
    self.closeAction   = closeAction
  }

  var body: some View {
    Text(dialogContent.dialogTitle).bold().frame(maxWidth: .infinity, alignment: .leading)
    Spacer().frame(height: 20)

    Text(dialogContent.dialogText)
    Spacer()

    Button("  OK   ", action: { dialogResult.action = .UserContinue; closeAction() }).frame(maxWidth: .infinity, alignment: .trailing)
  }
}

struct QuestionDialog: View {
  @EnvironmentObject var dialogContent: DialogContent
  @EnvironmentObject var dialogResult: DialogResult
  let closeAction: () -> ()

  init(_ closeAction: @escaping () -> ()) {
    self.closeAction = closeAction
  }

  var body: some View {
    Text(dialogContent.dialogTitle).bold().frame(maxWidth: .infinity, alignment: .leading)
    Spacer().frame(height: 20)

    Text(dialogContent.dialogText)
    Spacer()

    HStack {
      Button("  CANCEL   ", action: closeAction)
      Button("  \(dialogContent.dialogAction)   ", action: { dialogResult.action = .UserContinue; closeAction() })
    }.frame(maxWidth: .infinity, alignment: .trailing)
  }
}

struct EditTimeDialog: View {
  @EnvironmentObject var timeEdit: TimeEdit
  @EnvironmentObject var timeSelection: TimeSelection
  let closeAction: () -> ()

  init(_ closeAction: @escaping () -> ()) {
    self.closeAction = closeAction
  }

  var body: some View {
    let gray1 = Color(red: 0.745, green: 0.773, blue: 0.831)
    let gray2 = Color(red: 0.918, green: 0.929, blue: 0.941)
    
    HStack(alignment: .top) {
      Text("Edit " + timeSelection.selected).font(.title).monospacedDigit().frame(maxWidth: .infinity, alignment: .leading)
      CloseButton(closeAction: closeAction)
    }
    Spacer().frame(height: 5)

    RoundedRectangle(cornerRadius: 8).fill(LinearGradient(colors:[gray1, gray2], startPoint: .top, endPoint: .bottom)).strokeBorder(.black, lineWidth: 1).overlay(
      VStack {
        Spacer().frame(height: 8)

        HStack {
          Text("Minutes").font(.caption).frame(maxWidth: .infinity)
          Text("Seconds").font(.caption).frame(maxWidth: .infinity)
          Text("Hundredths").font(.caption).frame(maxWidth: .infinity)
        }

        HStack {
          Picker("Minutes", selection: $timeEdit.mins) {
            ForEach(0..<100, id: \.self) { number in
              Text("\(number)")
            }
          }.pickerStyle(.wheel)

          Text(":")

          Picker("Seconds", selection: $timeEdit.secs) {
            ForEach(0..<60, id: \.self) { number in
              Text(String(format: "%02d", number))
            }
          }.pickerStyle(.wheel)

          Text(".")

          Picker("Hundredths", selection: $timeEdit.hths) {
            ForEach(0..<100, id: \.self) { number in
              Text(String(format: "%02d", number))
            }
          }.pickerStyle(.wheel)
        }
      })

    Spacer().frame(height: 8)

    HStack {
      Button(" DELETE ") {
        timeEdit.editAction = .UserDelete
        closeAction()
      }.buttonStyle(SmallActionButtonStyle(disabledCol: !timeEdit.deleteOK)).disabled(!timeEdit.deleteOK).frame(maxWidth: .infinity, alignment: .leading)
      Button(" ADD \(timeEdit.timeStr) ") {
        timeEdit.editAction = .UserAdd
        closeAction()
      }.buttonStyle(SmallActionButtonStyle(disabledCol: !timeEdit.editOK)).disabled(!timeEdit.editOK).frame(maxWidth: .infinity, alignment: .trailing)
    }

    Spacer().frame(height: 10)
    Button(" SET TO \(timeEdit.timeStr) ") {
      timeEdit.editAction = .UserSet
      closeAction()
    }.buttonStyle(SmallActionButtonStyle(disabledCol: !timeEdit.editOK)).disabled(!timeEdit.editOK).frame(maxWidth: .infinity, alignment: .trailing)
  }
}

struct FMRDialog: View {
  @EnvironmentObject var viewModel: MainViewModel
  let closeAction: () -> ()

  init(_ closeAction: @escaping () -> ()) {
    self.closeAction = closeAction
  }

  var body: some View {
    HStack(alignment: .top) {
      Text("Flight mode?").font(.title).monospacedDigit().frame(maxWidth: .infinity, alignment: .leading)
      CloseButton(closeAction: closeAction)
    }
    Spacer().frame(height: 5)

    Text("Do you want to run without it?")
    Spacer().frame(height: 2)
    Text("Or use network settings to turn it on?")

    Spacer()

    HStack (spacing: 15){
      Spacer()

      Text("Disable reminder")
      Toggle("", isOn: $viewModel.disableReminder).labelsHidden().padding(2).padding(.trailing, 10)
    }

    Spacer().frame(height: 20)

    HStack {
      Button("  GO TO SETTINGS   ", action: { closeAction(); Task { @MainActor in viewModel.updateReminder(); viewModel.openSettings() } }).buttonStyle(SmallActionButtonStyle(disabledCol: false))
      Spacer()

      Button("  RUN   ", action: { closeAction(); Task { @MainActor in viewModel.updateReminder(); viewModel.launchPacing() } }).buttonStyle(SmallActionButtonStyle(disabledCol: false))
    }.frame(maxWidth: .infinity, alignment: .trailing)
  }
}

struct Dialog: View {
  @EnvironmentObject var viewModel: MainViewModel
  @EnvironmentObject var dialogContent: DialogContent
  @EnvironmentObject var dialogResult: DialogResult
  @EnvironmentObject var dialogVisibility: DialogVisibility

  var body: some View {
    let dialogOpacity = (dialogVisibility.visible) ? 1.0 : 0.0
    let dialogScale   = (dialogVisibility.visible) ? 1.0 : 0.0

    ZStack {
      Color(.black).frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity).ignoresSafeArea().opacity(0.56)

      VStack(spacing: 0) {
        VStack(alignment: .leading, spacing: 0) {
          switch(dialogContent.dialogType) {
          case .None:
            EmptyView()

          case .Error:
            ErrorDialog()

          case .Info:
            InfoDialog() { viewModel.dismissDialog() }

          case .Question:
            QuestionDialog() { viewModel.dismissDialog() }

          case .Edit:
            EditTimeDialog() { viewModel.dismissDialog() }

          case .FMR:
            FMRDialog { viewModel.dismissDialog() }
          }
        }
        .padding(.all, dialogContent.dialogPadding)
        .frame(width: dialogContent.dialogWidth, height: dialogContent.dialogHeight, alignment: .topLeading).background(.white).scaleEffect(CGSize(width: dialogScale, height: dialogScale))

        Spacer().frame(height: 20)
      }
    }.opacity(dialogOpacity).animation(.easeIn, value: dialogVisibility.visible)
  }
}
