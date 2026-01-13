//
//  HomeView.swift
//  Disability Advocacy
//
//  Home View for iOS
//

import SwiftUI

struct HomeView: View {
    @Environment(AppState.self) var appState
    @State private var viewModel = HomeViewModel()
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        List {
            // Stats Overview
            Section {
                StatsSection(
                    totalResources: viewModel.totalResources,
                    upcomingEvents: viewModel.upcomingEvents,
                    recentPosts: viewModel.recentPosts
                )
                .listRowInsets(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
                .listRowBackground(
                    RoundedRectangle(cornerRadius: LayoutConstants.cardCornerRadius)
                        .fill(Color.triadPrimary.opacity(0.05))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 4)
                )
            } header: {
                AppSectionHeader(
                    title: LocalizedStringKey("Overview"),
                    systemImage: "chart.bar.fill"
                )
                .tint(.triadPrimary)
            }
            .listRowSeparator(.hidden)

            // Recommended Section (Standard List)
            if !viewModel.recommendedResources.isEmpty {
                Section {
                    ForEach(viewModel.recommendedResources.prefix(3)) { resource in
                        NavigationLink(value: resource) {
                            AppRow(
                                title: resource.title,
                                subtitle: resource.description,
                                systemImage: resource.category.icon
                            )
                        }
                    }
                } header: {
                    AppSectionHeader(
                        title: LocalizedStringKey("Recommended"),
                        systemImage: "sparkles",
                        actionTitle: LocalizedStringKey("See all"),
                        action: { appState.selectedTab = .library }
                    )
                    .tint(.triadPrimary)
                }
            }

            // Upcoming Events Section (Standard List)
            if !viewModel.upcomingEventsList.isEmpty {
                Section {
                    ForEach(viewModel.upcomingEventsList.prefix(3)) { event in
                        NavigationLink(value: event) {
                            EventCard(event: event)
                        }
                    }
                } header: {
                    AppSectionHeader(
                        title: LocalizedStringKey("Upcoming Events"),
                        systemImage: "calendar",
                        actionTitle: LocalizedStringKey("View all"),
                        action: { appState.selectedTab = .connect }
                    )
                    .tint(.triadSecondary)
                }
            }
            
            // Categories Grid Section
            Section {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: LayoutConstants.cardGap) {
                    ForEach(ResourceCategory.allCases, id: \.self) { category in
                        NavigationLink(value: AppTab.resources) { // Simplified for now, can be specific if needed
                            CategoryGridItem(category: category)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .listRowInsets(EdgeInsets(top: 12, leading: 0, bottom: 12, trailing: 0))
                .listRowBackground(Color.clear)
            } header: {
                AppSectionHeader(
                    title: LocalizedStringKey("Browse by Category"),
                    systemImage: "square.grid.2x2.fill"
                )
                .tint(.triadTertiary)
            }
        }
        .listStyle(.insetGrouped)
        .appListBackground()
        .navigationTitle(LocalizedStringKey("Home"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: PlatformUI.trailingToolbarItemPlacement) {
                ProfileToolbarButton()
            }
        }
        .appNavigationChrome()
        .onAppear {
            viewModel.loadData(favoriteResourceIds: appState.favoriteResources)
        }
    }
}

// MARK: - Supporting Views

struct CategoryGridItem: View {
    let category: ResourceCategory
    
    var body: some View {
        VStack(spacing: LayoutConstants.spacingM) {
            Image(systemName: category.icon)
                .font(.title2.weight(.bold))
                .foregroundStyle(.triadTertiary)
                .frame(width: 50, height: 50)
                .background(Color.triadTertiary.opacity(0.1))
                .clipShape(Circle())
            
            Text(category.rawValue)
                .font(.caption.weight(.bold))
                .multilineTextAlignment(.center)
                .foregroundStyle(.primary)
        }
        .frame(maxWidth: .infinity)
        .padding(LayoutConstants.paddingL)
        .background(Color.cardBackground)
        .cornerRadius(LayoutConstants.cardCornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: LayoutConstants.cardCornerRadius)
                .stroke(Color.primary.opacity(0.05), lineWidth: 1)
        )
    }
}

