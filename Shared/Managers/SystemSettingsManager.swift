//
//  SystemSettingsManager.swift
//  Disability Advocacy iOS
//
//  Manages and respects user's system settings
//

import SwiftUI
#if os(iOS)
import UIKit
#endif

/// Manager for system-level settings and preferences
/// Uses native SwiftUI environment values where possible, falls back to UIKit for accessibility settings
/// Note: UIAccessibility properties are implicitly main-actor isolated, so static properties
/// are marked @MainActor to properly access them
struct SystemSettingsManager {
    /// Check if system has reduced motion enabled (native SwiftUI via UIAccessibility)
    @MainActor
    static var isReduceMotionEnabled: Bool {
        #if os(iOS)
        return UIAccessibility.isReduceMotionEnabled
        #else
        return false // macOS handled via environment or NSAccessibility if needed
        #endif
    }
    
    /// Check if system has increased contrast enabled
    @MainActor
    static var isIncreaseContrastEnabled: Bool {
        #if os(iOS)
        return UIAccessibility.isDarkerSystemColorsEnabled
        #else
        return false
        #endif
    }
    
    /// Check if system has bold text enabled
    @MainActor
    static var isBoldTextEnabled: Bool {
        #if os(iOS)
        return UIAccessibility.isBoldTextEnabled
        #else
        return false
        #endif
    }
    
    /// Check if VoiceOver is running
    @MainActor
    static var isVoiceOverRunning: Bool {
        #if os(iOS)
        return UIAccessibility.isVoiceOverRunning
        #else
        return false
        #endif
    }
    
    /// Check if Switch Control is enabled
    @MainActor
    static var isSwitchControlRunning: Bool {
        #if os(iOS)
        return UIAccessibility.isSwitchControlRunning
        #else
        return false
        #endif
    }
}


