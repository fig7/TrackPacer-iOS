//
//  ActionButtonStyle.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 12/05/2024.
//

import SwiftUI

struct ActionButtonStyle : ButtonStyle {
  let disabled: Bool
  let foregroundCol: Color
  let backgroundCol: Color

  init() {
    self.init(disabled: false)
  }

  init(disabled: Bool) {
    self.disabled = disabled
    foregroundCol = disabled ? .gray : .white
    backgroundCol = disabled ? Color(red: 0.839, green: 0.843, blue: 0.843) : Color(red: 0.427, green: 0.0, blue: 0.965)
  }

  func makeBody(configuration: Self.Configuration) -> some View {
    configuration.label.font(.system(size: 24, weight: .bold, design: .default)).foregroundStyle(foregroundCol)
      .padding().background(backgroundCol).cornerRadius(4)
      .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
      .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
  }
}

struct ActionButtonStyleMax : ButtonStyle {
  let disabled: Bool
  let foregroundCol: Color
  let backgroundCol: Color

  init(disabled: Bool) {
    self.disabled = disabled
    foregroundCol = disabled ? .gray : .white
    backgroundCol = disabled ? Color(red: 0.839, green: 0.843, blue: 0.843) : Color(red: 0.427, green: 0.0, blue: 0.965)
  }

  func makeBody(configuration: Self.Configuration) -> some View {
    configuration.label.font(.system(size: 24, weight: .bold, design: .default)).foregroundStyle(foregroundCol)
      .padding().frame(maxWidth: .infinity).background(backgroundCol).cornerRadius(4)
      .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
      .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
  }
}
