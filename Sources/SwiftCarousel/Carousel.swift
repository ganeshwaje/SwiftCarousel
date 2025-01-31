//
//  Carousel.swift
//  SwiftCarousel
//
//  Created by Ganesh Waje on 31/01/25.
//

import SwiftUI

public struct Carousel<Item: Identifiable, Content: View>: View {
  @StateObject private var state: CarouselState<Item>
  @ObservedObject private var animator: CarouselAnimator
  
  private let items: [Item]
  private let configuration: CarouselConfiguration
  private let content: (Item) -> Content
  
  public init(
    items: [Item],
    configuration: CarouselConfiguration = .init(),
    @ViewBuilder content: @escaping (Item) -> Content
  ) {
    self.items = items
    self.configuration = configuration
    self.content = content
    
    let state = CarouselState(
      items: items,
      configuration: configuration
    )
    self._state = StateObject(wrappedValue: state)
    self.animator = state.animator
  }
  
  public var body: some View {
    VStack(spacing: 16) {
      GeometryReader { geometry in
        let offset = CarouselOffset(
          containerWidth: geometry.size.width,
          itemSpacing: configuration.spacing.interItem,
          sideInsets: configuration.spacing.sideMargins,
          itemCount: items.count
        )
        
        HStack(spacing: configuration.spacing.interItem) {
          ForEach(items) { item in
            content(item)
              .frame(
                width: geometry.size.width - configuration.spacing.sideMargins * 2
              )
          }
        }
        .offset(
          x: offset.offset(
            for: animator.visualIndex,
            dragOffset: animator.dragOffset
          )
        )
        .gesture(
          DragGesture()
            .onChanged { value in
              state.isDragging = true
              state.handleDragGesture(.onChanged(value), in: geometry)
            }
            .onEnded { value in
              state.isDragging = false
              state.handleDragGesture(.onEnded(value), in: geometry)
            }
        )
      }
      
      if configuration.showsIndicator && items.count > 1 {
        NativePageIndicator(
          totalPages: items.count,
          currentPage: state.currentIndex,
          activeTint: configuration.indicatorActiveTint,
          inactiveTint: configuration.indicatorInactiveTint
        )
        .frame(height: 20)
      }
    }
    .onAppear {
      if let interval = configuration.scrollBehavior.autoScrollInterval {
        state.startAutoScroll(interval: interval)
      }
    }
    .onDisappear {
      state.stopAutoScroll()
    }
  }
}

extension DragGesture.Value {
  enum GestureType {
    case onChanged(DragGesture.Value)
    case onEnded(DragGesture.Value)
  }
}
