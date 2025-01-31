//
//  ContentView.swift
//  SwiftCarouselDemo
//
//  Created by Ganesh Waje on 31/01/25.
//

import SwiftUI
import SwiftCarousel

struct ContentView: View {
  struct Item: Identifiable {
    let id = UUID()
    let color: Color
    let title: String
  }
  
  @StateObject private var settings = CarouselSettings()
  
  var items: [Item] {
    (0..<settings.numberOfItems).map { index in
      Item(
        color: [.blue, .red, .green, .purple, .orange][index % 5],
        title: "Item \(index + 1)"
      )
    }
  }
  
  var body: some View {
    ScrollView {
      VStack(spacing: 20) {
        // Carousel Section
        Carousel(
          items: items,
          configuration: CarouselConfiguration(
            spacing: .init(
              interItem: settings.itemSpacing,
              sideMargins: settings.sideMargins
            ),
            scrollBehavior: .init(
              isInfinite: settings.isInfiniteScrollEnabled,
              autoScrollInterval: settings.isAutoScrollEnabled ?
              settings.autoScrollInterval : nil
            ),
            showsIndicator: settings.showsIndicator
          )
        ) { item in
          RoundedRectangle(cornerRadius: 12)
            .fill(item.color)
            .overlay(
              Text(item.title)
                .foregroundColor(.white)
                .font(.title2)
            )
        }
        .frame(height: 200)
        
        // Settings Section
        VStack(spacing: 16) {
          Text("Settings")
            .font(.title2)
            .fontWeight(.bold)
            .frame(maxWidth: .infinity, alignment: .leading)
          
          // Scrolling Settings
          GroupBox("Scrolling") {
            VStack(spacing: 12) {
              Toggle("Auto Scroll", isOn: $settings.isAutoScrollEnabled)
              
              if settings.isAutoScrollEnabled {
                VStack(spacing: 8) {
                  HStack {
                    Text("Interval")
                    Spacer()
                    Text("\(settings.autoScrollInterval, specifier: "%.1f")s")
                  }
                  Slider(
                    value: $settings.autoScrollInterval,
                    in: 1...10,
                    step: 0.5
                  )
                }
              }
              
              Toggle("Infinite Scroll", isOn: $settings.isInfiniteScrollEnabled)
            }
            .padding(.vertical, 8)
          }
          
          // Layout Settings
          GroupBox("Layout") {
            VStack(spacing: 12) {
              Toggle("Show Page Indicator", isOn: $settings.showsIndicator)
              
              VStack(spacing: 8) {
                HStack {
                  Text("Item Spacing")
                  Spacer()
                  Text("\(settings.itemSpacing, specifier: "%.0f")")
                }
                Slider(
                  value: $settings.itemSpacing,
                  in: 0...50,
                  step: 4
                )
              }
              
              VStack(spacing: 8) {
                HStack {
                  Text("Side Margins")
                  Spacer()
                  Text("\(settings.sideMargins, specifier: "%.0f")")
                }
                Slider(
                  value: $settings.sideMargins,
                  in: 0...50,
                  step: 4
                )
              }
            }
            .padding(.vertical, 8)
          }
          
          // Content Settings
          GroupBox("Content") {
            Stepper(
              "Number of Items: \(settings.numberOfItems)",
              value: $settings.numberOfItems,
              in: 2...10
            )
            .padding(.vertical, 8)
          }
        }
        .padding(.horizontal)
      }
      .padding(.vertical)
    }
    .navigationTitle("SwiftCarousel Demo")
  }
}

#Preview {
  NavigationView {
    ContentView()
  }
}
