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

// MARK: - Enhanced Search Bar with iMessage Style
struct EnhancedSearchBar: View {
    @Binding var text: String
    let placeholder: String
    
    @FocusState private var isFocused: Bool
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    init(text: Binding<String>, placeholder: String = String(localized: "Search...")) {
        self._text = text
        self.placeholder = placeholder
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.secondary)
            
            TextField(placeholder, text: $text)
                .textFieldStyle(.plain)
                .font(.system(size: 17))
                .focused($isFocused)
                .accessibilityLabel(placeholder)
                .onChange(of: text) { oldValue, newValue in
                    if !newValue.isEmpty {
                        AppLogger.tap("Search Field", context: "Text entered: '\(newValue)'")
                    }
                }
            
            if !text.isEmpty {
                Button(action: {
                    HapticManager.light()
                    text = ""
                    isFocused = false
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 16))
                        .foregroundStyle(.secondary)
                }
                .accessibilityLabel(String(localized: "Clear search"))
                .transition(.scale.combined(with: .opacity))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(
            Capsule()
                .fill(.ultraThinMaterial)
                .background(
                    Capsule()
                        .fill(Color.secondary.opacity(0.1))
                )
        )
        .overlay(
            Capsule()
                .stroke(isFocused ? AnyShapeStyle(.tint.opacity(0.3)) : AnyShapeStyle(Color.clear), lineWidth: 1.5)
        )
        .animation(reduceMotion ? nil : .spring(response: 0.2, dampingFraction: 0.7), value: isFocused)
        .animation(reduceMotion ? nil : .spring(response: 0.2, dampingFraction: 0.7), value: text.isEmpty)
    }
}

// MARK: - Typography System
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
        self.foregroundStyle(.primaryText)
    }
    
    /// Applies secondary text styling
    func secondaryTextStyle() -> Text {
        self.foregroundStyle(.secondaryText)
    }
    
    /// Applies section header styling
    func sectionHeaderStyle() -> Text {
        self.font(.title3).fontWeight(.bold).foregroundStyle(.primaryText)
    }
    
    /// Applies body text with line spacing
    func bodyTextStyle() -> some View {
        self.font(.body).foregroundStyle(.secondaryText).lineSpacing(LayoutConstants.lineSpacing)
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
    
    func secondaryBody() -> some View {
        self.modifier(TypographyModifier(font: AppTypography.bodySmall, color: .secondaryText))
    }
    
    func captionText() -> some View {
        self.modifier(TypographyModifier(font: AppTypography.caption, color: .tertiaryText))
    }
    
    func emphasizedCaption() -> some View {
        self.modifier(TypographyModifier(font: AppTypography.caption.weight(.semibold), color: .secondaryText))
    }
    
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
    
    func secondaryBody() -> some View {
        self.modifier(TypographyModifier(font: AppTypography.bodySmall, color: .secondaryText))
    }
    
    func captionText() -> some View {
        self.modifier(TypographyModifier(font: AppTypography.caption, color: .tertiaryText))
    }
    
    func emphasizedCaption() -> some View {
        self.modifier(TypographyModifier(font: AppTypography.caption.weight(.semibold), color: .secondaryText))
    }
    
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
        self.padding(.bottom, LayoutConstants.sectionSpacing)
    }
    
    /// Applies button styling with standard height and corner radius
    func buttonStyle(height: CGFloat = LayoutConstants.buttonHeight) -> some View {
        self
            .frame(height: height)
            .frame(maxWidth: .infinity)
            .cornerRadius(LayoutConstants.buttonCornerRadius)
    }
}
