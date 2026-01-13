import SwiftUI

enum AdaptiveLayout {
    enum SizeClass {
        case compact
        case regular
    }
    
    static func gridColumns(for sizeClass: SizeClass, availableWidth: CGFloat, minItemWidth: CGFloat = AppConstants.Layout.gridItemMinimumWidth) -> [GridItem] {
        let columnsCount = max(Int(availableWidth / minItemWidth), 1)
        return Array(repeating: GridItem(.flexible(), spacing: LayoutConstants.cardGap), count: columnsCount)
    }
    
    static func contentMaxWidth(for sizeClass: SizeClass) -> CGFloat {
        switch sizeClass {
        case .compact: return 700
        case .regular: return 900
        }
    }
}
