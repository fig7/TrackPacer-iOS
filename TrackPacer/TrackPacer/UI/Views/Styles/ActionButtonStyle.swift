//
//  ActionButtonStyle.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 12/05/2024.
//

import SwiftUI

struct SmallActionButtonStyle : ButtonStyle {
  let disabledCol: Bool
  let foregroundCol: Color
  let backgroundCol: Color

  init() {
    self.init(disabledCol: false)
  }

  init(disabledCol: Bool) {
    self.disabledCol = disabledCol
    foregroundCol = disabledCol ? .gray : .white
    backgroundCol = disabledCol ? Color(red: 0.839, green: 0.843, blue: 0.843) : Color(red: 0.427, green: 0.0, blue: 0.965)
  }

  func makeBody(configuration: Self.Configuration) -> some View {
    configuration.label.font(.system(size: 16, weight: .bold, design: .default)).monospacedDigit().lineLimit(1).foregroundStyle(foregroundCol)
      .padding(.all, 10).background(backgroundCol).cornerRadius(4)
      .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
      .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
  }
}

struct ActionButtonStyle : ButtonStyle {
  let disabledCol: Bool
  let foregroundCol: Color
  let backgroundCol: Color

  init() {
    self.init(disabledCol: false)
  }

  init(disabledCol: Bool) {
    self.disabledCol = disabledCol
    foregroundCol = disabledCol ? .gray : .white
    backgroundCol = disabledCol ? Color(red: 0.839, green: 0.843, blue: 0.843) : Color(red: 0.427, green: 0.0, blue: 0.965)
  }

  func makeBody(configuration: Self.Configuration) -> some View {
    configuration.label.font(.system(size: 24, weight: .bold, design: .default)).foregroundStyle(foregroundCol)
      .padding().background(backgroundCol).cornerRadius(4)
      .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
      .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
  }
}

struct ActionButtonStyleMax : ButtonStyle {
  let disabledCol: Bool
  let foregroundCol: Color
  let backgroundCol: Color

  init() {
    self.init(disabledCol: false)
  }
  
  init(disabledCol: Bool) {
    self.disabledCol = disabledCol
    foregroundCol = disabledCol ? .gray : .white
    backgroundCol = disabledCol ? Color(red: 0.839, green: 0.843, blue: 0.843) : Color(red: 0.427, green: 0.0, blue: 0.965)
  }

  func makeBody(configuration: Self.Configuration) -> some View {
    configuration.label.font(.system(size: 24, weight: .bold, design: .default)).foregroundStyle(foregroundCol)
      .padding().frame(maxWidth: .infinity).background(backgroundCol).cornerRadius(4)
      .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
      .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
  }
}
