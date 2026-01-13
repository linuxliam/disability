//
//  ThemeManager.swift
//  Disability Advocacy
//
//  Centralized theme manager for managing app-wide theme, colors, and accessibility settings
//

import SwiftUI
import Observation

#if os(macOS)
import AppKit
#else
import UIKit
#endif

/// Centralized theme manager that provides theme-aware colors, typography, and accessibility settings
@MainActor
@Observable
class ThemeManager {
    // MARK: - Theme Configuration
    
    /// Current theme configuration
    var configuration: ThemeConfiguration = .default {
        didSet {
            persistConfiguration()
        }
    }
    
    /// Color scheme preference (overrides system if set)
    var colorScheme: ColorScheme {
        get {
            if let scheme = configuration.colorScheme {
                return scheme
            }
            // Return system color scheme
            #if os(macOS)
            return NSApp.effectiveAppearance.name == .darkAqua ? .dark : .light
            #else
            return UITraitCollection.current.userInterfaceStyle == .dark ? .dark : .light
            #endif
        }
        set {
            configuration.colorScheme = newValue
        }
    }
    
    /// High contrast mode enabled
    var highContrast: Bool {
        get { configuration.highContrast || SystemSettingsManager.isIncreaseContrastEnabled }
        set { configuration.highContrast = newValue }
    }
    
    /// Reduced motion enabled
    var reducedMotion: Bool {
        get { configuration.reducedMotion || SystemSettingsManager.isReduceMotionEnabled }
        set { configuration.reducedMotion = newValue }
    }
    
    /// Custom font size multiplier
    var customFontSize: CGFloat {
        get { configuration.customFontSize }
        set { configuration.customFontSize = max(0.8, min(2.0, newValue)) }
    }
    
    /// Screen reader optimized mode
    var screenReaderOptimized: Bool {
        get { configuration.screenReaderOptimized || SystemSettingsManager.isVoiceOverRunning }
        set { configuration.screenReaderOptimized = newValue }
    }
    
    // MARK: - Persistence
    
    private static let colorSchemeKey = "theme.colorScheme"
    private static let highContrastKey = "theme.highContrast"
    private static let reducedMotionKey = "theme.reducedMotion"
    private static let customFontSizeKey = "theme.customFontSize"
    private static let screenReaderOptimizedKey = "theme.screenReaderOptimized"
    
    /// Load configuration from UserDefaults
    static func loadConfiguration() -> ThemeConfiguration {
        var config = ThemeConfiguration.default
        
        // Load color scheme
        if let schemeRaw = UserDefaults.standard.string(forKey: colorSchemeKey) {
            switch schemeRaw {
            case "light":
                config.colorScheme = .light
            case "dark":
                config.colorScheme = .dark
            default:
                config.colorScheme = nil
            }
        }
        
        // Load other settings
        config.highContrast = UserDefaults.standard.bool(forKey: highContrastKey)
        config.reducedMotion = UserDefaults.standard.bool(forKey: reducedMotionKey)
        config.customFontSize = UserDefaults.standard.object(forKey: customFontSizeKey) as? CGFloat ?? 1.0
        config.screenReaderOptimized = UserDefaults.standard.bool(forKey: screenReaderOptimizedKey)
        
        return config
    }
    
    /// Persist configuration to UserDefaults
    private func persistConfiguration() {
        let defaults = UserDefaults.standard
        
        // Persist color scheme
        if let scheme = configuration.colorScheme {
            switch scheme {
            case .light:
                defaults.set("light", forKey: Self.colorSchemeKey)
            case .dark:
                defaults.set("dark", forKey: Self.colorSchemeKey)
            @unknown default:
                defaults.set("unspecified", forKey: Self.colorSchemeKey)
            }
        } else {
            defaults.set("unspecified", forKey: Self.colorSchemeKey)
        }
        
        // Persist other settings
        defaults.set(configuration.highContrast, forKey: Self.highContrastKey)
        defaults.set(configuration.reducedMotion, forKey: Self.reducedMotionKey)
        defaults.set(configuration.customFontSize, forKey: Self.customFontSizeKey)
        defaults.set(configuration.screenReaderOptimized, forKey: Self.screenReaderOptimizedKey)
    }
    
    // MARK: - Initialization
    
    init() {
        self.configuration = Self.loadConfiguration()
    }
    
    // MARK: - Theme-Aware Colors
    
    /// Primary brand color (triad primary)
    var primaryColor: Color {
        Color.triadPrimary
    }
    
    /// Secondary brand color (triad secondary)
    var secondaryColor: Color {
        Color.triadSecondary
    }
    
    /// Tertiary brand color (triad tertiary)
    var tertiaryColor: Color {
        Color.triadTertiary
    }
    
    /// Background color for screens
    var backgroundColor: Color {
        if highContrast {
            return colorScheme == .dark ? Color.black : Color.white
        }
        return Color.appBackground
    }
    
    /// Grouped background color for lists
    var groupedBackgroundColor: Color {
        if highContrast {
            return colorScheme == .dark ? Color(white: 0.1) : Color(white: 0.95)
        }
        return Color.groupedBackground
    }
    
    /// Card/surface background color
    var cardBackgroundColor: Color {
        if highContrast {
            return colorScheme == .dark ? Color(white: 0.15) : Color(white: 0.98)
        }
        return Color.cardBackground
    }
    
    /// Primary text color
    var primaryTextColor: Color {
        if highContrast {
            return colorScheme == .dark ? Color.white : Color.black
        }
        return Color.primaryText
    }
    
    /// Secondary text color
    var secondaryTextColor: Color {
        if highContrast {
            return colorScheme == .dark ? Color(white: 0.9) : Color(white: 0.2)
        }
        return Color.secondaryText
    }
    
    /// Tertiary text color
    var tertiaryTextColor: Color {
        if highContrast {
            return colorScheme == .dark ? Color(white: 0.8) : Color(white: 0.3)
        }
        return Color.tertiaryText
    }
    
    /// Border color
    var borderColor: Color {
        if highContrast {
            return colorScheme == .dark ? Color.white.opacity(0.5) : Color.black.opacity(0.5)
        }
        return Color("borderColor")
    }
    
    /// Separator/divider color
    var separatorColor: Color {
        if highContrast {
            return colorScheme == .dark ? Color.white.opacity(0.6) : Color.black.opacity(0.6)
        }
        return Color("dividerColor")
    }
    
    // MARK: - Semantic Colors
    
    /// Success color
    var successColor: Color {
        Color.semanticSuccess
    }
    
    /// Warning color
    var warningColor: Color {
        Color.semanticWarning
    }
    
    /// Error color
    var errorColor: Color {
        Color.semanticError
    }
    
    /// Info color
    var infoColor: Color {
        Color.semanticInfo
    }
    
    // MARK: - Animation
    
    /// Animation style based on reduced motion preference
    var animationStyle: Animation? {
        if reducedMotion {
            return nil
        }
        return .default
    }
    
    /// Spring animation with reduced motion support
    func springAnimation(response: Double = 0.3, dampingFraction: Double = 0.7) -> Animation? {
        if reducedMotion {
            return nil
        }
        return .spring(response: response, dampingFraction: dampingFraction)
    }
}

// MARK: - Environment Key

private struct ThemeManagerKey: EnvironmentKey {
    @MainActor
    static var defaultValue: ThemeManager {
        ThemeManager()
    }
}

extension EnvironmentValues {
    var themeManager: ThemeManager {
        get { self[ThemeManagerKey.self] }
        set { self[ThemeManagerKey.self] = newValue }
    }
}
