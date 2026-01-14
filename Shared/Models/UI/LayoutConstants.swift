import SwiftUI

/// Layout constants for consistent spacing and sizing
/// These values are theme-aware and can be adjusted based on accessibility settings
enum LayoutConstants {
    // MARK: - Spacing Scale
    
    /// Extra small spacing (4pt)
    static let spacingXS: CGFloat = 4
    /// Small spacing (8pt)
    static let spacingS: CGFloat = 8
    /// Medium spacing (12pt)
    static let spacingM: CGFloat = 12
    /// Large spacing (16pt)
    static let spacingL: CGFloat = 16
    /// Extra large spacing (20pt)
    static let spacingXL: CGFloat = 20
    /// Extra extra large spacing (28pt)
    static let spacingXXL: CGFloat = 28
    
    // MARK: - Padding Scale
    
    /// Extra small padding (6pt)
    static let paddingXS: CGFloat = 6
    /// Small padding (10pt)
    static let paddingS: CGFloat = 10
    /// Medium padding (16pt)
    static let paddingM: CGFloat = 16
    /// Large padding (20pt)
    static let paddingL: CGFloat = 20
    /// Extra large padding (24pt)
    static let paddingXL: CGFloat = 24
    /// Extra extra large padding (32pt)
    static let paddingXXL: CGFloat = 32
    
    // MARK: - Section Spacing
    
    /// Spacing for section headers
    static let sectionHeaderSpacing: CGFloat = 12
    /// Gap between sections
    static let sectionGap: CGFloat = 20
    
    // MARK: - Card Constants
    
    /// Corner radius for cards
    static let cardCornerRadius: CGFloat = 12
    /// Padding inside cards
    static let cardPadding: CGFloat = 16
    /// Gap between cards
    static let cardGap: CGFloat = 16
    /// Shadow radius for cards
    static let cardShadowRadius: CGFloat = 10
    
    // MARK: - Button Constants
    
    /// Corner radius for buttons
    static let buttonCornerRadius: CGFloat = 12
    /// Standard button height
    static let buttonHeight: CGFloat = 44
    /// Minimum touch target size (accessibility)
    static let minimumTouchTarget: CGFloat = 44
    
    // MARK: - Icon Sizes
    
    /// Extra large icon size
    static let iconSizeXL: CGFloat = 28
    /// Large icon size
    static let iconSizeL: CGFloat = 24
    /// Medium icon size
    static let iconSizeM: CGFloat = 20
    /// Small icon size
    static let iconSizeS: CGFloat = 16
    
    // MARK: - Screen Constants
    
    /// Horizontal padding for screen edges
    static let screenHorizontalPadding: CGFloat = 16
    /// Maximum content width for wide layouts
    static let contentMaxWidth: CGFloat = 1100
    
    // MARK: - Theme-Aware Spacing
    
    // Note: ThemeManager is in the same module (Shared) and accessible without explicit import
    // Both LayoutConstants and ThemeManager are part of the Shared module
    
    /// Get spacing value adjusted for theme
    @MainActor
    static func spacing(_ base: CGFloat, theme: ThemeManager) -> CGFloat {
        // Apply accessibility multiplier if needed
        if theme.screenReaderOptimized {
            return base * 1.2
        }
        return base
    }
    
    /// Get padding value adjusted for theme
    @MainActor
    static func padding(_ base: CGFloat, theme: ThemeManager) -> CGFloat {
        // Apply accessibility multiplier if needed
        if theme.screenReaderOptimized {
            return base * 1.2
        }
        return base
    }
}

