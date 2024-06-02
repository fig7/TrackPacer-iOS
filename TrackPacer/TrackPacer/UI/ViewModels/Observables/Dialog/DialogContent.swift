//
//  DialogContent.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 27/05/2024.
//

import Foundation

enum DialogType { case None, Error, Info, Question, Edit }

@MainActor class DialogContent : ObservableObject {
  @Published var dialogType: DialogType = .None

  @Published var dialogTitle: String   = ""
  @Published var dialogText: String    = ""
  @Published var dialogAction: String  = ""

  @Published var dialogWidth: CGFloat   = 0.0
  @Published var dialogHeight: CGFloat  = 0.0
  @Published var dialogPadding: CGFloat = 0.0
}
