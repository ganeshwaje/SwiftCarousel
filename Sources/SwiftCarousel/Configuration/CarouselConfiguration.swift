//
//  CarouselConfiguration.swift
//  SwiftCarousel
//
//  Created by Ganesh Waje on 31/01/25.
//

import SwiftUI

public struct CarouselConfiguration {
  public struct Spacing {
    public let interItem: CGFloat
    public let sideMargins: CGFloat
    
    public init(
      interItem: CGFloat = 16,
      sideMargins: CGFloat = 16
    ) {
      self.interItem = interItem
      self.sideMargins = sideMargins
    }
  }
  
  public struct ScrollBehavior {
    public let isInfinite: Bool
    public let autoScrollInterval: TimeInterval?
    
    public init(
      isInfinite: Bool = true,
      autoScrollInterval: TimeInterval? = 3.0
    ) {
      self.isInfinite = isInfinite
      self.autoScrollInterval = autoScrollInterval
    }
  }
  
  public let spacing: Spacing
  public let scrollBehavior: ScrollBehavior
  public let showsIndicator: Bool
  public let indicatorActiveTint: Color
  public let indicatorInactiveTint: Color
  
  public init(
    spacing: Spacing = Spacing(),
    scrollBehavior: ScrollBehavior = ScrollBehavior(),
    showsIndicator: Bool = true,
    indicatorActiveTint: Color = .blue,
    indicatorInactiveTint: Color = .gray.opacity(0.5)
  ) {
    self.spacing = spacing
    self.scrollBehavior = scrollBehavior
    self.showsIndicator = showsIndicator
    self.indicatorActiveTint = indicatorActiveTint
    self.indicatorInactiveTint = indicatorInactiveTint
  }
}
