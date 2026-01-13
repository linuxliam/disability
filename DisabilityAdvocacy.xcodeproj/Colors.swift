import SwiftUI

extension Color {
    // Backgrounds
    static var appBackground: Color {
        #if os(macOS)
        return Color(NSColor.windowBackgroundColor)
        #else
        return Color(UIColor.systemBackground)
        #endif
    }
    static var groupedBackground: Color {
        #if os(macOS)
        return Color(NSColor.controlBackgroundColor)
        #else
        return Color(UIColor.systemGroupedBackground)
        #endif
    }
    static var cardBackground: Color {
        #if os(macOS)
        return Color(NSColor.textBackgroundColor)
        #else
        return Color(UIColor.secondarySystemBackground)
        #endif
    }
    static var secondaryCardBackground: Color {
        cardBackground.opacity(0.9)
    }
    
    // Text
    static var primaryText: Color { .primary }
    static var secondaryText: Color { .secondary }
    static var tertiaryText: Color { .secondary.opacity(0.7) }
    
    // Brand/triad
    static var triadPrimary: Color { .blue }
    static var triadSecondary: Color { .green }
    static var triadTertiary: Color { .purple }
    
    // Semantic
    static var semanticSuccess: Color { .green }
    static var semanticError: Color { .red }
    static var semanticWarning: Color { .orange }
    static var semanticInfo: Color { .blue }
    
    static var semanticSuccessBackground: Color { semanticSuccess.opacity(0.12) }
    static var semanticErrorBackground: Color { semanticError.opacity(0.12) }
    static var semanticWarningBackground: Color { semanticWarning.opacity(0.12) }
    static var semanticInfoBackground: Color { semanticInfo.opacity(0.12) }
}
