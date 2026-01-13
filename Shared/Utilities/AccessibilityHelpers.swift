//
//  AccessibilityHelpers.swift
//  Disability Advocacy iOS
//
//  Utilities for improving accessibility across the app
//

import SwiftUI

extension View {
    /// Apply a standardized accessibility heading trait
    func accessibilityHeading(_ level: Int = 1) -> some View {
        self.accessibilityAddTraits(.isHeader)
    }
    
    /// Group related elements for VoiceOver with a combined label
    func accessibilityCombinedGroup(label: String, hint: String? = nil) -> some View {
        self.accessibilityElement(children: .combine)
            .accessibilityLabel(label)
            .accessibilityHint(hint ?? "")
    }
    
    /// Make a view represent an interactive button with specific label and hint
    func accessibilityActionButton(label: String, hint: String? = nil) -> some View {
        self.accessibilityAddTraits(.isButton)
            .accessibilityLabel(label)
            .accessibilityHint(hint ?? "")
    }
}

/// Helper for announcing dynamic changes to VoiceOver users
struct AccessibilityAnnouncer {
    static func announce(_ message: String) {
        #if os(iOS)
        Task { @MainActor in
            UIAccessibility.post(notification: .announcement, argument: message)
        }
        #elseif os(macOS)
        // macOS equivalent if needed
        #endif
    }
}

/// A wrapper for views that should be hidden from VoiceOver but visible for sighted users
/// (e.g., purely decorative icons)
struct DecorativeIcon: View {
    let name: String
    var color: Color = .accentColor
    var size: CGFloat = 20
    
    var body: some View {
        Image(systemName: name)
            .font(.system(size: size))
            .foregroundStyle(color)
            .accessibilityHidden(true)
    }
}

