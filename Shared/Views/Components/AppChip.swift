import SwiftUI

struct AppChip: View {
    enum Style {
        case primary, secondary, tertiary
    }
    
    let text: String
    let style: Style
    
    init(text: String, style: Style = .primary) {
        self.text = text
        self.style = style
    }
    
    var body: some View {
        Text(text)
            .font(.caption2.weight(.bold))
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(background)
            .foregroundStyle(foreground)
            .cornerRadius(8)
    }
    
    private var background: Color {
        switch style {
        case .primary: return .triadPrimary.opacity(0.12)
        case .secondary: return .triadSecondary.opacity(0.12)
        case .tertiary: return .triadTertiary.opacity(0.12)
        }
    }
    
    private var foreground: Color {
        switch style {
        case .primary: return .triadPrimary
        case .secondary: return .triadSecondary
        case .tertiary: return .triadTertiary
        }
    }
}
