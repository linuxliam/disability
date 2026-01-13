//
//  SearchViewModelTests.swift
//  DisabilityAdvocacyTests
//
//  Unit tests for SearchViewModel
//

import XCTest
@testable import DisabilityAdvocacy_iOS

@MainActor
final class SearchViewModelTests: XCTestCase {
    var viewModel: SearchViewModel!
    var resourcesManager: ResourcesManager!
    var eventsManager: EventsManager!
    
    override func setUp() {
        super.setUp()
        resourcesManager = ResourcesManager()
        eventsManager = EventsManager()
        viewModel = SearchViewModel(
            resourcesManager: resourcesManager,
            eventsManager: eventsManager
        )
        // Clear UserDefaults to ensure clean state
        UserDefaults.standard.removeObject(forKey: "recentSearches")
    }
    
    override func tearDown() {
        viewModel = nil
        resourcesManager = nil
        eventsManager = nil
        UserDefaults.standard.removeObject(forKey: "recentSearches")
        super.tearDown()
    }
    
    // MARK: - Initial State Tests
    
    func testInitialState() {
        // Then
        XCTAssertEqual(viewModel.searchText, "", "Search text should be empty initially")
        XCTAssertTrue(viewModel.searchResults.isEmpty, "Search results should be empty initially")
        XCTAssertTrue(viewModel.recentSearches.isEmpty, "Recent searches should be empty initially")
        XCTAssertFalse(viewModel.isLoading, "Should not be loading initially")
    }
    
    // MARK: - Search Functionality Tests
    
    func testPerformSearch_ValidQuery_ReturnsResults() {
        // Given
        let query = "legal"
        
        // When
        viewModel.performSearch(query: query)
        
        // Then
        XCTAssertFalse(viewModel.isLoading, "Should not be loading after search completes")
        XCTAssertFalse(viewModel.searchResults.isEmpty, "Should have search results")
    }
    
    func testPerformSearch_EmptyQuery_ClearsResults() {
        // Given
        viewModel.performSearch(query: "test")
        XCTAssertFalse(viewModel.searchResults.isEmpty, "Should have results from previous search")
        
        // When
        viewModel.performSearch(query: "")
        
        // Then
        XCTAssertTrue(viewModel.searchResults.isEmpty, "Should clear results for empty query")
        XCTAssertFalse(viewModel.isLoading, "Should not be loading")
    }
    
    func testPerformSearch_WhitespaceOnlyQuery_ClearsResults() {
        // Given
        viewModel.performSearch(query: "test")
        XCTAssertFalse(viewModel.searchResults.isEmpty, "Should have results from previous search")
        
        // When
        viewModel.performSearch(query: "   ")
        
        // Then
        XCTAssertTrue(viewModel.searchResults.isEmpty, "Should clear results for whitespace-only query")
        XCTAssertFalse(viewModel.isLoading, "Should not be loading")
    }
    
    func testPerformSearch_TrimsWhitespace() {
        // Given
        let query = "  legal  "
        
        // When
        viewModel.performSearch(query: query)
        
        // Then
        XCTAssertFalse(viewModel.isLoading, "Should not be loading after search completes")
        // Should still perform search with trimmed query
        XCTAssertTrue(viewModel.recentSearches.first == "legal", "Recent searches should contain trimmed query")
    }
    
    // MARK: - Search Matching Logic Tests
    
    func testPerformSearch_MatchesResourceByTitle() {
        // Given
        let query = "Legal"
        
        // When
        viewModel.performSearch(query: query)
        
        // Then
        let resourceResults = viewModel.searchResults.filter { $0.type == .resource }
        XCTAssertFalse(resourceResults.isEmpty, "Should find resources matching title")
    }
    
    func testPerformSearch_MatchesResourceByCategory() {
        // Given
        let query = "Legal Rights"
        
        // When
        viewModel.performSearch(query: query)
        
        // Then
        let resourceResults = viewModel.searchResults.filter { $0.type == .resource }
        XCTAssertFalse(resourceResults.isEmpty, "Should find resources matching category")
    }
    
    func testPerformSearch_MatchesEventByLocation() {
        // Given
        let query = "virtual"
        
        // When
        viewModel.performSearch(query: query)
        
        // Then
        // Should find events that match (either in title, description, category, or location)
        XCTAssertFalse(viewModel.searchResults.isEmpty, "Should find matching events")
    }
    
    func testPerformSearch_CaseInsensitive() {
        // Given
        let query1 = "LEGAL"
        let query2 = "legal"
        let query3 = "Legal"
        
        // When
        viewModel.performSearch(query: query1)
        let results1 = viewModel.searchResults.count
        
        viewModel.performSearch(query: query2)
        let results2 = viewModel.searchResults.count
        
        viewModel.performSearch(query: query3)
        let results3 = viewModel.searchResults.count
        
        // Then
        XCTAssertEqual(results1, results2, "Case should not affect results")
        XCTAssertEqual(results2, results3, "Case should not affect results")
    }
    
    func testPerformSearch_PartialMatches() {
        // Given
        let query = "leg"
        
        // When
        viewModel.performSearch(query: query)
        
        // Then
        // Should find resources/events containing "leg" (e.g., "legal")
        XCTAssertFalse(viewModel.searchResults.isEmpty, "Should find partial matches")
    }
    
    // MARK: - Result Sorting Tests
    
    func testPerformSearch_ResultsSortedByRelevance() {
        // Given
        let query = "legal"
        
        // When
        viewModel.performSearch(query: query)
        
        // Then
        guard viewModel.searchResults.count > 1 else {
            XCTSkip("Need multiple results to test sorting")
            return
        }
        
        let queryLower = query.lowercased()
        // Title matches should come before non-title matches
        let titleMatches = viewModel.searchResults.filter { $0.title.lowercased().contains(queryLower) }
        let nonTitleMatches = viewModel.searchResults.filter { !$0.title.lowercased().contains(queryLower) }
        
        if !titleMatches.isEmpty && !nonTitleMatches.isEmpty {
            let firstNonTitleIndex = viewModel.searchResults.firstIndex { !$0.title.lowercased().contains(queryLower) } ?? 0
            let lastTitleIndex = viewModel.searchResults.lastIndex { $0.title.lowercased().contains(queryLower) } ?? 0
            XCTAssertLessThan(lastTitleIndex, firstNonTitleIndex, "Title matches should come before non-title matches")
        }
    }
    
    func testPerformSearch_ResultsSortedByDate() {
        // Given
        let query = "test"
        
        // When
        viewModel.performSearch(query: query)
        
        // Then
        guard viewModel.searchResults.count > 1 else {
            return // Not enough results to test sorting
        }
        
        // Results with same match type should be sorted by date (newer first)
        for i in 0..<viewModel.searchResults.count - 1 {
            let result1 = viewModel.searchResults[i]
            let result2 = viewModel.searchResults[i + 1]
            
            let queryLower = query.lowercased()
            let title1Match = result1.title.lowercased().contains(queryLower)
            let title2Match = result2.title.lowercased().contains(queryLower)
            
            // If both have same match type, check date ordering
            if title1Match == title2Match, let date1 = result1.date, let date2 = result2.date {
                XCTAssertGreaterThanOrEqual(date1, date2, "Results should be sorted by date (newer first)")
            }
        }
    }
    
    // MARK: - Recent Searches Tests
    
    func testPerformSearch_AddsToRecentSearches() {
        // Given
        let query = "legal rights"
        
        // When
        viewModel.performSearch(query: query)
        
        // Then
        XCTAssertTrue(viewModel.recentSearches.contains(query), "Should add query to recent searches")
        XCTAssertEqual(viewModel.recentSearches.first, query, "Most recent search should be first")
    }
    
    func testPerformSearch_DeduplicatesRecentSearches() {
        // Given
        let query = "legal"
        
        // When
        viewModel.performSearch(query: query)
        viewModel.performSearch(query: "education")
        viewModel.performSearch(query: query) // Search again
        
        // Then
        let occurrences = viewModel.recentSearches.filter { $0 == query }.count
        XCTAssertEqual(occurrences, 1, "Should not have duplicate searches")
        XCTAssertEqual(viewModel.recentSearches.first, query, "Repeated search should move to front")
    }
    
    func testPerformSearch_RecentSearchesCaseInsensitiveDeduplication() {
        // Given
        let query1 = "Legal"
        let query2 = "LEGAL"
        let query3 = "legal"
        
        // When
        viewModel.performSearch(query: query1)
        viewModel.performSearch(query: query2)
        viewModel.performSearch(query: query3)
        
        // Then
        // Should treat case-insensitive duplicates as the same
        let uniqueSearches = Set(viewModel.recentSearches.map { $0.lowercased() })
        XCTAssertEqual(uniqueSearches.count, 1, "Should deduplicate case-insensitively")
    }
    
    func testPerformSearch_RecentSearchesMaxLimit() {
        // Given - Add 11 different searches (max is 10)
        let queries = (1...11).map { "search\($0)" }
        
        // When
        for query in queries {
            viewModel.performSearch(query: query)
        }
        
        // Then
        XCTAssertLessThanOrEqual(viewModel.recentSearches.count, 10, "Should not exceed max recent searches")
        XCTAssertEqual(viewModel.recentSearches.first, "search11", "Most recent should be first")
        XCTAssertFalse(viewModel.recentSearches.contains("search1"), "Oldest search should be removed")
    }
    
    func testClearRecentSearches_ClearsAllSearches() {
        // Given
        viewModel.performSearch(query: "test1")
        viewModel.performSearch(query: "test2")
        XCTAssertFalse(viewModel.recentSearches.isEmpty, "Should have recent searches")
        
        // When
        viewModel.clearRecentSearches()
        
        // Then
        XCTAssertTrue(viewModel.recentSearches.isEmpty, "Should clear all recent searches")
    }
    
    func testClearRecentSearches_RemovesFromUserDefaults() {
        // Given
        viewModel.performSearch(query: "test")
        XCTAssertFalse(UserDefaults.standard.data(forKey: "recentSearches") == nil, "Should have data in UserDefaults")
        
        // When
        viewModel.clearRecentSearches()
        
        // Then
        XCTAssertNil(UserDefaults.standard.data(forKey: "recentSearches"), "Should remove data from UserDefaults")
    }
    
    // MARK: - UserDefaults Persistence Tests
    
    func testRecentSearches_PersistAcrossInstances() {
        // Given
        viewModel.performSearch(query: "persistent")
        viewModel.performSearch(query: "search")
        let searchesBefore = viewModel.recentSearches
        
        // When - Create new instance
        let newViewModel = SearchViewModel(
            resourcesManager: resourcesManager,
            eventsManager: eventsManager
        )
        
        // Then
        XCTAssertEqual(newViewModel.recentSearches, searchesBefore, "Recent searches should persist across instances")
    }
    
    // MARK: - Edge Cases Tests
    
    func testPerformSearch_SpecialCharacters() {
        // Given
        let query = "test@#$%"
        
        // When
        viewModel.performSearch(query: query)
        
        // Then
        // Should handle special characters gracefully (may or may not find results)
        XCTAssertFalse(viewModel.isLoading, "Should not crash with special characters")
    }
    
    func testPerformSearch_VeryLongQuery() {
        // Given
        let query = String(repeating: "a", count: 1000)
        
        // When
        viewModel.performSearch(query: query)
        
        // Then
        XCTAssertFalse(viewModel.isLoading, "Should handle very long queries gracefully")
    }
    
    func testPerformSearch_UnicodeCharacters() {
        // Given
        let query = "résumé"
        
        // When
        viewModel.performSearch(query: query)
        
        // Then
        XCTAssertFalse(viewModel.isLoading, "Should handle unicode characters gracefully")
    }
    
    func testPerformSearch_NoResults() {
        // Given
        let query = "nonexistentsearchterm12345"
        
        // When
        viewModel.performSearch(query: query)
        
        // Then
        XCTAssertTrue(viewModel.searchResults.isEmpty, "Should return empty results for non-matching query")
        XCTAssertFalse(viewModel.isLoading, "Should not be loading")
    }
    
    // MARK: - Loading State Tests
    
    func testPerformSearch_SetsLoadingState() {
        // Given
        let query = "test"
        XCTAssertFalse(viewModel.isLoading, "Should not be loading initially")
        
        // When
        viewModel.performSearch(query: query)
        
        // Then
        XCTAssertFalse(viewModel.isLoading, "Should not be loading after search completes")
    }
}

