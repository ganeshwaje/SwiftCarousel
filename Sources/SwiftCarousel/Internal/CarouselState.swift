//
//  CarouselState.swift
//  SwiftCarousel
//
//  Created by Ganesh Waje on 31/01/25.
//

import SwiftUI

@MainActor
final class CarouselState<Item: Identifiable>: ObservableObject {
  @Published var currentIndex: Int = 0
  @Published private(set) var isAutoScrolling: Bool = false
  
  private let items: [Item]
  private let configuration: CarouselConfiguration
  private var autoScrollTask: Task<Void, Never>?
  
  init(items: [Item], configuration: CarouselConfiguration) {
    self.items = items
    self.configuration = configuration
  }
  
  func startAutoScroll(interval: TimeInterval) {
    guard !items.isEmpty else { return }
    
    isAutoScrolling = true
    autoScrollTask = Task { [weak self] in
      while !Task.isCancelled && self?.isAutoScrolling == true {
        try? await Task.sleep(nanoseconds: UInt64(interval * 1_000_000_000))
        guard !Task.isCancelled else { break }
        
        await MainActor.run { [weak self] in
          guard let self = self, self.isAutoScrolling else { return }
          
          if self.configuration.scrollBehavior.isInfinite {
            self.currentIndex = (self.currentIndex + 1) % self.items.count
          } else if self.currentIndex < self.items.count - 1 {
            self.currentIndex += 1
          }
        }
      }
    }
  }
  
  func stopAutoScroll() {
    isAutoScrolling = false
    autoScrollTask?.cancel()
    autoScrollTask = nil
  }
}
