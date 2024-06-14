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

let sectionWidth = rampWidth + flatWidth
let sectionWidth2 = sectionWidth / 2.0

let sectionHeight: CGFloat = 340.0
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
  let waypointCount: Int

  var body: some View {
    VStack(alignment:.leading, spacing: 0) {
      LineH(y: axisDef.extent).stroke(axisDef.color, lineWidth: axisDef.width).frame(width: CGFloat(waypointCount-1)*sectionWidth + axisDef.width, height: axisDef.width)

      HStack(alignment:.top, spacing: 0) {
        ForEach(0..<waypointCount, id: \.self) { _ in
          LineV(x: axisDef.extent).stroke(axisDef.color, lineWidth: axisDef.width).frame(width: axisDef.width, height: axisDef.width)
          Spacer().frame(width: sectionWidth-axisDef.width)
        }
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

func colorForProfileValidity(_ validity: ProfileValidity) -> Color {
  switch(validity) {
  case .OK:
    return .black

  case .TooFast:
    return .red

  case .TooSlow:
    return .blue
  }
}

struct ProfileView: View {
  @EnvironmentObject var viewModel: ProfileViewModel

  var body: some View {
    VStack(alignment: .leading, spacing: 5) {
      Spacer().frame(height: 5)

      ScrollView(.horizontal) {
        HStack(alignment: .top, spacing: 0) {
          VStack(alignment: .leading) {
            Text("150%")
            Spacer()
            Text("100%")
            Spacer()
            Text("33%")
          }.frame(height: sectionHeight + 20)

          VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .bottomLeading){
              XAxis(waypointCount: viewModel.waypointList.count).padding(.leading, axisDef.width)
              YAxis().padding(.bottom, axisDef.width)

              HStack(alignment: .top, spacing: 0) {
                ForEach(viewModel.waypointList.indices, id: \.self) { i in
                  let afterStart = (i > 0)
                  let beforeEnd  = ((i+1) < viewModel.waypointList.count)
                  if(afterStart) {
                    LineD(y1: viewModel.waypointList[i].prevOffset, y2: viewModel.waypointList[i].offset)
                      .stroke(strokeGrad, style: strokeDef).frame(width: rampWidth, height: sectionHeight)

                    LineH(y: viewModel.waypointList[i].offset)
                      .stroke(strokeGrad, style: strokeDef).frame(width: flatWidth, height: sectionHeight)
                      .gesture(DragGesture()
                        .onChanged { gesture in
                          let dist   = viewModel.waypointList[i].dist
                          let offset = viewModel.snapTo(gesture.location.y, forDist: dist)

                          viewModel.waypointList[i] = ProfileWaypoint(other: viewModel.waypointList[i],   offset: offset, roundTime: true)
                          if(beforeEnd) { viewModel.waypointList[i+1] = ProfileWaypoint(other: viewModel.waypointList[i+1], prevOffset: offset) }
                          viewModel.updateTimes()
                        })
                  }
                }
              }.padding(.leading, axisDef.width+axisDef.extent).padding(.bottom, axisDef.width+axisDef.extent)
            }.padding(.horizontal, 15).padding(.vertical, 10).frame(height: sectionHeight + 20)

            HStack(alignment: .top, spacing: 0) {
              ForEach(viewModel.waypointList.indices, id: \.self) { i in
                let afterStart = (i > 0)
                let beforeEnd  = ((i+1) < viewModel.waypointList.count)

                VStack {
                  HStack(alignment: .top, spacing: 0) {
                    Text(viewModel.waypointList[i].name).monospacedDigit()
                    if(beforeEnd) { Text(viewModel.waypointList[i].waitTimeStr).monospacedDigit().frame(maxWidth: .infinity, alignment: .center) }
                  }.frame(width: sectionWidth, alignment: .leading)

                  if(afterStart) { Text("\(viewModel.waypointList[i].timeStr)").monospacedDigit().frame(width: sectionWidth, alignment: .leading) }
                }.onTapGesture { if(afterStart) { viewModel.editWaypoint(i, !beforeEnd) } }
              }
            }
          }
        }
      }

      Spacer().frame(height: 15)

      HStack {
        Text("\(viewModel.profileDesc):")
        TextField("", text: $viewModel.profileName).textFieldStyle(.roundedBorder)
      }

      Text("Ref. time: \(viewModel.profileTime) \(viewModel.profilePace)").foregroundColor(colorForProfileValidity(viewModel.profileValidity))
      Text("Rest time: \(viewModel.profileWait)")

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
