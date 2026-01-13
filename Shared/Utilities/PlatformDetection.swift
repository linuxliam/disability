//
//  PlatformDetection.swift
//  Disability Advocacy
//
//  Centralized platform detection and feature availability checks
//

import Foundation
import SwiftUI

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

/// Centralized platform detection utilities
enum PlatformDetection {
    /// Check if running on iOS
    static var isIOS: Bool {
        #if os(iOS)
        return true
        #else
        return false
        #endif
    }
    
    /// Check if running on macOS
    static var isMacOS: Bool {
        #if os(macOS)
        return true
        #else
        return false
        #endif
    }
    
    /// Get current platform name
    static var platformName: String {
        #if os(iOS)
        return "iOS"
        #elseif os(macOS)
        return "macOS"
        #else
        return "Unknown"
        #endif
    }
    
    /// Check iOS version (returns 0.0 on macOS)
    static var iOSVersion: (major: Int, minor: Int, patch: Int) {
        #if os(iOS)
        let version = UIDevice.current.systemVersion
        let components = version.split(separator: ".").compactMap { Int($0) }
        return (
            major: components[safe: 0] ?? 0,
            minor: components[safe: 1] ?? 0,
            patch: components[safe: 2] ?? 0
        )
        #else
        return (major: 0, minor: 0, patch: 0)
        #endif
    }
    
    /// Check macOS version (returns 0.0 on iOS)
    static var macOSVersion: (major: Int, minor: Int, patch: Int) {
        #if os(macOS)
        let version = ProcessInfo.processInfo.operatingSystemVersion
        return (
            major: version.majorVersion,
            minor: version.minorVersion,
            patch: version.patchVersion
        )
        #else
        return (major: 0, minor: 0, patch: 0)
        #endif
    }
    
    /// Check if feature is available on current platform
    static func isFeatureAvailable(_ feature: PlatformFeature) -> Bool {
        switch feature {
        case .hapticFeedback:
            return isIOS
        case .shareSheet:
            return true // Available on both via different APIs
        case .filePicker:
            return isMacOS
        case .systemSettings:
            return true // Available on both via different APIs
        case .notifications:
            return true // Available on both
        }
    }
    
    /// Get appropriate list style for current platform
    static var defaultListStyle: some ListStyle {
        #if os(iOS)
        return .insetGrouped
        #else
        return .sidebar
        #endif
    }
}

/// Platform features that may not be available on all platforms
enum PlatformFeature {
    case hapticFeedback
    case shareSheet
    case filePicker
    case systemSettings
    case notifications
}

/// Safe array subscript extension
private extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
