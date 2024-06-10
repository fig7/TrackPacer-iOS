//
//  ProfileView.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 09/06/2024.
//

import SwiftUI

let lineDef: (color: Color, width: CGFloat, extent: CGFloat) = (.blue, 18.0, 9.0)
let axisDef: (color: Color, width: CGFloat, extent: CGFloat) = (.black, 3.0, 1.5)

let strokeGrad = LinearGradient(colors: [.blue, .green, .red], startPoint:.bottom, endPoint: .top)
let strokeDef  = StrokeStyle(lineWidth: lineDef.width, lineCap: .round, lineJoin: .round)


let rampWidth: CGFloat = 20.0
let flatWidth: CGFloat = 150.0

let sectionWidth  = rampWidth + flatWidth
let sectionWidth2 = sectionWidth / 2.0

let sectionHeight  = 340.0
let sectionHeight2 = sectionHeight / 2.0

func clamped(_ a: CGFloat, _ b: ClosedRange<CGFloat>) -> CGFloat { min(max(a, b.lowerBound), b.upperBound) }

struct LineH: Shape {
  var y = 0.0

  func path(in rect: CGRect) -> Path {
    let minY = rect.minY
    let maxY = rect.maxY

    var path = Path()
    path.move(to: CGPoint(x: rect.minX, y: clamped(rect.minY + y, minY...maxY)))
    path.addLine(to: CGPoint(x: rect.maxX, y: clamped(rect.minY + y, minY...maxY)))
    return path
  }
}

struct LineV: Shape {
  var x = 0.0

  func path(in rect: CGRect) -> Path {
    let minX = rect.minX
    let maxX = rect.maxX

    var path = Path()
    path.move(to: CGPoint(x: clamped(rect.minX + x, minX...maxX), y: rect.minY))
    path.addLine(to: CGPoint(x: clamped(rect.minX + x, minX...maxX), y: rect.maxY))
    return path
  }
}

struct LineD: Shape {
  var y1 = 0.0
  var y2 = 0.0
    
  func path(in rect: CGRect) -> Path {
    let minY = rect.minY
    let maxY = rect.maxY

    var path = Path()
    path.move(to: CGPoint(x: rect.minX, y: clamped(rect.minY + y1, minY...maxY)))
    path.addLine(to: CGPoint(x: rect.maxX, y: clamped(rect.minY + y2, minY...maxY)))
    return path
  }
}

struct XAxis: View {
  var body: some View {
    VStack(alignment:.leading, spacing: 0) {
      LineH(y: axisDef.extent).stroke(axisDef.color, lineWidth: axisDef.width).frame(width: 8.0*sectionWidth + axisDef.width, height: axisDef.width)

      HStack(alignment:.top, spacing: 0) {
        LineV(x: axisDef.extent).stroke(axisDef.color, lineWidth: axisDef.width).frame(width: axisDef.width, height: axisDef.width)
        Spacer().frame(width: sectionWidth-axisDef.width)
        LineV(x: axisDef.extent).stroke(axisDef.color, lineWidth: axisDef.width).frame(width: axisDef.width, height: axisDef.width)
        Spacer().frame(width: sectionWidth-axisDef.width)
        LineV(x: axisDef.extent).stroke(axisDef.color, lineWidth: axisDef.width).frame(width: axisDef.width, height: axisDef.width)
        Spacer().frame(width: sectionWidth-axisDef.width)
        LineV(x: axisDef.extent).stroke(axisDef.color, lineWidth: axisDef.width).frame(width: axisDef.width, height: axisDef.width)
        Spacer().frame(width: sectionWidth-axisDef.width)
        LineV(x: axisDef.extent).stroke(axisDef.color, lineWidth: axisDef.width).frame(width: axisDef.width, height: axisDef.width)
        Spacer().frame(width: sectionWidth-axisDef.width)
        LineV(x: axisDef.extent).stroke(axisDef.color, lineWidth: axisDef.width).frame(width: axisDef.width, height: axisDef.width)
        Spacer().frame(width: sectionWidth-axisDef.width)
        LineV(x: axisDef.extent).stroke(axisDef.color, lineWidth: axisDef.width).frame(width: axisDef.width, height: axisDef.width)
        Spacer().frame(width: sectionWidth-axisDef.width)
        LineV(x: axisDef.extent).stroke(axisDef.color, lineWidth: axisDef.width).frame(width: axisDef.width, height: axisDef.width)
        Spacer().frame(width: sectionWidth-axisDef.width)
        LineV(x: axisDef.extent).stroke(axisDef.color, lineWidth: axisDef.width).frame(width: axisDef.width, height: axisDef.width)
      }
    }
  }
}

struct YAxis: View {
  var body: some View {
    HStack(alignment:.top, spacing: 0) {
      VStack(alignment:.leading, spacing: 0) {
        LineH(y: axisDef.extent).stroke(axisDef.color, lineWidth: axisDef.width).frame(width: axisDef.width, height: axisDef.width)
        Spacer().frame(height: sectionHeight2-axisDef.width)
        LineH(y: axisDef.extent).stroke(axisDef.color, lineWidth: axisDef.width).frame(width: axisDef.width, height: axisDef.width)
        Spacer().frame(height: sectionHeight2-axisDef.width)
        LineH(y: axisDef.extent).stroke(axisDef.color, lineWidth: axisDef.width).frame(width: axisDef.width, height: axisDef.width)
      }

      LineV(x: axisDef.extent).stroke(.black, lineWidth: axisDef.width).frame(width: axisDef.width, height: sectionHeight+axisDef.width)
    }
  }
}

struct ProfileView: View {
  @EnvironmentObject var viewModel: ProfileViewModel

  @State var profileName = "Fixed pace"
  @State private var offset: CGFloat  = sectionHeight2
  @State private var offset2: CGFloat = sectionHeight2
  @State private var offset3: CGFloat = sectionHeight2
  @State private var offset4: CGFloat = sectionHeight2
  @State private var offset5: CGFloat = sectionHeight2
  @State private var offset6: CGFloat = sectionHeight2
  @State private var offset7: CGFloat = sectionHeight2
  @State private var offset8: CGFloat = sectionHeight2

  var body: some View {
    VStack(alignment: .leading, spacing: 5) {
      ScrollView(.horizontal) {
        HStack(alignment: .top, spacing: 0) {
          VStack(alignment: .leading) {
            Text("150%")
            Spacer()
            Text("100%")
            Spacer()
            Text("20%")
          }.frame(height: sectionHeight + 20)

          VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .bottomLeading){
              XAxis().padding(.leading, 3.0)
              YAxis().padding(.bottom, 3.0)

              HStack(alignment: .top, spacing: 0) {
                LineD(y1: sectionHeight, y2: offset).stroke(strokeGrad, style: strokeDef).frame(width: rampWidth, height: sectionHeight)
                LineH(y: offset).stroke(strokeGrad, style: strokeDef).frame(width: flatWidth, height: sectionHeight).gesture(DragGesture().onChanged { gesture in offset = gesture.location.y})

                LineD(y1: offset, y2: offset2).stroke(strokeGrad, style: strokeDef).frame(width: rampWidth, height: sectionHeight)
                LineH(y: offset2).stroke(strokeGrad, style: strokeDef).frame(width: flatWidth, height: sectionHeight).gesture(DragGesture().onChanged { gesture in offset2 = gesture.location.y})

                LineD(y1: offset2, y2: offset3).stroke(strokeGrad, style: strokeDef).frame(width: rampWidth, height: sectionHeight)
                LineH(y: offset3).stroke(strokeGrad, style: strokeDef).frame(width: flatWidth, height: sectionHeight).gesture(DragGesture().onChanged { gesture in offset3 = gesture.location.y})

                LineD(y1: offset3, y2: offset4).stroke(strokeGrad, style: strokeDef).frame(width: rampWidth, height: sectionHeight)
                LineH(y: offset4).stroke(strokeGrad, style: strokeDef).frame(width: flatWidth, height: sectionHeight).gesture(DragGesture().onChanged { gesture in offset4 = gesture.location.y})

                LineD(y1: offset4, y2: offset5).stroke(strokeGrad, style: strokeDef).frame(width: rampWidth, height: sectionHeight)
                LineH(y: offset5).stroke(strokeGrad, style: strokeDef).frame(width: flatWidth, height: sectionHeight).gesture(DragGesture().onChanged { gesture in offset5 = gesture.location.y})

                LineD(y1: offset5, y2: offset6).stroke(strokeGrad, style: strokeDef).frame(width: rampWidth, height: sectionHeight)
                LineH(y: offset6).stroke(strokeGrad, style: strokeDef).frame(width: flatWidth, height: sectionHeight).gesture(DragGesture().onChanged { gesture in offset6 = gesture.location.y})

                LineD(y1: offset6, y2: offset7).stroke(strokeGrad, style: strokeDef).frame(width: rampWidth, height: sectionHeight)
                LineH(y: offset7).stroke(strokeGrad, style: strokeDef).frame(width: flatWidth, height: sectionHeight).gesture(DragGesture().onChanged { gesture in offset7 = gesture.location.y})

                LineD(y1: offset7, y2: offset8).stroke(strokeGrad, style: strokeDef).frame(width: rampWidth, height: sectionHeight)
                LineH(y: offset8).stroke(strokeGrad, style: strokeDef).frame(width: flatWidth, height: sectionHeight).gesture(DragGesture().onChanged { gesture in offset8 = gesture.location.y})
              }.padding(.leading, 4.5).padding(.bottom, 4.5)
            }.padding(.horizontal, 15).padding(.vertical, 10).frame(height: sectionHeight + 20)

            HStack(alignment: .top, spacing: 0) {
              Text("  0m --->").monospacedDigit().frame(width: sectionWidth, alignment: .leading)

              VStack {
                HStack(alignment: .top, spacing: 0) {
                  Text(" 50m").monospacedDigit()
                  Text("🛑 1:00 --->").monospacedDigit().frame(maxWidth: .infinity, alignment: .center)
                }.frame(width: sectionWidth, alignment: .leading)
                Text("15.0s").monospacedDigit().frame(width: sectionWidth, alignment: .leading)
              }

              VStack {
                Text("100m --->").monospacedDigit().frame(width: sectionWidth, alignment: .leading)
                Text("15.0s").monospacedDigit().frame(width: sectionWidth, alignment: .leading)
              }

              VStack {
                Text("150m --->").monospacedDigit().frame(width: sectionWidth, alignment: .leading)
                Text("15.0s").monospacedDigit().frame(width: sectionWidth, alignment: .leading)
              }

              VStack {
                Text("200m --->").monospacedDigit().frame(width: sectionWidth, alignment: .leading)
                Text("15.0s").monospacedDigit().frame(width: sectionWidth, alignment: .leading)
              }

              VStack {
                Text("250m --->").monospacedDigit().frame(width: sectionWidth, alignment: .leading)
                Text("15.0s").monospacedDigit().frame(width: sectionWidth, alignment: .leading)
              }

              VStack {
                Text("300m --->").monospacedDigit().frame(width: sectionWidth, alignment: .leading)
                Text("15.0s").monospacedDigit().frame(width: sectionWidth, alignment: .leading)
              }

              VStack {
                Text("350m --->").monospacedDigit().frame(width: sectionWidth, alignment: .leading)
                Text("15.0s").monospacedDigit().frame(width: sectionWidth, alignment: .leading)
              }

              VStack {
                Text("400m").monospacedDigit().frame(width: sectionWidth2, alignment: .leading)
                Text("15.0s").monospacedDigit().frame(width: sectionWidth2, alignment: .leading)
              }
            }
          }
        }
      }

      Spacer().frame(height: 15)

      HStack {
        Text("Profile name:")
        TextField("", text: $profileName).textFieldStyle(.roundedBorder)
      }

      Text("Running time: 2:00.00 (15.0/50m, 5:00/km)")
      Text("Rest time: 1:00.00")

      Spacer()

      HStack {
        Button(action: { viewModel.finishProfile() }) { Text(" ").overlay { Image("baseline_delete_forever_48") } }
          .buttonStyle(ActionButtonStyleMax(disabledCol: true)).disabled(false)
        Button(action: { }) { Text(" SAVE ") }
          .buttonStyle(ActionButtonStyleMax(disabledCol: false)).disabled(false)
      }.padding(.bottom, 5)
    }.toolbar() {
      ToolbarItem(placement: .navigationBarTrailing) {
        StatusView()
      }
    }.navigationBarBackButtonHidden(true).padding(.horizontal, 20)
  }
}
