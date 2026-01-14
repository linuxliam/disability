//
//  SearchViewModel.swift
//  Disability Advocacy iOS
//
//  View model for unified search functionality
//

import Foundation
import Observation

@MainActor
@Observable
class SearchViewModel {
    var searchText: String = ""
    var searchResults: [SearchResult] = []
    var recentSearches: [String] = []
    var isLoading: Bool = false
    var selectedType: SearchResultType? = nil
    
    private let maxRecentSearches = 10
    private let recentSearchesKey = "recentSearches"

    private let resourcesManager: ResourcesManager
    private let eventsManager: EventsManager
    private var communityViewModel: CommunityViewModel?
    private var newsViewModel: NewsViewModel?

    // Performance optimizations
    private var searchCache: [String: [SearchResult]] = [:]
    private var lastSearchQuery = ""
    private var allResources: [Resource] = []
    private var allEvents: [Event] = []
    private var allPosts: [CommunityPost] = []
    private var allArticles: [NewsArticle] = []
    private var isDataLoaded = false

    nonisolated init(
        resourcesManager: ResourcesManager = MainActor.assumeIsolated { ResourcesManager.shared },
        eventsManager: EventsManager = MainActor.assumeIsolated { EventsManager.shared },
        communityViewModel: CommunityViewModel? = nil,
        newsViewModel: NewsViewModel? = nil
    ) {
        self.resourcesManager = resourcesManager
        self.eventsManager = eventsManager
        // Store view models for later use (will be set on MainActor)
        Task { @MainActor in
            self.communityViewModel = communityViewModel
            self.newsViewModel = newsViewModel
            loadRecentSearches()
        }
        // Note: preloadData() is called lazily in performSearch() when needed
    }
    
    /// Sets the view models for community and news data
    func setViewModels(community: CommunityViewModel?, news: NewsViewModel?) {
        self.communityViewModel = community
        self.newsViewModel = news
        // Reload data if already loaded
        if isDataLoaded {
            preloadData()
        }
    }

    private func preloadData() {
        allResources = resourcesManager.getAllResources()
        allEvents = eventsManager.getAllEvents()
        allPosts = communityViewModel?.posts ?? []
        allArticles = newsViewModel?.articles ?? []
        isDataLoaded = true
    }
    
    func performSearch(query: String) {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            searchResults = []
            return
        }

        let searchQuery = query.trimmingCharacters(in: .whitespaces)

        // Check cache first for exact matches
        if let cachedResults = searchCache[searchQuery] {
            searchResults = cachedResults
            return
        }

        isLoading = true
        defer { isLoading = false }

        // Ensure data is loaded
        if !isDataLoaded {
            preloadData()
        }

        var results: [SearchResult] = []
        let lowerQuery = searchQuery.lowercased() // Compute once

        // Search Resources
        if selectedType == nil || selectedType == .resource {
            for resource in allResources {
                if matches(query: lowerQuery, resource: resource) {
                    results.append(SearchResult(
                        type: .resource,
                        title: resource.title,
                        subtitle: resource.category.rawValue,
                        summary: resource.description,
                        category: resource.category.rawValue,
                        date: resource.dateAdded,
                        resourceId: resource.id
                    ))
                }
            }
        }

        // Search Events
        if selectedType == nil || selectedType == .event {
            for event in allEvents {
                if matches(query: lowerQuery, event: event) {
                    results.append(SearchResult(
                        type: .event,
                        title: event.title,
                        subtitle: event.category.rawValue,
                        summary: event.description,
                        category: event.category.rawValue,
                        date: event.date,
                        eventId: event.id
                    ))
                }
            }
        }

        // Search Community Posts
        if selectedType == nil || selectedType == .post {
            for post in allPosts {
                if matches(query: lowerQuery, post: post) {
                    results.append(SearchResult(
                        type: .post,
                        title: post.title,
                        subtitle: post.category.rawValue,
                        summary: post.content,
                        category: post.category.rawValue,
                        date: post.datePosted,
                        postId: post.id
                    ))
                }
            }
        }

        // Search News Articles
        if selectedType == nil || selectedType == .article {
            for article in allArticles {
                if matches(query: lowerQuery, article: article) {
                    results.append(SearchResult(
                        type: .article,
                        title: article.title,
                        subtitle: article.category,
                        summary: article.summary,
                        category: article.category,
                        date: article.date,
                        articleId: article.id
                    ))
                }
            }
        }

        // Sort results by relevance (use pre-computed lowercase query)
        searchResults = results.sorted { result1, result2 in
            let title1Match = result1.title.lowercased().contains(lowerQuery)
            let title2Match = result2.title.lowercased().contains(lowerQuery)

            if title1Match != title2Match {
                return title1Match
            }

            // Then by date (newer first)
            if let date1 = result1.date, let date2 = result2.date {
                return date1 > date2
            }

            return result1.date != nil
        }

        // Cache results for future searches
        searchCache[searchQuery] = searchResults

        // Save to recent searches
        addToRecentSearches(searchQuery)
    }
    
    // MARK: - Matching Logic
    
    // Optimized matching functions - query is already lowercased
    // Use direct lowercased() and contains() instead of localizedCaseInsensitiveContains
    // for better performance when query is pre-lowercased
    private func matches(query: String, resource: Resource) -> Bool {
        return resource.title.lowercased().contains(query) ||
               resource.description.lowercased().contains(query) ||
               resource.category.rawValue.lowercased().contains(query) ||
               resource.tags.contains { $0.lowercased().contains(query) }
    }

    private func matches(query: String, event: Event) -> Bool {
        return event.title.lowercased().contains(query) ||
               event.description.lowercased().contains(query) ||
               event.category.rawValue.lowercased().contains(query) ||
               event.location.lowercased().contains(query)
    }

    private func matches(query: String, post: CommunityPost) -> Bool {
        return post.title.lowercased().contains(query) ||
               post.content.lowercased().contains(query) ||
               post.category.rawValue.lowercased().contains(query)
    }

    private func matches(query: String, article: NewsArticle) -> Bool {
        return article.title.localizedCaseInsensitiveContains(query) ||
               article.summary.localizedCaseInsensitiveContains(query) ||
               article.category.localizedCaseInsensitiveContains(query) ||
               article.source.localizedCaseInsensitiveContains(query)
    }
    
    // MARK: - Recent Searches
    
    private func loadRecentSearches() {
        guard let data = UserDefaults.standard.data(forKey: recentSearchesKey) else {
            return
        }

        do {
            let searches = try JSONDecoder().decode([String].self, from: data)
            recentSearches = Array(searches.prefix(maxRecentSearches))
        } catch {
            recentSearches = []
        }
    }
    
    private func addToRecentSearches(_ search: String) {
        var searches = recentSearches
        searches.removeAll { $0.caseInsensitiveCompare(search) == .orderedSame }
        searches.insert(search, at: 0)
        searches = Array(searches.prefix(maxRecentSearches))
        recentSearches = searches
        
        do {
            let data = try JSONEncoder().encode(searches)
            UserDefaults.standard.set(data, forKey: recentSearchesKey)
        } catch {
        }
    }
    
    func clearRecentSearches() {
        recentSearches = []
        UserDefaults.standard.removeObject(forKey: recentSearchesKey)
    }
    
    /// Current search query for highlighting purposes
    var currentQuery: String {
        searchText.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

