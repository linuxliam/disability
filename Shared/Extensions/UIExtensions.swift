import SwiftUI

// MARK: - Theme-Aware View Modifiers

struct AppScreenChromeModifier: ViewModifier {
    @Environment(\.themeManager) private var themeManager
    
    func body(content: Content) -> some View {
        content
            .background(ColorTokens.groupedBackground(theme: themeManager))
    }
}

struct AppListBackgroundModifier: ViewModifier {
    @Environment(\.themeManager) private var themeManager
    
    func body(content: Content) -> some View {
        content
            .background(ColorTokens.groupedBackground(theme: themeManager))
    }
}

// MARK: - View Modifiers & Helpers
extension View {
    @MainActor
    func appScreenChrome() -> some View {
        self.modifier(AppScreenChromeModifier())
    }
    
    @MainActor
    func appListBackground() -> some View {
        #if os(iOS)
        return self
            .scrollContentBackground(.hidden)
            .modifier(AppListBackgroundModifier())
        #else
        return self.background(Color.clear)
        #endif
    }
    
    func appContentFrame() -> some View {
        self
            .frame(maxWidth: AdaptiveLayout.contentMaxWidth(for: .regular))
            .frame(maxWidth: .infinity)
    }
    
    func adaptiveContentFrame() -> some View {
        self
            .padding(.horizontal, LayoutConstants.screenHorizontalPadding)
            .frame(maxWidth: AdaptiveLayout.contentMaxWidth(for: .regular))
            .frame(maxWidth: .infinity)
    }
    
    func appNavigationChrome() -> some View {
        self
    }
    
    func platformInlineNavigationTitle() -> some View {
        #if os(iOS)
        return self.navigationBarTitleDisplayMode(.inline)
        #else
        return self
        #endif
    }
    
    @MainActor
    func appCard(padding: CGFloat = LayoutConstants.cardPadding, elevation: CardElevation = .standard) -> some View {
        #if canImport(SwiftUI)
        return self.modifier(CardModifier(cornerRadius: LayoutConstants.cardCornerRadius, padding: padding, elevation: elevation))
        #else
        return self
        #endif
    }
    
    // Text styles (theme-aware)
    @MainActor
    func secondaryBody() -> some View {
        self.font(.subheadline)
            .foregroundStyle(Color.secondaryText) // Keep legacy for now, will migrate gradually
    }
    
    @MainActor
    func captionText() -> some View {
        self.font(.caption)
            .foregroundStyle(Color.secondaryText) // Keep legacy for now, will migrate gradually
    }
    
    @MainActor
    func emphasizedCaption() -> some View {
        self.font(.caption.weight(.semibold))
            .foregroundStyle(Color.secondaryText) // Keep legacy for now, will migrate gradually
    }
}

