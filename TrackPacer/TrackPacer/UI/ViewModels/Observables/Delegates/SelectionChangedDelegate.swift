//
//  SelectionChangedDelegate.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 25/05/2024.
//

import Foundation

@MainActor protocol SelectedChangedDelegate : AnyObject {
  func selectedChanged(_ newSelected: String)
}
