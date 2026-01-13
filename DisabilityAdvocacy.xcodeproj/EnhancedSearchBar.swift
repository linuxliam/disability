import SwiftUI

struct EnhancedSearchBar: View {
    @Binding var text: String
    var placeholder: String = ""
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondaryText)
            TextField(placeholder, text: $text)
                .textFieldStyle(.plain)
                .submitLabel(.search)
            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondaryText)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(String(localized: "Clear"))
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(Color.cardBackground, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.primary.opacity(0.06), lineWidth: 0.5)
        )
    }
}
