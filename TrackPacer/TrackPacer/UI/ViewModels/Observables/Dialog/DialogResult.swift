//
//  DialogResult.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 02/06/2024.
//

import Foundation

enum DialogResponse { case UserCancel, UserContinue }

@MainActor class DialogResult : ObservableObject {
  @Published var action: DialogResponse = .UserCancel
}
