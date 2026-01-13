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

    // Performance optimizations
    private var searchCache: [String: [SearchResult]] = [:]
    private var lastSearchQuery = ""
    private var allResources: [Resource] = []
    private var allEvents: [Event] = []
    private var allPosts: [CommunityPost] = []
    private var allArticles: [NewsArticle] = []
    private var isDataLoaded = false

    init(
        resourcesManager: ResourcesManager = .shared,
        eventsManager: EventsManager = .shared
    ) {
        self.resourcesManager = resourcesManager
        self.eventsManager = eventsManager
        loadRecentSearches()
        preloadData()
    }

    private func preloadData() {
        allResources = resourcesManager.getAllResources()
        allEvents = eventsManager.getAllEvents()
        allPosts = getSamplePosts()
        allArticles = getSampleArticles()
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
    private func matches(query: String, resource: Resource) -> Bool {
        return resource.title.localizedCaseInsensitiveContains(query) ||
               resource.description.localizedCaseInsensitiveContains(query) ||
               resource.category.rawValue.localizedCaseInsensitiveContains(query) ||
               resource.tags.contains { $0.localizedCaseInsensitiveContains(query) }
    }

    private func matches(query: String, event: Event) -> Bool {
        return event.title.localizedCaseInsensitiveContains(query) ||
               event.description.localizedCaseInsensitiveContains(query) ||
               event.category.rawValue.localizedCaseInsensitiveContains(query) ||
               event.location.localizedCaseInsensitiveContains(query)
    }

    private func matches(query: String, post: CommunityPost) -> Bool {
        return post.title.localizedCaseInsensitiveContains(query) ||
               post.content.localizedCaseInsensitiveContains(query) ||
               post.category.rawValue.localizedCaseInsensitiveContains(query)
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
    
    // MARK: - Sample Data Helpers (temporary until ViewModels are integrated)
    
    private func getSamplePosts() -> [CommunityPost] {
        // This should ideally come from CommunityViewModel
        return []
    }
    
    private func getSampleArticles() -> [NewsArticle] {
        // This should ideally come from NewsViewModel  
        return []
    }
}

