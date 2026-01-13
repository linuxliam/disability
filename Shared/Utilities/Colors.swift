import SwiftUI

/// Legacy color extensions for backward compatibility
/// New code should use ThemeManager and ColorTokens instead
extension Color {
    // Backgrounds
    static var appBackground: Color {
        #if os(macOS)
        return Color(NSColor.windowBackgroundColor)
        #else
        return Color(UIColor.systemBackground)
        #endif
    }
    static var groupedBackground: Color {
        #if os(macOS)
        return Color(NSColor.controlBackgroundColor)
        #else
        return Color(UIColor.systemGroupedBackground)
        #endif
    }
    static var cardBackground: Color {
        #if os(macOS)
        return Color(NSColor.textBackgroundColor)
        #else
        return Color(UIColor.secondarySystemBackground)
        #endif
    }
    static var secondaryCardBackground: Color {
        cardBackground.opacity(0.9)
    }
    
    // Text
    static var primaryText: Color { .primary }
    static var secondaryText: Color { .secondary }
    static var tertiaryText: Color { .secondary.opacity(0.7) }
    
    // Surfaces
    static var surfaceSecondary: Color {
        #if os(macOS)
        return Color(NSColor.controlBackgroundColor)
        #else
        return Color(UIColor.secondarySystemBackground)
        #endif
    }
    
    static var surfaceElevated: Color {
        #if os(macOS)
        return Color(NSColor.windowBackgroundColor)
        #else
        return Color(UIColor.tertiarySystemBackground)
        #endif
    }
    
    // Note: Brand/triad and semantic colors are defined in AppColorPalette.swift
    // Note: For theme-aware colors, use ThemeManager and ColorTokens instead
}
