//
//  PacingProgressStyle.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 13/05/2024.
//

import SwiftUI

struct PacingProgressStyle: ProgressViewStyle {
  let progressColor = Color(red: 0.953, green: 0.780, blue: 0.0)

  func makeBody(configuration: Configuration) -> some View {
    ProgressView(configuration)
      .accentColor(progressColor)
      .frame(height: 18.0)
      .scaleEffect(x: 1, y: 5, anchor: .center)
      .clipShape(RoundedRectangle(cornerRadius: 4))
      .padding(.leading, 10)
  }
}
