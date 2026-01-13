import SwiftUI

struct AppSectionHeader: View {
    let title: LocalizedStringKey
    let systemImage: String
    var subtitle: String?
    var actionTitle: LocalizedStringKey?
    var action: (() -> Void)?
    
    init(title: LocalizedStringKey, systemImage: String, subtitle: String? = nil, actionTitle: LocalizedStringKey? = nil, action: (() -> Void)? = nil) {
        self.title = title
        self.systemImage = systemImage
        self.subtitle = subtitle
        self.actionTitle = actionTitle
        self.action = action
    }
    
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Label {
                VStack(alignment: .leading, spacing: 2) {
                    Text(title).font(.subheadline.weight(.bold))
                    if let subtitle = subtitle {
                        Text(subtitle).font(.caption).foregroundStyle(Color.secondaryText)
                    }
                }
            } icon: {
                Image(systemName: systemImage).foregroundStyle(.tint)
            }
            Spacer()
            if let actionTitle, let action {
                Button(actionTitle, action: action)
                    .font(.caption.weight(.semibold))
            }
        }
        .padding(.vertical, 4)
    }
}
