import SwiftUI

struct AppRow: View {
    @Environment(\.themeManager) private var themeManager
    
    let title: String
    var subtitle: String? = nil
    var systemImage: String? = nil
    var trailingText: String? = nil
    
    var body: some View {
        HStack(spacing: 12) {
            if let icon = systemImage {
                Image(systemName: icon)
                    .foregroundStyle(.tint)
                    .frame(width: 24)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.body.weight(.semibold))
                    .foregroundStyle(ColorTokens.textPrimary(theme: themeManager))
                if let subtitle = subtitle, !subtitle.isEmpty {
                    Text(subtitle)
                        .lineLimit(2)
                        .font(.subheadline)
                        .foregroundStyle(ColorTokens.textSecondary(theme: themeManager))
                }
            }
            Spacer()
            if let trailing = trailingText {
                Text(trailing)
                    .font(.caption.weight(.bold))
                    .foregroundStyle(ColorTokens.textTertiary(theme: themeManager))
            }
        }
        .padding(.vertical, 6)
    }
}
