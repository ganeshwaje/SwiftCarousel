
# SwiftCarousel

A customizable, performance-optimized carousel component for SwiftUI applications.

## Features
- Infinite scrolling
- Auto-scrolling with configurable interval  
- Native UIPageControl integration
- Customizable layout and spacing
- Generic content support
- iOS 14.0+ support

## Installation

### Swift Package Manager
```swift
dependencies: [
   .package(url: "https://github.com/ganeshwaje/SwiftCarousel.git", from: "1.0.0")
]
```

## Usage
```
import SwiftCarousel

struct ContentView: View {
    let items = [
        Item(id: 1, title: "First"),
        Item(id: 2, title: "Second"),
        Item(id: 3, title: "Third")
    ]
    
    var body: some View {
        Carousel(
            items: items,
            configuration: CarouselConfiguration(
                spacing: .init(interItem: 16, sideMargins: 24),
                scrollBehavior: .init(isInfinite: true, autoScrollInterval: 3.0),
                showsIndicator: true,
                indicatorActiveTint: .blue,
                indicatorInactiveTint: .gray.opacity(0.5)
            )
        ) { item in
            Text(item.title)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
        }
        .frame(height: 200)
    }
}
```
## CarouselConfiguration

```
// Basic configuration
let config = CarouselConfiguration()

// Custom configuration
let config = CarouselConfiguration(
    spacing: .init(interItem: 16, sideMargins: 24),
    scrollBehavior: .init(isInfinite: true, autoScrollInterval: 3.0),
    showsIndicator: true,
    indicatorActiveTint: .blue,
    indicatorInactiveTint: .gray
)
```
## Contributing

Contributions are welcome! If you find a bug or have a feature request, please open an issue. If you'd like to contribute code, follow these steps:

Fork the repository.
Create a new branch for your feature or bugfix.
Submit a pull request.

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Author
Ganesh Waje
