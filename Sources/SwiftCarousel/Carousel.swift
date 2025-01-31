//
//  File.swift
//  SwiftCarousel
//
//  Created by Ganesh Waje on 31/01/25.
//

import SwiftUI

public struct Carousel<Item: Identifiable, Content: View>: View {
  @StateObject private var state: CarouselState<Item>
  private let items: [Item]
  private let configuration: CarouselConfiguration
  private let content: (Item) -> Content
  
  @State private var offset: CGFloat = 0
  @State private var dragging: Bool = false
  
  // Create wrapped items for infinite scrolling
  private var wrappedItems: [Item] {
    guard configuration.scrollBehavior.isInfinite && !items.isEmpty else { return items }
    return [items.last!] + items + [items.first!]
  }
  
  public init(
      items: [Item],
      configuration: CarouselConfiguration = .init(),
      @ViewBuilder content: @escaping (Item) -> Content
  ) {
      self.items = items
      self.configuration = configuration
      self.content = content
      self._state = StateObject(wrappedValue: CarouselState(
          items: items,
          configuration: configuration
      ))
  }
  
  private var actualIndex: Int {
    guard configuration.scrollBehavior.isInfinite else { return state.currentIndex }
    return state.currentIndex + 1 // Account for the extra item at start
  }
  
  public var body: some View {
    VStack(spacing: 16) {
      GeometryReader { geometry in
        let itemWidth = geometry.size.width - configuration.spacing.sideMargins * 2
        let totalWidth = itemWidth + configuration.spacing.interItem
        
        HStack(spacing: configuration.spacing.interItem) {
          ForEach(wrappedItems) { item in
            content(item)
              .frame(width: itemWidth)
          }
        }
        .offset(x: -CGFloat(actualIndex) * totalWidth + offset)
        .gesture(
          DragGesture()
            .onChanged { value in
              dragging = true
              offset = value.translation.width
              state.stopAutoScroll()
            }
            .onEnded { value in
              dragging = false
              let predictedEndOffset = value.predictedEndTranslation.width
              let velocityThreshold: CGFloat = 500
              
              withAnimation(.easeOut(duration: 0.3)) {
                if abs(predictedEndOffset) > velocityThreshold {
                  if predictedEndOffset > 0 {
                    moveToPrevious()
                  } else {
                    moveToNext()
                  }
                } else if abs(offset) > itemWidth / 2 {
                  if offset > 0 {
                    moveToPrevious()
                  } else {
                    moveToNext()
                  }
                }
                offset = 0
              }
              
              if let interval = configuration.scrollBehavior.autoScrollInterval {
                state.startAutoScroll(interval: interval)
              }
            }
        )
        .onChange(of: state.currentIndex) { newIndex in
          if configuration.scrollBehavior.isInfinite {
            if newIndex < 0 {
              // Jump to end
              DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.none) {
                  state.currentIndex = items.count - 1
                }
              }
            } else if newIndex >= items.count {
              // Jump to start
              DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.none) {
                  state.currentIndex = 0
                }
              }
            }
          }
        }
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
  
  private func moveToNext() {
    state.currentIndex += 1
  }
  
  private func moveToPrevious() {
    state.currentIndex -= 1
  }
}
