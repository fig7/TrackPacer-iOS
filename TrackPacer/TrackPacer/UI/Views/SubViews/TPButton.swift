//
//  TPButton.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 12/05/2024.
//

import SwiftUI

struct TPButton : View {
  let iconName: String
  let buttonAction: () -> ()

  let gray1 = Color(red: 0.745, green: 0.773, blue: 0.831)
  let gray2 = Color(red: 0.918, green: 0.929, blue: 0.941)

  var body: some View {
    HStack {
      Spacer().frame(width: 10)
      RoundedRectangle(cornerRadius: 8).fill(LinearGradient(colors:[gray1, gray2], startPoint: .top, endPoint: .bottom)).strokeBorder(.black, lineWidth: 1).overlay(
        Button(action: buttonAction) { Image(iconName) }.tint(.black))
    }
  }
}
