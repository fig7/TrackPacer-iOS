//
//  Dialog.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 27/05/2024.
//

import SwiftUI

struct Dialog: View {
  let viewModel: MainViewModel
  @ObservedObject var dialogContent: DialogContent
  @ObservedObject var dialogVisibility: DialogVisibility

  init(_ viewModel: MainViewModel) {
    self.viewModel = viewModel

    dialogContent    = viewModel.dialogContent
    dialogVisibility = viewModel.dialogVisibility
  }

  var body: some View {
    ZStack {
      Color(.black).frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity).ignoresSafeArea().opacity(0.56)

      VStack {
        switch(dialogContent.dialogType) {
        case .Info:
          VStack {
            Spacer()

            Text(dialogContent.dialogTitle).bold().padding(.bottom, 10).frame(maxWidth: .infinity, alignment: .leading)
            Text(dialogContent.dialogText)

            Spacer()

            HStack {
              Button("  OK   ") { viewModel.dismissDialog() }.frame(maxWidth: .infinity, alignment: .trailing)
            }

          }.padding(.bottom, 20).padding(.horizontal, 20).frame(width: dialogContent.dialogWidth, height: dialogContent.dialogHeight).background(.white)
        }

        Spacer().frame(height: 20)
      }
    }.opacity(dialogVisibility.visible ? 1 : 0).animation(.easeIn, value: dialogVisibility.visible)
  }
}
