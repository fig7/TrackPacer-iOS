//
//  DialogContent.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 27/05/2024.
//

import Foundation

enum DialogType { case Info }

@MainActor class DialogContent : ObservableObject {
  @Published var dialogType: DialogType = .Info

  @Published var dialogTitle: String = ""
  @Published var dialogText: String  = ""

  @Published var dialogWidth: CGFloat  = 0.0
  @Published var dialogHeight: CGFloat = 0.0
}
