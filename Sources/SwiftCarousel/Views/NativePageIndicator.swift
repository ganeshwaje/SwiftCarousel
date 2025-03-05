//
//  NativePageIndicator.swift
//  SwiftCarousel
//
//  Created by Ganesh Waje on 31/01/25.
//

import SwiftUI

struct NativePageIndicator: UIViewRepresentable {
  let totalPages: Int
  let currentPage: Int
  let activeTint: Color
  let inactiveTint: Color
  
  init(
    totalPages: Int,
    currentPage: Int,
    activeTint: Color = .blue,
    inactiveTint: Color = .gray.opacity(0.5)
  ) {
    self.totalPages = totalPages
    self.currentPage = currentPage
    self.activeTint = activeTint
    self.inactiveTint = inactiveTint
  }
  
  func makeUIView(context: Context) -> UIPageControl {
    let pageControl = UIPageControl()
    pageControl.numberOfPages = totalPages
    pageControl.currentPage = currentPage
    pageControl.pageIndicatorTintColor = UIColor(inactiveTint)
    pageControl.currentPageIndicatorTintColor = UIColor(activeTint)
    pageControl.isUserInteractionEnabled = false
    return pageControl
  }
  
  func updateUIView(_ pageControl: UIPageControl, context: Context) {
    pageControl.numberOfPages = totalPages
    pageControl.currentPage = currentPage
    pageControl.pageIndicatorTintColor = UIColor(inactiveTint)
    pageControl.currentPageIndicatorTintColor = UIColor(activeTint)
  }
}
