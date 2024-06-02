//
//  Weighted.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 01/06/2024.
//

// From https://gist.github.com/globulus
// Full recipe at https://swiftuirecipes.com/blog/weighted-layout-hstack-and-vstack-in-swiftui

import SwiftUI

class WeightedProxy {
  let kind: Kind
  var geo: GeometryProxy? = nil
  private(set) var totalWeight: CGFloat = 0
  
  init(kind: Kind) {
    self.kind = kind
  }

  func register(with weight: CGFloat) {
    totalWeight += weight
  }

  func dimensionForRelative(weight: CGFloat) -> CGFloat {
    guard let geo = geo, totalWeight > 0 else { return 0 }

    let dimension = (kind == .vertical) ? geo.size.height : geo.size.width
    return dimension * weight / totalWeight
  }

  enum Kind { case vertical, horizontal }
}

struct Weighted: ViewModifier {
  private let weight: CGFloat
  private let proxy: WeightedProxy

  init(_ weight: CGFloat, proxy: WeightedProxy) {
    self.weight = weight
    self.proxy  = proxy

    proxy.register(with: weight)
  }

  @ViewBuilder func body(content: Content) -> some View {
    if proxy.kind == .vertical {
      content.frame(height: proxy.dimensionForRelative(weight: weight))
    } else {
      content.frame(width: proxy.dimensionForRelative(weight: weight))
    }
  }
}

extension View {
  func weighted(_ weight: CGFloat, _ proxy: WeightedProxy) -> some View {
    self.modifier(Weighted(weight, proxy: proxy))
  }
}

struct WeightedHStack<Content>: View where Content : View {
  private let proxy = WeightedProxy(kind: .horizontal)

  @State private var initialized = false
  @ViewBuilder let content: (WeightedProxy) -> Content

  var body: some View {
    GeometryReader { geo in
      HStack(spacing: 0) {
        if initialized {
          content(proxy)
        } else {
          Color.clear.onAppear {
            proxy.geo = geo
            initialized.toggle()
          }
        }
      }
    }
  }
}

struct WeightedVStack<Content>: View where Content : View {
  private let proxy = WeightedProxy(kind: .vertical)
  @State private var initialized = false
  @ViewBuilder let content: (WeightedProxy) -> Content

  var body: some View {
    GeometryReader { geo in
      VStack(spacing: 0) {
        if initialized {
          content(proxy)
        } else {
          Color.clear.onAppear {
            proxy.geo = geo
            initialized.toggle()
          }
        }
      }
    }
  }
}
