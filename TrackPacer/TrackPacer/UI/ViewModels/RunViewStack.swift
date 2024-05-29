//
//  RunViewStack.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 29/05/2024.
//

import Foundation

class RunViewStack : ObservableObject {
  @Published var list: [Int] = []

  func pushPacingView()     { list.append(1) }
  func pushCompletionView() { list.append(2) }
  func popCompletionView()  { list.removeAll() }
}
