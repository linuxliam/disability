//
//  AppComponents.swift
//  Disability Advocacy
//
//  Shared UI components + styles to keep iOS/macOS consistent.
//

import SwiftUI

// MARK: - Common Toolbar Items
// Note: AppChip, AppSectionHeader, AppRow, AppEmptyState, and ProfileToolbarButton
// are defined in Views/Components/ directory

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
                            trailingText: "Education"
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
                            trailingText: "Jan 13"
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
// Note: appCard extension is defined in Extensions/UIExtensions.swift


