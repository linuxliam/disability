//
//  EmptyStateView.swift
//  Disability Advocacy iOS
//
//  Reusable empty state component
//

import SwiftUI

struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    var primaryActionTitle: String?
    var primaryAction: (() -> Void)?
    var secondaryActionTitle: String?
    var secondaryAction: (() -> Void)?
    
    var body: some View {
        ContentUnavailableView {
            Label(title, systemImage: icon)
                .foregroundStyle(.triadPrimary)
        } description: {
            Text(message)
                .secondaryBody()
        } actions: {
            VStack(spacing: 12) {
                if let actionTitle = primaryActionTitle, let action = primaryAction {
                    Button(actionTitle, action: action)
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                        .fontWeight(.bold)
                }
                
                if let secondaryTitle = secondaryActionTitle, let secondaryAction = secondaryAction {
                    Button(secondaryTitle, action: secondaryAction)
                        .buttonStyle(.plain)
                        .foregroundStyle(.triadSecondary)
                        .fontWeight(.semibold)
                }
            }
        }
    }
}

#Preview {
    EmptyStateView(
        icon: "magnifyingglass",
        title: "No results found",
        message: "Try adjusting your search terms."
    )
}

