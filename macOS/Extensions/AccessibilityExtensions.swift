//
//  AccessibilityExtensions.swift
//  Disability Advocacy
//
//  Accessibility helper extensions
//

import SwiftUI

extension View {
    /// Makes a view accessible as a card with proper labeling
    func accessibilityCard(title: String, description: String? = nil) -> some View {
        self
            .accessibilityElement(children: .combine)
            .accessibilityLabel(description.map { "\(title), \($0)" } ?? title)
            .accessibilityAddTraits(.isButton)
    }
    
    /// Makes a view accessible as a section
    func accessibilitySection(title: String) -> some View {
        self
            .accessibilityElement(children: .contain)
            .accessibilityLabel(title)
            .accessibilityAddTraits(.isHeader)
    }
    
    /// Adds accessibility support for dynamic type
    func supportsDynamicType() -> some View {
        self
            .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
    }
    
    /// Adds accessibility hint for interactive elements
    func withAccessibilityHint(_ hint: String) -> some View {
        self
            .accessibilityHint(hint)
    }
}

