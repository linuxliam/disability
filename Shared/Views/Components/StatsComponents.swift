//
//  StatsComponents.swift
//  Disability Advocacy
//
//  Shared statistics components used on Home view across platforms.
//

import SwiftUI

struct StatsSection: View {
    let totalResources: Int
    let upcomingEvents: Int
    let recentPosts: Int
    
    var body: some View {
        HStack(spacing: 12) {
            StatBadge(title: "Resources", value: totalResources, icon: "book.fill", color: .triadPrimary)
            StatBadge(title: "Events", value: upcomingEvents, icon: "calendar", color: .triadSecondary)
            StatBadge(title: "Posts", value: recentPosts, icon: "bubble.left.fill", color: .triadTertiary)
        }
    }
}

struct StatBadge: View {
    let title: String
    let value: Int
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Image(systemName: icon)
                .font(.body.weight(.bold))
                .foregroundStyle(color)
                .frame(width: 36, height: 36)
                .background(color.opacity(0.1))
                .clipShape(Circle())
            
            VStack(spacing: 2) {
                Text("\(value)")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(.primary)
                Text(title)
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(.secondary)
                    .textCase(.uppercase)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color.cardBackground)
        .cornerRadius(LayoutConstants.cardCornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: LayoutConstants.cardCornerRadius)
                .stroke(Color.primary.opacity(0.05), lineWidth: 1)
        )
    }
}

