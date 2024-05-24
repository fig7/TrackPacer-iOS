//
//  ServiceConnection.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 23/05/2024.
//

import Foundation

@MainActor protocol ServiceConnection : AnyObject {
  func onServiceConnected()
  func onServiceDisconnected()
}
