//
//  MainViewStack.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 29/05/2024.
//

import Foundation

@MainActor class MainViewStack : ObservableObject {
  @Published var list: [Int] = []

  func pushPacingView()     { list.append(1) }
  func pushCompletionView() { list.append(2) }
  func popCompletionView()  { list.removeAll() }

  func pushPastView() { list.append(3) }
  func popPastView()  { list.removeAll() }


  func pushProfileView() { list.append(4) }
  func popProfileView()  { list.removeAll() }
}
