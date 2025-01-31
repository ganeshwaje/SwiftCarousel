//
//  CarouselState.swift
//  SwiftCarousel
//
//  Created by Ganesh Waje on 31/01/25.
//
import SwiftUI
import Combine

@MainActor
final class CarouselState<Item: Identifiable>: ObservableObject {
  @Published private(set) var currentIndex: Int
  @Published private(set) var isAutoScrolling: Bool = false
  @Published var isDragging: Bool = false
  
  let animator: CarouselAnimator
  private let items: [Item]
  private let configuration: CarouselConfiguration
  private var autoScrollTask: Task<Void, Never>?
  private var cancellables = Set<AnyCancellable>()
  
  init(items: [Item], configuration: CarouselConfiguration) {
    self.items = items
    self.configuration = configuration
    self.currentIndex = 0
    self.animator = CarouselAnimator()
    
    setupSubscriptions()
  }
  
  private func setupSubscriptions() {
    // Handle drag state changes
    $isDragging
      .dropFirst()
      .sink { [weak self] isDragging in
        guard let self = self else { return }
        if isDragging {
          self.stopAutoScroll()
        } else if let interval = configuration.scrollBehavior.autoScrollInterval {
          self.startAutoScroll(interval: interval)
        }
      }
      .store(in: &cancellables)
  }
  
  func moveToIndex(_ index: Int, animated: Bool = true) {
    guard index != currentIndex else { return }
    
    let targetIndex: Int
    if configuration.scrollBehavior.isInfinite {
      targetIndex = (index + items.count) % items.count
    } else {
      targetIndex = min(max(0, index), items.count - 1)
    }
    
    if animated {
      animator.animate(to: targetIndex) { [weak self] in
        self?.currentIndex = targetIndex
      }
    } else {
      currentIndex = targetIndex
      animator.visualIndex = targetIndex
    }
  }
  
  func startAutoScroll(interval: TimeInterval) {
    guard !items.isEmpty && items.count > 1 else { return }
    
    isAutoScrolling = true
    autoScrollTask = Task { [weak self] in
      while !Task.isCancelled {
        try? await Task.sleep(nanoseconds: UInt64(interval * 1_000_000_000))
        
        await MainActor.run { [weak self] in
          guard let self = self,
                self.isAutoScrolling,
                !self.isDragging,
                !self.animator.isAnimating else { return }
          
          let nextIndex = self.currentIndex + 1
          self.moveToIndex(nextIndex)
        }
      }
    }
  }
  
  func stopAutoScroll() {
    isAutoScrolling = false
    autoScrollTask?.cancel()
    autoScrollTask = nil
  }
  
  func handleDragGesture(_ gesture: DragGesture.Value.GestureType, in geometry: GeometryProxy) {
    let offset = CarouselOffset(
      containerWidth: geometry.size.width,
      itemSpacing: configuration.spacing.interItem,
      sideInsets: configuration.spacing.sideMargins,
      itemCount: items.count
    )
    
    switch gesture {
    case .onChanged(let value):
      animator.dragOffset = value.translation.width
      
    case .onEnded(let value):
      let velocity = value.predictedEndLocation.x - value.location.x
      let proposedIndex = offset.nearestIndex(
        for: value.translation.width,
        velocity: velocity
      )
      
      moveToIndex(currentIndex + proposedIndex)
    }
  }
}
