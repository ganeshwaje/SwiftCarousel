//
//  CarouselAnimator.swift
//  SwiftCarousel
//
//  Created by Ganesh Waje on 31/01/25.
//

import SwiftUI

@MainActor
final class CarouselAnimator: ObservableObject {
  @Published var visualIndex: Int
  @Published var dragOffset: CGFloat = 0
  @Published private(set) var isAnimating = false
  
  private var transitionWorkItem: DispatchWorkItem?
  private let animationDuration: TimeInterval = 0.3
  
  init(initialIndex: Int = 0) {
    self.visualIndex = initialIndex
  }
  
  func animate(to index: Int, completion: (() -> Void)? = nil) {
    isAnimating = true
    
    // Cancel any pending transitions
    transitionWorkItem?.cancel()
    
    withAnimation(.easeInOut(duration: animationDuration)) {
      visualIndex = index
      dragOffset = 0
    }
    
    let workItem = DispatchWorkItem { [weak self] in
      self?.isAnimating = false
      completion?()
    }
    
    transitionWorkItem = workItem
    DispatchQueue.main.asyncAfter(
      deadline: .now() + animationDuration,
      execute: workItem
    )
  }
  
  func cancelAnimation() {
    transitionWorkItem?.cancel()
    transitionWorkItem = nil
    isAnimating = false
  }
}
