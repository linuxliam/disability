//
//  AccessibilitySettings.swift
//  Disability Advocacy
//
//  User accessibility preferences
//
//  Note: This model is kept for backward compatibility.
//  New code should use ThemeManager for accessibility settings.
//

import SwiftUI

/// Legacy accessibility settings model
/// 
/// **Deprecated:** Use `ThemeManager` for accessibility settings instead.
/// This struct is kept for backward compatibility during migration.
struct AccessibilitySettings {
    var highContrast: Bool = false
    var largeText: Bool = false
    var reducedMotion: Bool = false
    var screenReaderOptimized: Bool = false
    var customFontSize: CGFloat = 14.0

    init(highContrast: Bool = false, largeText: Bool = false, reducedMotion: Bool = false, screenReaderOptimized: Bool = false, customFontSize: CGFloat = 14.0) {
        self.highContrast = highContrast
        self.largeText = largeText
        self.reducedMotion = reducedMotion
        self.screenReaderOptimized = screenReaderOptimized
        self.customFontSize = customFontSize
    }

    static let defaultSettings = AccessibilitySettings()
    
    /// Create from ThemeManager
    @MainActor
    init(themeManager: ThemeManager) {
        self.highContrast = themeManager.highContrast
        self.largeText = themeManager.customFontSize > 1.0
        self.reducedMotion = themeManager.reducedMotion
        self.screenReaderOptimized = themeManager.screenReaderOptimized
        self.customFontSize = themeManager.customFontSize * 14.0
    }
}


