//
//  UIExtensions.swift
//  Disability Advocacy
//
//  Reusable UI and text styling extensions
//

import SwiftUI

// MARK: - iMessage Style Pill Button
struct PillButton: View {
    let title: String
    let icon: String?
    let isSelected: Bool
    let action: () -> Void
    
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var isPressed = false
    
    init(
        title: String,
        icon: String? = nil,
        isSelected: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.isSelected = isSelected
        self.action = action
    }
    
    var body: some View {
        Button(action: {
            HapticManager.selection()
            action()
        }) {
            HStack(spacing: 6) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 14, weight: .medium))
                }
                Text(title)
                    .font(.system(size: 15, weight: .medium))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(backgroundMaterial)
            .foregroundStyle(foregroundColor)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(borderColor, lineWidth: isSelected ? 1.5 : 0.5)
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(reduceMotion ? nil : .spring(response: 0.2, dampingFraction: 0.6), value: isPressed)
            .animation(reduceMotion ? nil : .spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        }
        .buttonStyle(.plain)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
    }
    
    private var backgroundMaterial: some View {
        Group {
            if isSelected {
                Capsule()
                    .fill(.ultraThinMaterial)
                    .background(
                        Capsule()
                            .fill(Color.accentColor.opacity(0.15))
                    )
            } else {
                Capsule()
                    .fill(.ultraThinMaterial)
                    .background(
                        Capsule()
                            .fill(Color.secondary.opacity(0.1))
                    )
            }
        }
    }
    
    private var foregroundColor: AnyShapeStyle {
        isSelected ? AnyShapeStyle(.tint) : AnyShapeStyle(.primary)
    }
    
    private var borderColor: Color {
        isSelected ? .accentColor.opacity(0.4) : .secondary.opacity(0.2)
    }
}

// MARK: - Enhanced Search Bar
// Note: EnhancedSearchBar is defined in Views/Components/EnhancedSearchBar.swift

// MARK: - Typography System
/// Legacy typography system for backward compatibility
/// New code should use TypographyTokens with ThemeManager for theme-aware fonts
enum AppTypography {
    // Display
    static var display: Font { .largeTitle.weight(.bold) }
    static var displayLarge: Font { .system(.largeTitle, design: .default).weight(.bold) }

    // Headings
    static var h1: Font { .title.weight(.bold) }
    static var h2: Font { .title2.weight(.bold) }
    static var h3: Font { .title3.weight(.semibold) }
    static var h4: Font { .headline.weight(.semibold) }

    // Body
    static var bodyLarge: Font { .body.weight(.medium) }
    static var body: Font { .body }
    static var bodySmall: Font { .subheadline }

    // Labels
    static var label: Font { .subheadline.weight(.medium) }
    static var labelSmall: Font { .caption.weight(.medium) }
    static var caption: Font { .caption }
    static var captionSmall: Font { .caption2 }
    
    // MARK: - Theme-Aware Typography
    
    /// Get theme-aware typography token
    @MainActor
    static func token(_ token: TypographyToken, theme: ThemeManager) -> Font {
        switch token {
        case .displayLarge:
            return TypographyTokens.displayLarge(theme: theme)
        case .displayMedium:
            return TypographyTokens.displayMedium(theme: theme)
        case .headingLarge:
            return TypographyTokens.headingLarge(theme: theme)
        case .headingMedium:
            return TypographyTokens.headingMedium(theme: theme)
        case .headingSmall:
            return TypographyTokens.headingSmall(theme: theme)
        case .headingXSmall:
            return TypographyTokens.headingXSmall(theme: theme)
        case .bodyLarge:
            return TypographyTokens.bodyLarge(theme: theme)
        case .bodyMedium:
            return TypographyTokens.bodyMedium(theme: theme)
        case .bodySmall:
            return TypographyTokens.bodySmall(theme: theme)
        case .labelLarge:
            return TypographyTokens.labelLarge(theme: theme)
        case .labelMedium:
            return TypographyTokens.labelMedium(theme: theme)
        case .labelSmall:
            return TypographyTokens.labelSmall(theme: theme)
        case .caption:
            return TypographyTokens.caption(theme: theme)
        case .captionSmall:
            return TypographyTokens.captionSmall(theme: theme)
        }
    }
}

/// Typography token enum for type-safe font selection
enum TypographyToken {
    case displayLarge
    case displayMedium
    case headingLarge
    case headingMedium
    case headingSmall
    case headingXSmall
    case bodyLarge
    case bodyMedium
    case bodySmall
    case labelLarge
    case labelMedium
    case labelSmall
    case caption
    case captionSmall
}

// MARK: - Typography Modifiers
struct TypographyModifier: ViewModifier {
    let font: Font
    let color: Color
    var weight: Font.Weight? = nil
    
    func body(content: Content) -> some View {
        content
            .font(font)
            .foregroundStyle(color)
            .fontWeight(weight)
    }
}

// MARK: - Text Styling Extensions
extension Text {
    /// Applies primary text styling
    func primaryTextStyle() -> Text {
        self.foregroundStyle(Color.primaryText)
    }
    
    /// Applies secondary text styling
    func secondaryTextStyle() -> Text {
        self.foregroundStyle(Color.secondaryText)
    }
    
    /// Applies section header styling
    func sectionHeaderStyle() -> Text {
        self.font(.title3).fontWeight(.bold).foregroundStyle(Color.primaryText)
    }
    
    /// Applies body text with line spacing
    func bodyTextStyle() -> some View {
        self.font(.body).foregroundStyle(Color.secondaryText).lineSpacing(4)
    }

    // Typography System Helpers
    func primaryHeading() -> some View {
        self.modifier(TypographyModifier(font: AppTypography.h1, color: .primaryText, weight: .bold))
    }
    
    func secondaryHeading() -> some View {
        self.modifier(TypographyModifier(font: AppTypography.h2, color: .primaryText, weight: .bold))
    }
    
    func tertiaryHeading() -> some View {
        self.modifier(TypographyModifier(font: AppTypography.h3, color: .primaryText, weight: .semibold))
    }
    
    func sectionTitle() -> some View {
        self.modifier(TypographyModifier(font: AppTypography.h4, color: .primaryText, weight: .semibold))
    }
    
    func emphasizedBody() -> some View {
        self.modifier(TypographyModifier(font: AppTypography.bodyLarge, color: .primaryText, weight: .medium))
    }
    
    func standardBody() -> some View {
        self.modifier(TypographyModifier(font: AppTypography.body, color: .primaryText))
    }
    
    // Note: secondaryBody() for View is defined in UIExtensions.swift
    
    func captionText() -> some View {
        self.modifier(TypographyModifier(font: AppTypography.caption, color: .tertiaryText))
    }
    
    // Note: emphasizedCaption() is defined in Text extension above (line 187)
    
    func labelText() -> some View {
        self.modifier(TypographyModifier(font: AppTypography.label, color: .primaryText, weight: .medium))
    }
}

// MARK: - View Layout & Typography Extensions
extension View {
    // Typography System Helpers
    func primaryHeading() -> some View {
        self.modifier(TypographyModifier(font: AppTypography.h1, color: .primaryText, weight: .bold))
    }
    
    func secondaryHeading() -> some View {
        self.modifier(TypographyModifier(font: AppTypography.h2, color: .primaryText, weight: .bold))
    }
    
    func tertiaryHeading() -> some View {
        self.modifier(TypographyModifier(font: AppTypography.h3, color: .primaryText, weight: .semibold))
    }
    
    func sectionTitle() -> some View {
        self.modifier(TypographyModifier(font: AppTypography.h4, color: .primaryText, weight: .semibold))
    }
    
    func emphasizedBody() -> some View {
        self.modifier(TypographyModifier(font: AppTypography.bodyLarge, color: .primaryText, weight: .medium))
    }
    
    func standardBody() -> some View {
        self.modifier(TypographyModifier(font: AppTypography.body, color: .primaryText))
    }
    
    // Note: secondaryBody() is defined in UIExtensions.swift
    // Note: captionText() is defined in Text extension above (line 183)
    // Note: emphasizedCaption() is defined in Text extension above
    
    func labelText() -> some View {
        self.modifier(TypographyModifier(font: AppTypography.label, color: .primaryText, weight: .medium))
    }

    /// Applies standard screen horizontal padding
    func screenHorizontalPadding() -> some View {
        self.padding(.horizontal, LayoutConstants.screenHorizontalPadding)
    }
    
    /// Applies standard content padding
    func contentPadding() -> some View {
        self.padding(LayoutConstants.paddingXL)
    }
    
    /// Applies standard section spacing
    func sectionSpacing() -> some View {
        self.padding(.bottom, LayoutConstants.sectionGap)
    }
    
    /// Applies button styling with standard height and corner radius
    func buttonStyle(height: CGFloat = LayoutConstants.buttonHeight) -> some View {
        self
            .frame(height: height)
            .frame(maxWidth: .infinity)
            .cornerRadius(LayoutConstants.buttonCornerRadius)
    }
}
