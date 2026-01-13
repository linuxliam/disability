//
//  FavoritesView.swift
//  Disability Advocacy
//
//  View for displaying user's favorite resources and events
//

import SwiftUI

struct FavoritesView: View {
    @Environment(AppState.self) private var appState: AppState
    @State private var resourcesViewModel = ResourcesViewModel()
    @State private var eventsViewModel = EventsViewModel()
    
    private var favoriteResources: [Resource] {
        resourcesViewModel.resources.filter { appState.favoriteResources.contains($0.id) }
    }
    
    private var favoriteEvents: [Event] {
        eventsViewModel.events.filter { event in
            // Events don't have favorites yet, but we can add this later
            false
        }
    }
    
    var body: some View {
        Group {
            if favoriteResources.isEmpty && favoriteEvents.isEmpty {
                emptyStateView
            } else {
                contentView
            }
        }
        .navigationTitle(String(localized: "My Favorites"))
        .platformInlineNavigationTitle()
        .task {
            resourcesViewModel.loadResources()
            eventsViewModel.loadEvents()
        }
        .appScreenChrome()
    }
    
    @ViewBuilder
    private var emptyStateView: some View {
        EmptyStateView(
            icon: "heart",
            title: String(localized: "No Favorites Yet"),
            message: String(localized: "Tap the heart icon on any resource or event to add it to your favorites."),
            primaryActionTitle: String(localized: "Browse Resources"),
            primaryAction: {
                // Navigate to resources
            }
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder
    private var contentView: some View {
        #if os(macOS)
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading, spacing: LayoutConstants.sectionHeaderSpacing) {
                    if !favoriteResources.isEmpty {
                        AppSectionHeader(
                            title: "Favorite Resources",
                            systemImage: "book.fill"
                        )
                        .padding(.bottom, LayoutConstants.spacingS)
                        
                        LazyVGrid(columns: AdaptiveLayout.gridColumns(for: .regular, availableWidth: geometry.size.width), spacing: LayoutConstants.cardGap) {
                            ForEach(favoriteResources) { resource in
                                NavigationLink(value: resource) {
                                    ResourceCard(resource: resource)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
                .padding(.horizontal, LayoutConstants.screenHorizontalPadding)
                .padding(.top, LayoutConstants.paddingM)
                .padding(.bottom, LayoutConstants.paddingXXL)
                .frame(maxWidth: AdaptiveLayout.contentMaxWidth(for: .regular))
                .frame(maxWidth: .infinity)
            }
        }
        #else
        List {
            if !favoriteResources.isEmpty {
                Section {
                    ForEach(favoriteResources) { resource in
                        NavigationLink(value: resource) {
                            ResourceListRow(resource: resource)
                        }
                    }
                } header: {
                    AppSectionHeader(
                        title: "Favorite Resources",
                        systemImage: "book.fill"
                    )
                }
            }
        }
        #if os(iOS)
        .listStyle(.insetGrouped)
        #else
        .listStyle(.sidebar)
        #endif
        .scrollContentBackground(.hidden)
        #endif
    }
}
