//
//  AudioView.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 10/05/2024.
//

import SwiftUI

struct AudioView: View {
    var body: some View {
      VStack {
        Text("Clips & Audio").font(.largeTitle).frame(maxWidth: .infinity, alignment: .leading)
        Spacer().frame(height: 32)

        Text("The audio page allows you to record different prompts or replace my voice with text-to-speech. " +
             "You could also make the audio prompts tell you how far you have run, or how far you have to go, or both.\n\n" +
             "Would you like to have a clip that tells you to sprint near the end? Would you like to hear some motivational words as you run? You can.\n\n" +
             "Clips & Audio will only be available in the pro version of TrackPacer, which is coming soon...")

        Spacer()
      }.padding(.horizontal, 20)
    }
}
