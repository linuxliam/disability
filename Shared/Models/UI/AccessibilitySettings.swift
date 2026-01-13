//
//  AccessibilitySettings.swift
//  Disability Advocacy
//
//  User accessibility preferences
//

import SwiftUI

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
}


