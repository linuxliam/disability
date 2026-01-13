//
//  HomeView.swift
//  Disability Advocacy
//
//  Home View for macOS
//

import SwiftUI

struct HomeView: View {
    @Environment(AppState.self) var appState
    @State private var viewModel = HomeViewModel()
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading, spacing: LayoutConstants.sectionGap) {
                    // Stats Overview
                    StatsSection(
                        totalResources: viewModel.totalResources,
                        upcomingEvents: viewModel.upcomingEvents,
                        recentPosts: viewModel.recentPosts
                    )
                    .padding(.top, LayoutConstants.paddingL)

                    // Recommended Section
                    if !viewModel.recommendedResources.isEmpty {
                        VStack(alignment: .leading, spacing: LayoutConstants.sectionHeaderSpacing) {
                            AppSectionHeader(title: "Recommended for You", systemImage: "sparkles")
                            
                            LazyVGrid(columns: AdaptiveLayout.gridColumns(for: .regular, availableWidth: geometry.size.width), spacing: LayoutConstants.cardGap) {
                                ForEach(viewModel.recommendedResources.prefix(4)) { resource in
                                    NavigationLink(value: resource) {
                                        ResourceCard(resource: resource)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }

                    // Upcoming Events
                    if !viewModel.upcomingEventsList.isEmpty {
                        VStack(alignment: .leading, spacing: LayoutConstants.sectionHeaderSpacing) {
                            AppSectionHeader(title: "Upcoming Events", systemImage: "calendar")
                            
                            LazyVGrid(columns: AdaptiveLayout.gridColumns(for: .regular, availableWidth: geometry.size.width), spacing: LayoutConstants.cardGap) {
                                ForEach(viewModel.upcomingEventsList.prefix(4)) { event in
                                    NavigationLink(value: event) {
                                        EventCard(event: event)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, LayoutConstants.screenHorizontalPadding)
                .padding(.bottom, LayoutConstants.paddingXXL)
                .frame(maxWidth: AdaptiveLayout.contentMaxWidth(for: .regular))
                .frame(maxWidth: .infinity)
            }
        }
        .navigationTitle(String(localized: "Home"))
        .appScreenChrome()
        .onAppear {
            viewModel.loadData(favoriteResourceIds: appState.favoriteResources)
        }
    }
}

// MARK: - Supporting Views

