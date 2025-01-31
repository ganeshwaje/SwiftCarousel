//
//  CarouselOffset.swift
//  SwiftCarousel
//
//  Created by Ganesh Waje on 31/01/25.
//

import SwiftUI

struct CarouselOffset {
  let containerWidth: CGFloat
  let itemSpacing: CGFloat
  let sideInsets: CGFloat
  let itemCount: Int
  
  private var itemWidth: CGFloat {
    containerWidth - (sideInsets * 2)
  }
  
  private var totalItemWidth: CGFloat {
    itemWidth + itemSpacing
  }
  
  func offset(for index: Int, dragOffset: CGFloat = 0) -> CGFloat {
    let baseOffset = -CGFloat(index) * totalItemWidth
    return baseOffset + dragOffset + sideInsets
  }
  
  func nearestIndex(for offset: CGFloat, velocity: CGFloat) -> Int {
    let proposedIndex = -round((offset - sideInsets) / totalItemWidth)
    
    // Apply velocity bias
    let velocityThreshold: CGFloat = 300
    if abs(velocity) > velocityThreshold {
      return Int(proposedIndex) + (velocity > 0 ? -1 : 1)
    }
    
    return Int(proposedIndex)
  }
  
  func clampedIndex(_ index: Int) -> Int {
    min(max(0, index), itemCount - 1)
  }
  
  func shouldTransitionToOpposite(_ index: Int) -> Bool {
    return index < 0 || index >= itemCount
  }
  
  func oppositeIndex(_ index: Int) -> Int {
    if index < 0 {
      return itemCount - 1
    } else if index >= itemCount {
      return 0
    }
    return index
  }
}
