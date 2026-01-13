import SwiftUI

// MARK: - View Modifiers & Helpers
extension View {
    func appScreenChrome() -> some View {
        self.background(Color.groupedBackground)
    }
    
    func appListBackground() -> some View {
        #if os(iOS)
        return self
            .scrollContentBackground(.hidden)
            .background(Color.groupedBackground)
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
    
    func appCard(padding: CGFloat = LayoutConstants.cardPadding, elevation: CardElevation = .standard) -> some View {
        #if canImport(SwiftUI)
        return self.modifier(CardModifier(cornerRadius: LayoutConstants.cardCornerRadius, padding: padding, elevation: elevation))
        #else
        return self
        #endif
    }
    
    // Text styles
    func secondaryBody() -> some View {
        self.font(.subheadline).foregroundStyle(Color.secondaryText)
    }
    
    func captionText() -> some View {
        self.font(.caption).foregroundStyle(Color.secondaryText)
    }
    
    func emphasizedCaption() -> some View {
        self.font(.caption.weight(.semibold)).foregroundStyle(Color.secondaryText)
    }
}
