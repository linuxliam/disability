//
//  ButtonStyles.swift
//  Disability Advocacy
//
//  Unified button style system for consistent interactive elements
//

import SwiftUI

/// Button style variants for different use cases
enum AppButtonStyle {
    case primary
    case secondary
    case tertiary
    case destructive
    case ghost
}

/// Theme-aware button modifier
struct ThemedButtonModifier: ViewModifier {
    @Environment(\.themeManager) private var themeManager
    let style: AppButtonStyle
    var isEnabled: Bool = true
    var isLoading: Bool = false
    
    func body(content: Content) -> some View {
        content
            .font(TypographyTokens.labelLarge(theme: themeManager))
            .foregroundStyle(foregroundColor)
            .frame(height: LayoutConstants.buttonHeight)
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .cornerRadius(LayoutConstants.buttonCornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: LayoutConstants.buttonCornerRadius)
                    .stroke(borderColor, lineWidth: borderWidth)
            )
            .opacity(isEnabled ? 1.0 : 0.6)
            .disabled(!isEnabled || isLoading)
            .overlay {
                if isLoading {
                    ProgressView()
                        .tint(foregroundColor)
                }
            }
    }
    
    private var backgroundColor: Color {
        if !isEnabled {
            return ColorTokens.surfaceSecondary(theme: themeManager)
        }
        
        switch style {
        case .primary:
            return ColorTokens.brandPrimary(theme: themeManager)
        case .secondary:
            return ColorTokens.surfacePrimary(theme: themeManager)
        case .tertiary:
            return Color.clear
        case .destructive:
            return ColorTokens.semanticError(theme: themeManager)
        case .ghost:
            return Color.clear
        }
    }
    
    private var foregroundColor: Color {
        if !isEnabled {
            return ColorTokens.textTertiary(theme: themeManager)
        }
        
        switch style {
        case .primary:
            return .white
        case .secondary:
            return ColorTokens.brandPrimary(theme: themeManager)
        case .tertiary:
            return ColorTokens.brandPrimary(theme: themeManager)
        case .destructive:
            return .white
        case .ghost:
            return ColorTokens.textPrimary(theme: themeManager)
        }
    }
    
    private var borderColor: Color {
        if !isEnabled {
            return ColorTokens.borderSecondary(theme: themeManager)
        }
        
        switch style {
        case .primary, .destructive:
            return Color.clear
        case .secondary:
            return ColorTokens.brandPrimary(theme: themeManager).opacity(0.3)
        case .tertiary:
            return ColorTokens.brandPrimary(theme: themeManager)
        case .ghost:
            return Color.clear
        }
    }
    
    private var borderWidth: CGFloat {
        switch style {
        case .primary, .destructive, .ghost:
            return 0
        case .secondary, .tertiary:
            return 1.5
        }
    }
}

/// Icon button style modifier
struct IconButtonModifier: ViewModifier {
    @Environment(\.themeManager) private var themeManager
    let style: AppButtonStyle
    var size: CGFloat = 44
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: size * 0.4))
            .foregroundStyle(foregroundColor)
            .frame(width: size, height: size)
            .background(backgroundColor)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(borderColor, lineWidth: borderWidth)
            )
    }
    
    private var backgroundColor: Color {
        switch style {
        case .primary:
            return ColorTokens.brandPrimary(theme: themeManager).opacity(0.1)
        case .secondary:
            return ColorTokens.surfacePrimary(theme: themeManager)
        case .tertiary:
            return Color.clear
        case .destructive:
            return ColorTokens.semanticError(theme: themeManager).opacity(0.1)
        case .ghost:
            return Color.clear
        }
    }
    
    private var foregroundColor: Color {
        switch style {
        case .primary:
            return ColorTokens.brandPrimary(theme: themeManager)
        case .secondary:
            return ColorTokens.textPrimary(theme: themeManager)
        case .tertiary:
            return ColorTokens.brandPrimary(theme: themeManager)
        case .destructive:
            return ColorTokens.semanticError(theme: themeManager)
        case .ghost:
            return ColorTokens.textPrimary(theme: themeManager)
        }
    }
    
    private var borderColor: Color {
        switch style {
        case .primary, .destructive, .ghost:
            return Color.clear
        case .secondary:
            return ColorTokens.borderPrimary(theme: themeManager)
        case .tertiary:
            return ColorTokens.brandPrimary(theme: themeManager)
        }
    }
    
    private var borderWidth: CGFloat {
        switch style {
        case .primary, .destructive, .ghost:
            return 0
        case .secondary, .tertiary:
            return 1
        }
    }
}

// MARK: - View Extensions

extension View {
    /// Apply themed button style
    @MainActor
    func buttonStyle(_ style: AppButtonStyle, isEnabled: Bool = true, isLoading: Bool = false) -> some View {
        self.modifier(ThemedButtonModifier(style: style, isEnabled: isEnabled, isLoading: isLoading))
    }
    
    /// Apply icon button style
    @MainActor
    func iconButtonStyle(_ style: AppButtonStyle, size: CGFloat = 44) -> some View {
        self.modifier(IconButtonModifier(style: style, size: size))
    }
}

// MARK: - Convenience Button Views

/// Themed button with built-in styling
struct ThemedButton: View {
    @Environment(\.themeManager) private var themeManager
    
    let title: String
    let style: AppButtonStyle
    var icon: String? = nil
    var isEnabled: Bool = true
    var isLoading: Bool = false
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            if let animation = themeManager.animationStyle {
                withAnimation(animation) {
                    action()
                }
            } else {
                action()
            }
        }) {
            HStack(spacing: 8) {
                if isLoading {
                    ProgressView()
                        .tint(style == .primary || style == .destructive ? .white : nil)
                } else if let icon = icon {
                    Image(systemName: icon)
                }
                Text(title)
            }
        }
        .buttonStyle(style, isEnabled: isEnabled, isLoading: isLoading)
    }
}

/// Icon-only button
struct ThemedIconButton: View {
    @Environment(\.themeManager) private var themeManager
    
    let icon: String
    let style: AppButtonStyle
    var size: CGFloat = 44
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            if let animation = themeManager.animationStyle {
                withAnimation(animation) {
                    action()
                }
            } else {
                action()
            }
        }) {
            Image(systemName: icon)
        }
        .iconButtonStyle(style, size: size)
    }
}
