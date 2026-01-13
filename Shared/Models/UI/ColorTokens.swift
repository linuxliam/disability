//
//  ColorTokens.swift
//  Disability Advocacy
//
//  Semantic color token definitions for consistent theming
//

import SwiftUI

/// Semantic color tokens that provide theme-aware colors
/// These tokens abstract away the underlying color implementation
/// and provide a consistent API for accessing theme colors
enum ColorTokens {
    // MARK: - Surface Colors
    
    /// Primary surface color (cards, elevated content)
    @MainActor
    static func surfacePrimary(theme: ThemeManager) -> Color {
        theme.cardBackgroundColor
    }
    
    /// Secondary surface color (secondary cards, nested content)
    @MainActor
    static func surfaceSecondary(theme: ThemeManager) -> Color {
        if theme.highContrast {
            return theme.colorScheme == .dark ? Color(white: 0.2) : Color(white: 0.9)
        }
        return Color.surfaceSecondary
    }
    
    /// Elevated surface color (modals, popovers)
    @MainActor
    static func surfaceElevated(theme: ThemeManager) -> Color {
        if theme.highContrast {
            return theme.colorScheme == .dark ? Color(white: 0.25) : Color(white: 0.95)
        }
        return Color.surfaceElevated
    }
    
    /// Background color for screens
    @MainActor
    static func background(theme: ThemeManager) -> Color {
        theme.backgroundColor
    }
    
    /// Grouped background color for lists
    @MainActor
    static func groupedBackground(theme: ThemeManager) -> Color {
        theme.groupedBackgroundColor
    }
    
    // MARK: - Text Colors
    
    /// Primary text color
    @MainActor
    static func textPrimary(theme: ThemeManager) -> Color {
        theme.primaryTextColor
    }
    
    /// Secondary text color
    @MainActor
    static func textSecondary(theme: ThemeManager) -> Color {
        theme.secondaryTextColor
    }
    
    /// Tertiary text color
    @MainActor
    static func textTertiary(theme: ThemeManager) -> Color {
        theme.tertiaryTextColor
    }
    
    /// Accent text color (links, highlights)
    @MainActor
    static func textAccent(theme: ThemeManager) -> Color {
        theme.primaryColor
    }
    
    // MARK: - Border Colors
    
    /// Primary border color
    @MainActor
    static func borderPrimary(theme: ThemeManager) -> Color {
        theme.borderColor
    }
    
    /// Secondary border color (subtle borders)
    @MainActor
    static func borderSecondary(theme: ThemeManager) -> Color {
        if theme.highContrast {
            return theme.colorScheme == .dark ? Color.white.opacity(0.3) : Color.black.opacity(0.3)
        }
        return theme.borderColor.opacity(0.5)
    }
    
    /// Separator/divider color
    @MainActor
    static func separator(theme: ThemeManager) -> Color {
        theme.separatorColor
    }
    
    // MARK: - Semantic Colors
    
    /// Success color
    @MainActor
    static func semanticSuccess(theme: ThemeManager) -> Color {
        theme.successColor
    }
    
    /// Warning color
    @MainActor
    static func semanticWarning(theme: ThemeManager) -> Color {
        theme.warningColor
    }
    
    /// Error color
    @MainActor
    static func semanticError(theme: ThemeManager) -> Color {
        theme.errorColor
    }
    
    /// Info color
    @MainActor
    static func semanticInfo(theme: ThemeManager) -> Color {
        theme.infoColor
    }
    
    // MARK: - Semantic Background Colors
    
    /// Success background color
    @MainActor
    static func semanticSuccessBackground(theme: ThemeManager) -> Color {
        if theme.highContrast {
            return theme.colorScheme == .dark ? Color.green.opacity(0.3) : Color.green.opacity(0.2)
        }
        return Color.semanticSuccessBackground
    }
    
    /// Warning background color
    @MainActor
    static func semanticWarningBackground(theme: ThemeManager) -> Color {
        if theme.highContrast {
            return theme.colorScheme == .dark ? Color.orange.opacity(0.3) : Color.orange.opacity(0.2)
        }
        return Color.semanticWarningBackground
    }
    
    /// Error background color
    @MainActor
    static func semanticErrorBackground(theme: ThemeManager) -> Color {
        if theme.highContrast {
            return theme.colorScheme == .dark ? Color.red.opacity(0.3) : Color.red.opacity(0.2)
        }
        return Color.semanticErrorBackground
    }
    
    /// Info background color
    @MainActor
    static func semanticInfoBackground(theme: ThemeManager) -> Color {
        if theme.highContrast {
            return theme.colorScheme == .dark ? Color.blue.opacity(0.3) : Color.blue.opacity(0.2)
        }
        return Color.semanticInfoBackground
    }
    
    // MARK: - Brand Colors
    
    /// Primary brand color
    @MainActor
    static func brandPrimary(theme: ThemeManager) -> Color {
        theme.primaryColor
    }
    
    /// Secondary brand color
    @MainActor
    static func brandSecondary(theme: ThemeManager) -> Color {
        theme.secondaryColor
    }
    
    /// Tertiary brand color
    @MainActor
    static func brandTertiary(theme: ThemeManager) -> Color {
        theme.tertiaryColor
    }
}

// MARK: - View Extensions for Easy Access

// Note: Theme access is via @Environment(\.themeManager) in views

// MARK: - Convenience Extensions

extension ThemeManager {
    /// Convenience accessor for surface primary
    var surfacePrimary: Color {
        ColorTokens.surfacePrimary(theme: self)
    }
    
    /// Convenience accessor for surface secondary
    var surfaceSecondary: Color {
        ColorTokens.surfaceSecondary(theme: self)
    }
    
    /// Convenience accessor for surface elevated
    var surfaceElevated: Color {
        ColorTokens.surfaceElevated(theme: self)
    }
    
    /// Convenience accessor for text primary
    var textPrimary: Color {
        ColorTokens.textPrimary(theme: self)
    }
    
    /// Convenience accessor for text secondary
    var textSecondary: Color {
        ColorTokens.textSecondary(theme: self)
    }
    
    /// Convenience accessor for text tertiary
    var textTertiary: Color {
        ColorTokens.textTertiary(theme: self)
    }
    
    /// Convenience accessor for border primary
    var borderPrimary: Color {
        ColorTokens.borderPrimary(theme: self)
    }
}
