//
//  LayoutHelpers.swift
//  Disability Advocacy
//
//  Helper functions for responsive layouts
//

import SwiftUI

extension View {
    /// Creates adaptive grid columns that adjust based on minimum item width
    static func adaptiveGridColumns(minWidth: CGFloat = 280, spacing: CGFloat = 16) -> [GridItem] {
        // This will be calculated at runtime based on available width
        // For now, return flexible columns that adapt naturally
        return [
            GridItem(.adaptive(minimum: minWidth), spacing: spacing)
        ]
    }
    
    /// Creates a fixed number of flexible grid columns
    static func fixedGridColumns(count: Int, spacing: CGFloat = 16) -> [GridItem] {
        return Array(repeating: GridItem(.flexible(), spacing: spacing), count: count)
    }
}

// MARK: - Responsive Grid Helper
struct AdaptiveGrid<Content: View>: View {
    let minItemWidth: CGFloat
    let spacing: CGFloat
    let content: Content
    
    init(minItemWidth: CGFloat = 280, spacing: CGFloat = 16, @ViewBuilder content: () -> Content) {
        self.minItemWidth = minItemWidth
        self.spacing = spacing
        self.content = content()
    }
    
    var body: some View {
        GeometryReader { geometry in
            let columnCount = max(1, Int(geometry.size.width / (minItemWidth + spacing)))
            let columns = Array(repeating: GridItem(.flexible(), spacing: spacing), count: columnCount)
            
            LazyVGrid(columns: columns, spacing: spacing) {
                content
            }
        }
    }
}

