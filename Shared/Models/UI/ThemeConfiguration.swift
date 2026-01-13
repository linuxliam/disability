//
//  ThemeConfiguration.swift
//  Disability Advocacy
//
//  Theme configuration model for managing theme settings
//

import SwiftUI

/// Theme configuration model that defines theme settings
struct ThemeConfiguration {
    /// Color scheme preference (nil = system default)
    var colorScheme: ColorScheme? = nil
    
    /// High contrast mode enabled
    var highContrast: Bool = false
    
    /// Reduced motion enabled
    var reducedMotion: Bool = false
    
    /// Custom font size multiplier (1.0 = default)
    var customFontSize: CGFloat = 1.0
    
    /// Screen reader optimized mode
    var screenReaderOptimized: Bool = false
    
    /// Default configuration
    static let `default` = ThemeConfiguration()
    
    /// High contrast configuration
    static let highContrast = ThemeConfiguration(
        highContrast: true,
        reducedMotion: false,
        customFontSize: 1.0,
        screenReaderOptimized: false
    )
    
    /// Accessibility-focused configuration
    static let accessibility = ThemeConfiguration(
        highContrast: true,
        reducedMotion: true,
        customFontSize: 1.2,
        screenReaderOptimized: true
    )
}
