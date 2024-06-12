//
//  ProfileUtil.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 12/06/2024.
//

import Foundation

func timeForOffset(_ offset: CGFloat) -> CGFloat {
  let offsetClamped = clamped(offset, 0.0...sectionHeight)

  let scaleFactor: CGFloat
  switch(offset) {
    case 0.0...sectionHeight2:
      let range = 1.5 - 1.0
      scaleFactor = 1.0 + range*(1.0 - offsetClamped/sectionHeight2)

    default:
      let oneThird = 1.0/3.0
      let range    = 1.0 - oneThird
      scaleFactor = oneThird + range*((sectionHeight - offsetClamped)/sectionHeight2)
  }

  return (15.0/scaleFactor).roundedToFifth()
}

func offsetForTime(_ time: CGFloat) -> CGFloat {
  let scaleFactor = 15.0/time

  let offset: CGFloat
  switch(scaleFactor) {
  case 1.0...:
    let range = 0.5
    offset = sectionHeight2 - sectionHeight2*((scaleFactor - 1.0)/range)

  default:
    let oneThird = 1.0/3.0
    let range    = 1.0 - oneThird
    offset = sectionHeight2 + sectionHeight2*((1.0 - scaleFactor)/range)
  }

  return offset
}

func snapTo(_ y: CGFloat) -> CGFloat {
  let time = timeForOffset(y)
  return offsetForTime(time)
}
