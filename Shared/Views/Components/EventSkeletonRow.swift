import SwiftUI

struct EventSkeletonRow: View {
    var body: some View {
        HStack(spacing: 12) {
            VStack(spacing: 6) {
                SkeletonView().frame(width: 30, height: 16).cornerRadius(4)
                SkeletonView().frame(width: 30, height: 12).cornerRadius(4)
            }
            VStack(alignment: .leading, spacing: 6) {
                SkeletonView().frame(height: 12).cornerRadius(6)
                SkeletonView().frame(height: 10).cornerRadius(5)
            }
        }
        .padding(.vertical, 8)
        .accessibilityHidden(true)
    }
}
