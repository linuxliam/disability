//
//  HapticManager.swift
//  Disability Advocacy
//
//  Provides haptic feedback for iOS (no-op on macOS)
//

#if os(iOS)
import UIKit

@MainActor
struct HapticManager {
    // Light haptic feedback for subtle interactions
    static func light() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    // Medium haptic feedback for standard interactions
    static func medium() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    // Heavy haptic feedback for important actions
    static func heavy() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
    }
    
    // Success haptic feedback
    static func success() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    // Error haptic feedback
    static func error() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
    
    // Warning haptic feedback
    static func warning() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
    }
    
    // Selection haptic feedback for picker-like interactions
    static func selection() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
}
#else
struct HapticManager {
    static func light() {}
    static func medium() {}
    static func heavy() {}
    static func success() {}
    static func error() {}
    static func warning() {}
    static func selection() {}
}
#endif
