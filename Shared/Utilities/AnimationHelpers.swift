//
//  AnimationHelpers.swift
//  Disability Advocacy iOS
//
//  Standardized animations and transitions
//

import SwiftUI

extension Animation {
    /// Smooth spring animation for general UI transitions
    static var appSpring: Animation {
        .spring(response: 0.35, dampingFraction: 0.75, blendDuration: 0)
    }
    
    /// Bouncy spring for important feedback
    static var appBounce: Animation {
        .spring(response: 0.45, dampingFraction: 0.6, blendDuration: 0)
    }
    
    /// Subtle ease-in-out for background transitions
    static var appEase: Animation {
        .easeInOut(duration: 0.25)
    }
}

extension View {
    /// Standard scaling button style
    func pressableStyle() -> some View {
        self.buttonStyle(PressableButtonStyle())
    }
    
    /// Conditional animation that respects reduce motion
    func respectsReducedMotion(_ animation: Animation = .appSpring, value: some Equatable) -> some View {
        #if os(iOS)
        return self.animation(UIAccessibility.isReduceMotionEnabled ? .none : animation, value: value)
        #else
        return self.animation(animation, value: value)
        #endif
    }
}

// MARK: - Reduce Motion Helper
struct RespectsReducedMotionModifier<Value: Equatable>: ViewModifier {
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    let animation: Animation
    let value: Value
    
    func body(content: Content) -> some View {
        content.animation(reduceMotion ? .none : animation, value: value)
    }
}

struct PressableButtonStyle: ButtonStyle {
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed && !reduceMotion ? 0.96 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .animation(reduceMotion ? .none : .appSpring, value: configuration.isPressed)
    }
}

/// A view modifier that adds a subtle entrance animation
struct EntranceAnimation: ViewModifier {
    @State private var hasAppeared = false
    let delay: Double
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    
    func body(content: Content) -> some View {
        content
            .offset(y: hasAppeared || reduceMotion ? 0 : 20)
            .opacity(hasAppeared || reduceMotion ? 1 : 0)
            .onAppear {
                withAnimation(.appSpring.delay(delay)) {
                    hasAppeared = true
                }
            }
    }
}

extension View {
    func entranceAnimation(delay: Double = 0) -> some View {
        self.modifier(EntranceAnimation(delay: delay))
    }
}

