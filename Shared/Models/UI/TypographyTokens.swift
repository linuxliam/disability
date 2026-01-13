//
//  TypographyTokens.swift
//  Disability Advocacy
//
//  Typography token definitions for consistent text styling
//

import SwiftUI

/// Typography tokens that provide theme-aware text styling
/// These tokens abstract away font sizes and provide dynamic type support
enum TypographyTokens {
    // MARK: - Display
    
    /// Large display text (34pt)
    @MainActor
    static func displayLarge(theme: ThemeManager) -> Font {
        let baseSize: CGFloat = 34
        return .system(size: baseSize * theme.customFontSize, weight: .bold, design: .default)
    }
    
    /// Medium display text (28pt)
    @MainActor
    static func displayMedium(theme: ThemeManager) -> Font {
        let baseSize: CGFloat = 28
        return .system(size: baseSize * theme.customFontSize, weight: .bold, design: .default)
    }
    
    // MARK: - Headings
    
    /// H1 heading (24pt)
    @MainActor
    static func headingLarge(theme: ThemeManager) -> Font {
        let baseSize: CGFloat = 24
        return .system(size: baseSize * theme.customFontSize, weight: .bold, design: .default)
    }
    
    /// H2 heading (20pt)
    @MainActor
    static func headingMedium(theme: ThemeManager) -> Font {
        let baseSize: CGFloat = 20
        return .system(size: baseSize * theme.customFontSize, weight: .bold, design: .default)
    }
    
    /// H3 heading (18pt)
    @MainActor
    static func headingSmall(theme: ThemeManager) -> Font {
        let baseSize: CGFloat = 18
        return .system(size: baseSize * theme.customFontSize, weight: .semibold, design: .default)
    }
    
    /// H4 heading (16pt)
    @MainActor
    static func headingXSmall(theme: ThemeManager) -> Font {
        let baseSize: CGFloat = 16
        return .system(size: baseSize * theme.customFontSize, weight: .semibold, design: .default)
    }
    
    // MARK: - Body
    
    /// Large body text (17pt)
    @MainActor
    static func bodyLarge(theme: ThemeManager) -> Font {
        let baseSize: CGFloat = 17
        return .system(size: baseSize * theme.customFontSize, weight: .regular, design: .default)
    }
    
    /// Medium body text (15pt)
    @MainActor
    static func bodyMedium(theme: ThemeManager) -> Font {
        let baseSize: CGFloat = 15
        return .system(size: baseSize * theme.customFontSize, weight: .regular, design: .default)
    }
    
    /// Small body text (13pt)
    @MainActor
    static func bodySmall(theme: ThemeManager) -> Font {
        let baseSize: CGFloat = 13
        return .system(size: baseSize * theme.customFontSize, weight: .regular, design: .default)
    }
    
    // MARK: - Labels
    
    /// Large label text (15pt)
    @MainActor
    static func labelLarge(theme: ThemeManager) -> Font {
        let baseSize: CGFloat = 15
        return .system(size: baseSize * theme.customFontSize, weight: .medium, design: .default)
    }
    
    /// Medium label text (13pt)
    @MainActor
    static func labelMedium(theme: ThemeManager) -> Font {
        let baseSize: CGFloat = 13
        return .system(size: baseSize * theme.customFontSize, weight: .medium, design: .default)
    }
    
    /// Small label text (11pt)
    @MainActor
    static func labelSmall(theme: ThemeManager) -> Font {
        let baseSize: CGFloat = 11
        return .system(size: baseSize * theme.customFontSize, weight: .medium, design: .default)
    }
    
    // MARK: - Caption
    
    /// Caption text (12pt)
    @MainActor
    static func caption(theme: ThemeManager) -> Font {
        let baseSize: CGFloat = 12
        return .system(size: baseSize * theme.customFontSize, weight: .regular, design: .default)
    }
    
    /// Small caption text (10pt)
    @MainActor
    static func captionSmall(theme: ThemeManager) -> Font {
        let baseSize: CGFloat = 10
        return .system(size: baseSize * theme.customFontSize, weight: .regular, design: .default)
    }
    
    // MARK: - Line Heights
    
    /// Standard line height multiplier
    static let lineHeightMultiplier: CGFloat = 1.4
    
    /// Tight line height multiplier (for headings)
    static let lineHeightTight: CGFloat = 1.2
    
    /// Loose line height multiplier (for body text)
    static let lineHeightLoose: CGFloat = 1.6
    
    // MARK: - Letter Spacing
    
    /// Standard letter spacing
    static let letterSpacingStandard: CGFloat = 0
    
    /// Tight letter spacing (for headings)
    static let letterSpacingTight: CGFloat = -0.5
    
    /// Loose letter spacing (for large text)
    static let letterSpacingLoose: CGFloat = 0.5
}

// MARK: - Convenience Extensions

extension ThemeManager {
    /// Convenience accessor for display large font
    var displayLarge: Font {
        TypographyTokens.displayLarge(theme: self)
    }
    
    /// Convenience accessor for heading large font
    var headingLarge: Font {
        TypographyTokens.headingLarge(theme: self)
    }
    
    /// Convenience accessor for body medium font
    var bodyMedium: Font {
        TypographyTokens.bodyMedium(theme: self)
    }
}
