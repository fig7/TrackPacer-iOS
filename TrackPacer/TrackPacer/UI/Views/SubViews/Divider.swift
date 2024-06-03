//
//  Divider.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 03/06/2024.
//

import SwiftUI

struct Divider: View {
  var body: some View {
    let dividerColor: Color = .primary
    Color(dividerColor).frame(height: 1).frame(maxWidth: .infinity)
  }
}

