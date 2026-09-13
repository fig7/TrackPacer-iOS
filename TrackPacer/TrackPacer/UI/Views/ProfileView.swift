//
//  ProfileView.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 09/06/2024.
//

import SwiftUI

let lineDef: (color: Color, width: CGFloat, extent: CGFloat) = (.blue, 18.0, 9.0)
let axisDef: (color: Color, width: CGFloat, extent: CGFloat) = (.black, 3.0, 1.5)
let midDef: (color: Color, width: CGFloat, extent: CGFloat) = (.gray, 3.0, 1.5)

let strokeGrad = LinearGradient(colors: [.blue, .green, .red], startPoint:.bottom, endPoint: .top)
let strokeDef  = StrokeStyle(lineWidth: lineDef.width, lineCap: .round, lineJoin: .round)

let rampWidth: CGFloat = 20.0
let flatWidth: CGFloat = 150.0

let sectionWidth = rampWidth + flatWidth
let sectionWidth2 = sectionWidth / 2.0

let sectionHeight: CGFloat = 320.0
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

struct MAxis: View {
  let waypointCount: Int

  var body: some View {
    VStack(alignment:.leading, spacing: 0) {
      Spacer().frame(height: sectionHeight2)
      HStack(alignment:.center, spacing: 0) {
        Spacer().frame(width: midDef.width)
        LineH(y: midDef.extent).stroke(midDef.color, lineWidth: midDef.width).frame(width: CGFloat(waypointCount-1)*sectionWidth + midDef.width, height: midDef.width)
      }
      Spacer()
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
      HStack {
        VStack(alignment: .leading, spacing: 0) {
          Text("Profile name:")
          Text("for \(viewModel.profDesc)")
        }
        Spacer().frame(width:18)
        TextField("", text: $viewModel.profName).textFieldStyle(.roundedBorder)
      }

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
            ZStack(alignment: .bottomLeading) {
              XAxis(waypointCount: viewModel.profList.count).padding(.leading, axisDef.width)
              YAxis().padding(.bottom, axisDef.width)

              HStack(alignment: .top, spacing: 0) {
                ForEach(viewModel.profList.indices, id: \.self) { i in
                  let afterStart = (i > 0)
                  let beforeEnd  = ((i+1) < viewModel.profList.count)
                  if(afterStart) {
                    LineD(y1: viewModel.profList[i].prevOffset, y2: viewModel.profList[i].offset)
                      .stroke(strokeGrad, style: strokeDef).frame(width: rampWidth, height: sectionHeight)

                    LineH(y: viewModel.profList[i].offset)
                      .stroke(strokeGrad, style: strokeDef).frame(width: flatWidth, height: sectionHeight)
                      .gesture(DragGesture()
                        .onChanged { gesture in
                          let dist   = viewModel.profList[i].dist
                          let offset = viewModel.snapTo(gesture.location.y, forDist: dist)

                          viewModel.profList[i] = ProfileWaypoint(other: viewModel.profList[i],   offset: offset, roundTime: true)
                          if(beforeEnd) { viewModel.profList[i+1] = ProfileWaypoint(other: viewModel.profList[i+1], prevOffset: offset) }
                          viewModel.updateTimes()
                        })
                  }
                }
              }.padding(.leading, axisDef.width+axisDef.extent).padding(.bottom, axisDef.width+axisDef.extent)

              MAxis(waypointCount: viewModel.profList.count).padding(.leading, axisDef.width)
            }.padding(.horizontal, 15).padding(.vertical, 10).frame(height: sectionHeight + 20)

            HStack(alignment: .top, spacing: 0) {
              ForEach(viewModel.profList.indices, id: \.self) { i in
                let afterStart = (i > 0)
                let beforeEnd  = ((i+1) < viewModel.profList.count)

                VStack {
                  HStack(alignment: .top, spacing: 0) {
                    Text(viewModel.profList[i].name).monospacedDigit()
                    if(beforeEnd) { Text(viewModel.profList[i].waitTimeStr).monospacedDigit().frame(maxWidth: .infinity, alignment: .center) }
                  }.frame(width: sectionWidth, alignment: .leading)

                  if(afterStart) { Text("\(viewModel.profList[i].timeStr)").monospacedDigit().frame(width: sectionWidth, alignment: .leading) }
                }.onTapGesture { if(afterStart) { viewModel.editWaypoint(i, !beforeEnd) } }
              }
            }
          }
        }
      }

      Spacer().frame(height: 10)

      Text("Ref. time: \(viewModel.profTime) \(viewModel.profPace)").foregroundColor(colorForProfileValidity(viewModel.profValidity))
      Text("Rest time: \(viewModel.profWait)")

      Spacer().frame(height: 10)

      HStack {
        let deleteButton = viewModel.newProf ? "baseline_delete_forever_48d" : "baseline_delete_forever_48"
        Button(action: { viewModel.deleteProfile() }) { Text(" ").overlay { Image(deleteButton) } }.disabled(viewModel.newProf)
          .buttonStyle(ActionButtonStyleMax(disabledCol: true)).disabled(false)
        Button(action: { viewModel.saveProfile() }) { Text(" SAVE ") }
          .buttonStyle(ActionButtonStyleMax(disabledCol: false)).disabled(false)
      }.padding(.bottom, 5)
    }.toolbar() {
      ToolbarItem(placement: .navigationBarTrailing) {
        StatusView()
      }
    }.navigationBarBackButtonHidden(false).padding(.horizontal, 20)
  }
}
