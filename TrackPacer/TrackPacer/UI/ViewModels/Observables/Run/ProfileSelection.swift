//
//  ProfileSelection.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 08/06/2024.
//

import Foundation

@MainActor class ProfileSelection: ObservableObject {
  var selectedCallback: (_ newSelected: String) -> Void = { _ in }

  @Published var selected = ""
  { didSet { selectedCallback(selected) } }

  @Published var list: [String] = [""]
  @Published var profilesEnabled = true
}
