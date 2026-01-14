//
//  SearchView.swift
//  Disability Advocacy iOS
//
//  Unified search interface for all content types
//

import SwiftUI

@MainActor
struct SearchView: View {
    @State private var viewModel: SearchViewModel
    @State private var communityViewModel: CommunityViewModel
    @State private var newsViewModel: NewsViewModel
    @Environment(AppState.self) var appState: AppState
    
    init() {
        // Initialize view models
        let communityVM = CommunityViewModel()
        let newsVM = NewsViewModel()
        _communityViewModel = State(initialValue: communityVM)
        _newsViewModel = State(initialValue: newsVM)
        
        // Initialize search view model with view models
        _viewModel = State(initialValue: SearchViewModel(
            communityViewModel: communityVM,
            newsViewModel: newsVM
        ))
    }

    private enum SearchFilter: Hashable {
        case all
        case type(SearchResultType)

        var selectedType: SearchResultType? {
            switch self {
            case .all: return nil
            case .type(let type): return type
            }
        }
    }

    private var filterSelection: Binding<SearchFilter> {
        Binding(
            get: { @MainActor in
                if let type = viewModel.selectedType {
                    return .type(type)
                }
                return .all
            },
            set: { @MainActor newValue in
                viewModel.selectedType = newValue.selectedType
                let trimmed = viewModel.searchText.trimmingCharacters(in: .whitespacesAndNewlines)
                if !trimmed.isEmpty {
                    viewModel.performSearch(query: trimmed)
                }
            }
        )
    }
    
    var body: some View {
        Group {
            #if os(macOS)
            GeometryReader { geometry in
                ScrollView {
                    VStack(alignment: .leading, spacing: LayoutConstants.sectionGap) {
            if !viewModel.searchText.isEmpty || !viewModel.searchResults.isEmpty {
                            VStack(alignment: .leading, spacing: LayoutConstants.sectionHeaderSpacing) {
                                AppSectionHeader(title: "Filters", systemImage: "line.3.horizontal.decrease.circle")
                                    .tint(.triadPrimary)
                                
                    Picker(String(localized: "Filter"), selection: filterSelection) {
                        Text(String(localized: "All")).tag(SearchFilter.all)
                        ForEach(SearchResultType.allCases, id: \.self) { type in
                            Text(type.rawValue.capitalized).tag(SearchFilter.type(type))
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }

            if viewModel.searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                if !viewModel.recentSearches.isEmpty {
                                VStack(alignment: .leading, spacing: LayoutConstants.sectionHeaderSpacing) {
                                    AppSectionHeader(
                                        title: "Recent Searches",
                                        systemImage: "clock.fill",
                                        actionTitle: "Clear",
                                        action: { viewModel.clearRecentSearches() }
                                    )
                                    .tint(.triadSecondary)
                                    
                                    FlowLayout(spacing: 8) {
                        ForEach(viewModel.recentSearches, id: \.self) { search in
                            Button {
                                viewModel.searchText = search
                                viewModel.performSearch(query: search)
                            } label: {
                                                Text(search)
                                                    .font(.subheadline)
                                                    .padding(.horizontal, 12)
                                                    .padding(.vertical, 6)
                                                    .background(Color.secondary.opacity(0.1), in: Capsule())
                                            }
                                            .buttonStyle(.plain)
                                        }
                                    }
                                }
                            }

                            VStack(alignment: .leading, spacing: LayoutConstants.sectionHeaderSpacing) {
                                AppSectionHeader(title: "Quick Search", systemImage: "sparkles")
                                    .tint(.triadTertiary)
                                
                                LazyVGrid(columns: AdaptiveLayout.gridColumns(for: .regular, availableWidth: geometry.size.width), spacing: LayoutConstants.cardGap) {
                                    QuickSearchCard(title: "Resources", icon: "book.fill", color: .blue) {
                                        viewModel.searchText = "resources"
                                        viewModel.performSearch(query: "resources")
                                    }
                                    
                                    QuickSearchCard(title: "Events", icon: "calendar", color: .green) {
                                        viewModel.searchText = "events"
                                        viewModel.performSearch(query: "events")
                                    }
                                    
                                    QuickSearchCard(title: "Community", icon: "person.3.fill", color: .orange) {
                                        viewModel.searchText = "community"
                                        viewModel.performSearch(query: "community")
                                    }
                                    
                                    QuickSearchCard(title: "News", icon: "newspaper.fill", color: .purple) {
                                        viewModel.searchText = "news"
                                        viewModel.performSearch(query: "news")
                                    }
                                }
                            }
                        } else {
                            if viewModel.isLoading {
                                LoadingView(message: String(localized: "Searching..."))
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                            } else if viewModel.searchResults.isEmpty {
                                AppEmptyState(
                                    title: "No results found",
                                    systemImage: "magnifyingglass",
                                    description: "Try searching for something else"
                                )
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                            } else {
                                VStack(alignment: .leading, spacing: LayoutConstants.sectionHeaderSpacing) {
                                    AppSectionHeader(title: "Results", systemImage: "list.bullet")
                                        .tint(.triadPrimary)
                                    
                                    LazyVGrid(columns: AdaptiveLayout.gridColumns(for: .regular, availableWidth: geometry.size.width), spacing: LayoutConstants.cardGap) {
                                        ForEach(viewModel.searchResults) { result in
                                            NavigationLink(value: result) {
                                                SearchResultGridCard(result: result, searchQuery: viewModel.currentQuery)
                                            }
                                            .buttonStyle(.plain)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .adaptiveContentFrame()
                    .padding(.top, LayoutConstants.paddingM)
                    .padding(.bottom, LayoutConstants.paddingXXL)
                }
            }
            #else
            List {
                if !viewModel.searchText.isEmpty || !viewModel.searchResults.isEmpty {
                    Section {
                        Picker(String(localized: "Filter"), selection: filterSelection) {
                            Text(String(localized: "All")).tag(SearchFilter.all)
                            ForEach(SearchResultType.allCases, id: \.self) { type in
                                Text(type.rawValue.capitalized).tag(SearchFilter.type(type))
                            }
                        }
                        .pickerStyle(.segmented)
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    } header: {
                        AppSectionHeader(title: "Filters", systemImage: "line.3.horizontal.decrease.circle")
                            .tint(.triadPrimary)
                    }
                }

                if viewModel.searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    if !viewModel.recentSearches.isEmpty {
                        Section {
                            ForEach(viewModel.recentSearches, id: \.self) { search in
                                Button {
                                    viewModel.searchText = search
                                    viewModel.performSearch(query: search)
                                } label: {
                                    Label(search, systemImage: "clock")
                                        .foregroundStyle(.primary)
                                }
                            }
                        } header: {
                            AppSectionHeader(
                                title: "Recent Searches",
                                systemImage: "clock.fill",
                                actionTitle: "Clear",
                                action: { viewModel.clearRecentSearches() }
                            )
                            .tint(.triadSecondary)
                        }
                    }

                    Section {
                    Button {
                        viewModel.searchText = "resources"
                        viewModel.performSearch(query: "resources")
                    } label: {
                        AppRow(title: "Resources", systemImage: "book.fill")
                    }

                    Button {
                        viewModel.searchText = "events"
                        viewModel.performSearch(query: "events")
                    } label: {
                        AppRow(title: "Events", systemImage: "calendar")
                    }

                    Button {
                        viewModel.searchText = "community"
                        viewModel.performSearch(query: "community")
                    } label: {
                        AppRow(title: "Community", systemImage: "person.3.fill")
                    }

                    Button {
                        viewModel.searchText = "news"
                        viewModel.performSearch(query: "news")
                    } label: {
                        AppRow(title: "News", systemImage: "newspaper.fill")
                    }
                    } header: {
                        AppSectionHeader(title: "Suggestions", systemImage: "sparkles")
                            .tint(.triadTertiary)
                }
            } else {
                if viewModel.isLoading {
                    Section {
                        HStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                            .listRowBackground(Color.clear)
                    }
                } else if viewModel.searchResults.isEmpty {
                    Section {
                        AppEmptyState(
                            title: "No results found",
                            systemImage: "magnifyingglass",
                            description: "Try adjusting your search terms."
                        )
                    }
                        .listRowBackground(Color.clear)
                } else {
                    Section {
                        ForEach(viewModel.searchResults) { result in
                            NavigationLink(value: result) {
                                SearchResultRow(result: result, searchQuery: viewModel.currentQuery)
                            }
                            }
                        } header: {
                            AppSectionHeader(title: "Results", systemImage: "magnifyingglass")
                                .tint(.triadPrimary)
                        }
                    }
                }
            }
                    #if os(iOS)
        .listStyle(.insetGrouped)
        #else
        .listStyle(.sidebar)
        #endif
            #endif
        }
        .onChange(of: viewModel.searchText) { oldValue, newValue in
            let trimmed = newValue.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmed.isEmpty {
                viewModel.searchResults = []
            } else {
                viewModel.performSearch(query: trimmed)
            }
        }
        .appListBackground()
        .navigationTitle(String(localized: "Search"))
        .platformInlineNavigationTitle()
        #if os(iOS)
        .searchable(
            text: $viewModel.searchText,
            placement: .navigationBarDrawer(displayMode: .automatic),
            prompt: String(localized: "Search resources, events, posts, and articles...")
        )
        #else
        .searchable(
            text: $viewModel.searchText,
            prompt: String(localized: "Search resources, events, posts, and articles...")
        )
        #endif
        .toolbar {
            ToolbarItem(placement: PlatformUI.trailingToolbarItemPlacement) {
                ProfileToolbarButton()
            }
        }
        .appScreenChrome()
        .onAppear {
            // Load data for view models
            communityViewModel.loadPosts()
            newsViewModel.loadArticles()
            // Update search view model with loaded data
            viewModel.setViewModels(community: communityViewModel, news: newsViewModel)
        }
    }
    
    @ViewBuilder
    private func destinationView(for result: SearchResult) -> some View {
        switch result.type {
        case .resource:
            if let resourceId = result.resourceId,
               let resource = findResource(id: resourceId) {
                ResourceDetailView(resource: resource)
                    
            } else {
                Text(String(localized: "Resource not found"))
            }
        case .event:
            if let eventId = result.eventId,
               let event = findEvent(id: eventId) {
                EventDetailView(event: event)
            } else {
                Text(String(localized: "Event not found"))
            }
        case .post:
            if let postId = result.postId,
               let post = findPost(id: postId) {
                PostDetailView(post: post)
            } else {
                Text(String(localized: "Post not found"))
            }
        case .article:
            if let articleId = result.articleId,
               let article = findArticle(id: articleId) {
                ArticleDetailView(article: article)
            } else {
                Text(String(localized: "Article not found"))
            }
        }
    }
    
    // Helper methods to find items (simplified - should use ViewModels in production)
    @MainActor
    private func findResource(id: UUID) -> Resource? {
        let resources = ResourcesManager.shared.getAllResources()
        return resources.first { $0.id == id }
    }
    
    @MainActor
    private func findEvent(id: UUID) -> Event? {
        let events = EventsManager.shared.getAllEvents()
        return events.first { $0.id == id }
    }
    
    private func findPost(id: UUID) -> CommunityPost? {
        return communityViewModel.posts.first { $0.id == id }
    }
    
    private func findArticle(id: UUID) -> NewsArticle? {
        return newsViewModel.articles.first { $0.id == id }
    }
}

struct QuickSearchCard: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            AppGridCard(minHeight: 100) {
                HStack(spacing: 16) {
                    Image(systemName: icon)
                        .font(.title2.weight(.bold))
                        .foregroundStyle(color)
                        .frame(width: 44, height: 44)
                        .background(color.opacity(0.1))
                        .cornerRadius(12)
                    
                    Text(title)
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.primary)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(Color.tertiaryText)
                }
            }
        }
        .buttonStyle(.plain)
    }
}

struct SearchResultRow: View {
    let result: SearchResult
    let searchQuery: String
    
    init(result: SearchResult, searchQuery: String = "") {
        self.result = result
        self.searchQuery = searchQuery
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: result.icon)
                .foregroundStyle(.tint)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                if !searchQuery.isEmpty {
                    HighlightedTitleText(
                        text: result.title,
                        query: searchQuery,
                        font: .body.weight(.semibold),
                        foregroundColor: .primary
                    )
                } else {
                    Text(result.title)
                        .font(.body.weight(.semibold))
                        .foregroundStyle(.primary)
                }
                
                if !searchQuery.isEmpty {
                    HighlightedSummaryText(
                        text: result.summary,
                        query: searchQuery,
                        font: .subheadline,
                        foregroundColor: Color.secondaryText
                    )
                    .lineLimit(2)
                } else {
                    Text(result.summary)
                        .font(.subheadline)
                        .foregroundStyle(Color.secondaryText)
                        .lineLimit(2)
                }
            }
            
            Spacer()
            
            Text(result.typeLabel)
                .font(.caption.weight(.bold))
                .foregroundStyle(Color.tertiaryText)
        }
        .padding(.vertical, 6)
    }
}
