//
//  AppComponents.swift
//  Disability Advocacy
//
//  Shared UI components + styles to keep iOS/macOS consistent.
//

import SwiftUI

// MARK: - Chips / Tags

struct AppChip: View {
    enum Style {
        case neutral
        case accent
        case primary
        case secondary
        case tertiary
        case success
        case warning
        case error
    }

    let text: String
    var style: Style = .accent

    var body: some View {
        Text(text)
            .font(.caption2.weight(.semibold))
            .foregroundStyle(foreground)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(background, in: Capsule())
            .overlay(
                Capsule().strokeBorder(border, lineWidth: 0.5)
            )
            .accessibilityLabel(Text(text))
    }

    private var foreground: Color {
        switch style {
        case .neutral: return .secondary
        case .accent: return .accentColor
        case .primary: return .triadPrimary
        case .secondary: return .triadSecondary
        case .tertiary: return .triadTertiary
        case .success: return .semanticSuccess
        case .warning: return .semanticWarning
        case .error: return .semanticError
        }
    }

    private var background: Color {
        switch style {
        case .neutral: return Color.secondary.opacity(0.15)
        case .accent: return Color.accentColor.opacity(0.18)
        case .primary: return Color.triadPrimary.opacity(0.18)
        case .secondary: return Color.triadSecondary.opacity(0.18)
        case .tertiary: return Color.triadTertiary.opacity(0.18)
        case .success: return Color.semanticSuccessBackground.opacity(1.5) // Effectively ~0.27
        case .warning: return Color.semanticWarningBackground.opacity(1.5)
        case .error: return Color.semanticErrorBackground.opacity(1.5)
        }
    }

    private var border: Color {
        switch style {
        case .neutral: return Color.secondary.opacity(0.25)
        case .accent: return Color.accentColor.opacity(0.30)
        case .primary: return Color.triadPrimary.opacity(0.30)
        case .secondary: return Color.triadSecondary.opacity(0.30)
        case .tertiary: return Color.triadTertiary.opacity(0.30)
        case .success: return Color.semanticSuccess.opacity(0.30)
        case .warning: return Color.semanticWarning.opacity(0.30)
        case .error: return Color.semanticError.opacity(0.30)
        }
    }
}

// MARK: - Section Header

struct AppSectionHeader: View {
    let title: LocalizedStringKey
    var systemImage: String? = nil
    var subtitle: LocalizedStringKey? = nil
    var actionTitle: LocalizedStringKey? = nil
    var action: (() -> Void)? = nil

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: LayoutConstants.spacingS) {
            if let systemImage {
                Image(systemName: systemImage)
                    .font(.body.weight(.bold))
                    .foregroundStyle(.tint)
                    .accessibilityHidden(true)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(.secondary)
                    .textCase(.uppercase)

                if let subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .textCase(nil)
                }
            }

            Spacer(minLength: 8)

            if let actionTitle, let action {
                Button(actionTitle, action: action)
                    .font(.caption.weight(.bold))
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Native iOS Row Pattern

/// A lightweight, iOS-native row layout for `List`/`Form`.
/// Keeps consistent typography and spacing while still looking like standard iOS rows.
struct AppRow: View {
    let title: String
    var subtitle: String? = nil
    var systemImage: String? = nil
    var trailingText: String? = nil
    var trailingSystemImage: String? = nil

    var body: some View {
        HStack(spacing: 12) {
            if let systemImage {
                Image(systemName: systemImage)
                    .foregroundStyle(.tint)
                    .frame(width: 22)
                    .accessibilityHidden(true)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.body.weight(.semibold))
                    .foregroundStyle(.primary)

                if let subtitle {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
            }

            Spacer(minLength: 0)

            if let trailingText {
                Text(trailingText)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            if let trailingSystemImage {
                Image(systemName: trailingSystemImage)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.tertiary)
                    .accessibilityHidden(true)
            }
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Native Empty State

/// A thin wrapper around `ContentUnavailableView` so empty states are consistent.
struct AppEmptyState: View {
    let title: LocalizedStringKey
    var systemImage: String
    var description: LocalizedStringKey? = nil

    var body: some View {
        if let description {
            ContentUnavailableView(title, systemImage: systemImage, description: Text(description))
        } else {
            ContentUnavailableView(title, systemImage: systemImage)
        }
    }
}

// MARK: - Common Toolbar Items

/// Standard profile button used across iOS screens (keeps placement + behavior consistent).
struct ProfileToolbarButton: View {
    @Environment(AppState.self) private var appState: AppState

    var body: some View {
        Button {
            HapticManager.light()
            appState.showProfile = true
        } label: {
            Image(systemName: "person.circle.fill")
        }
        .accessibilityLabel(String(localized: "Profile"))
    }
}

/// Standard dismiss button for sheets.
struct AppDismissButton: View {
    @Environment(\.dismiss) private var dismiss
    var title: LocalizedStringKey = "Done"

    var body: some View {
        Button(title) {
            dismiss()
        }
        .fontWeight(.semibold)
    }
}

// MARK: - Layout Scaffolds

/// A standard form section with an icon and title.
struct AppFormSection<Content: View>: View {
    let title: LocalizedStringKey
    var systemImage: String? = nil
    @ViewBuilder let content: Content

    var body: some View {
        Section {
            content
        } header: {
            Label(title, systemImage: systemImage ?? "")
                .labelStyle(.titleAndIcon)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)
                .textCase(nil) // Keep natural casing
        }
    }
}

// MARK: - Category Filter Button

struct AppCategoryFilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(isSelected ? .semibold : .regular)
                .foregroundStyle(isSelected ? .white : .primary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.accentColor : Color.secondary.opacity(0.2), in: Capsule())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Previews (guardrails)

#if DEBUG
struct AppComponents_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationStack {
                List {
                    Section {
                        AppSectionHeader(
                            title: "Recommended for You",
                            systemImage: "sparkles",
                            subtitle: "Based on your favorites",
                            actionTitle: "See all",
                            action: {}
                        )
                    }

                    Section {
                        AppRow(
                            title: "National Center on Disability and Journalism",
                            subtitle: "Resources for journalists covering disability issues, including style guides and best practices.",
                            systemImage: "graduationcap.fill",
                            trailingText: "Education",
                            trailingSystemImage: "chevron.right"
                        )
                    }

                    Section {
                        AppEmptyState(
                            title: "Nothing to show yet",
                            systemImage: "sparkles",
                            description: "Pull to refresh or check back soon."
                        )
                    }
                }
                .navigationTitle("Preview")
                .appScreenChrome()
            }
            .preferredColorScheme(.light)
            .previewDisplayName("Light")

            NavigationStack {
                List {
                    Section {
                        AppRow(
                            title: "Upcoming Event",
                            subtitle: "Community Center, Main St",
                            systemImage: "calendar",
                            trailingText: "Jan 13",
                            trailingSystemImage: "chevron.right"
                        )
                    }
                }
                .navigationTitle("Preview")
                .appScreenChrome()
            }
            .preferredColorScheme(.dark)
            .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
            .previewDisplayName("Dark + AXXXL")
        }
    }
}
#endif

// MARK: - Card Container (shared default)

extension View {
    /// Standard card wrapper for lists + home sections.
    func appCard(padding: CGFloat = LayoutConstants.cardPadding, elevation: CardElevation = .standard) -> some View {
        self.cardStyle(
            cornerRadius: LayoutConstants.cardCornerRadius,
            padding: padding,
            elevation: elevation
        )
    }
}


