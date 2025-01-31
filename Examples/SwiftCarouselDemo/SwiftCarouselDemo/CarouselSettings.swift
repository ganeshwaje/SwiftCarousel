//
//  CarouselSettings.swift
//  SwiftCarouselDemo
//
//  Created by Ganesh Waje on 31/01/25.
//

import SwiftUI
import Combine

class CarouselSettings: ObservableObject {
  @Published var isAutoScrollEnabled: Bool = true
  @Published var autoScrollInterval: Double = 3.0
  @Published var showsIndicator: Bool = true
  @Published var isInfiniteScrollEnabled: Bool = true
  @Published var itemSpacing: Double = 16.0
  @Published var sideMargins: Double = 24.0
  @Published var numberOfItems: Int = 5
}
