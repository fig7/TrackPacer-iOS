//
//  View.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 12/06/2024.
//

import SwiftUI

private struct SelectAllTextOnBeginEditingModifier: ViewModifier {
  func body(content: Content) -> some View {
    content
      .onReceive(NotificationCenter.default.publisher(for: UITextField.textDidBeginEditingNotification)) { _ in
        DispatchQueue.main.async { UIApplication.shared.sendAction(#selector(UIResponder.selectAll(_:)), to: nil, from: nil, for: nil) }
      }
  }
}

extension View {
  func textFieldSelectAll() -> some View {
    modifier(SelectAllTextOnBeginEditingModifier())
  }
}
