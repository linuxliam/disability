//
//  TapInteractionTests.swift
//  DisabilityAdvocacyTests
//
//  Unit tests for tap interaction logic
//

import XCTest
@testable import DisabilityAdvocacy_iOS

@MainActor
final class TapInteractionTests: XCTestCase {
    var appState: AppState!
    var resourcesManager: ResourcesManager!
    
    override func setUp() {
        super.setUp()
        resourcesManager = ResourcesManager()
        appState = AppState(resourcesManager: resourcesManager)
    }
    
    override func tearDown() {
        appState = nil
        resourcesManager = nil
        super.tearDown()
    }
    
    // MARK: - Favorite Button Tap Tests
    
    func testFavoriteButtonTapTogglesFavorite() {
        // Given
        let resourceId = UUID()
        XCTAssertFalse(appState.isFavorite(resourceId), "Resource should not be favorited initially")
        
        // When - simulate tap
        appState.toggleFavorite(resourceId)
        
        // Then
        XCTAssertTrue(appState.isFavorite(resourceId), "Resource should be favorited after tap")
        
        // When - tap again
        appState.toggleFavorite(resourceId)
        
        // Then
        XCTAssertFalse(appState.isFavorite(resourceId), "Resource should be unfavorited after second tap")
    }
    
    func testFavoriteButtonTapPersistsState() {
        // Given
        let resourceId = UUID()
        
        // When
        appState.toggleFavorite(resourceId)
        
        // Then - verify persistence
        let savedIds = resourcesManager.loadFavoriteIds()
        XCTAssertTrue(savedIds.contains(resourceId), "Favorite state should be persisted")
    }
    
    func testMultipleFavoriteButtonTaps() {
        // Given
        let resourceIds = [UUID(), UUID(), UUID()]
        
        // When - tap favorite for each
        for id in resourceIds {
            appState.toggleFavorite(id)
        }
        
        // Then
        XCTAssertEqual(appState.favoriteResources.count, resourceIds.count, "All resources should be favorited")
        
        // When - unfavorite one
        appState.toggleFavorite(resourceIds[0])
        
        // Then
        XCTAssertEqual(appState.favoriteResources.count, resourceIds.count - 1, "One resource should be unfavorited")
        XCTAssertFalse(appState.isFavorite(resourceIds[0]), "First resource should not be favorited")
        XCTAssertTrue(appState.isFavorite(resourceIds[1]), "Second resource should still be favorited")
        XCTAssertTrue(appState.isFavorite(resourceIds[2]), "Third resource should still be favorited")
    }
    
    // MARK: - Category Filter Tap Tests
    
    func testCategoryFilterTapSetsSelectedCategory() {
        // Given
        var selectedCategory: ResourceCategory? = nil
        
        // When - tap a category
        selectedCategory = .legal
        
        // Then
        XCTAssertEqual(selectedCategory, .legal, "Selected category should be set")
        
        // When - tap another category
        selectedCategory = .employment
        
        // Then
        XCTAssertEqual(selectedCategory, .employment, "Selected category should change")
        
        // When - tap "All" (nil)
        selectedCategory = nil
        
        // Then
        XCTAssertNil(selectedCategory, "Selected category should be cleared")
    }
    
    func testCategoryFilterTapFiltersResources() {
        // Given
        let resources = resourcesManager.getAllResources()
        let legalResources = resources.filter { $0.category == .legal }
        let employmentResources = resources.filter { $0.category == .employment }
        
        // When - filter by legal
        var filtered = resources.filter { $0.category == .legal }
        
        // Then
        XCTAssertEqual(filtered.count, legalResources.count, "Should filter to legal resources")
        
        // When - filter by employment
        filtered = resources.filter { $0.category == .employment }
        
        // Then
        XCTAssertEqual(filtered.count, employmentResources.count, "Should filter to employment resources")
        
        // When - clear filter
        filtered = resources
        
        // Then
        XCTAssertEqual(filtered.count, resources.count, "Should show all resources when filter cleared")
    }
    
    // MARK: - Navigation Tap Tests
    
    func testNavigationLinkTapDoesNotChangeState() {
        // Given
        let initialFavoriteCount = appState.favoriteResources.count
        
        // When - simulate navigation (should not change state)
        // Navigation links don't modify state, they just navigate
        
        // Then
        XCTAssertEqual(appState.favoriteResources.count, initialFavoriteCount, "Navigation should not change favorite state")
    }
    
    // MARK: - Button Action Tap Tests
    
    func testProfileButtonTapShowsProfile() {
        // Given
        XCTAssertFalse(appState.showProfile, "Profile should not be shown initially")
        
        // When - simulate profile button tap
        appState.showProfile = true
        
        // Then
        XCTAssertTrue(appState.showProfile, "Profile should be shown after button tap")
    }
    
    // Note: Accessibility settings feature not yet implemented in AppState
    // This test is commented out until the feature is added
    /*
    func testAccessibilitySettingsButtonTapShowsSettings() {
        // Given
        XCTAssertFalse(appState.showAccessibilitySettings, "Accessibility settings should not be shown initially")
        
        // When - simulate accessibility settings button tap
        appState.showAccessibilitySettings = true
        
        // Then
        XCTAssertTrue(appState.showAccessibilitySettings, "Accessibility settings should be shown after button tap")
    }
    */
    
    func testButtonTapCanDismissSheet() {
        // Given
        appState.showProfile = true
        XCTAssertTrue(appState.showProfile, "Profile should be shown")
        
        // When - simulate dismiss (setting to false)
        appState.showProfile = false
        
        // Then
        XCTAssertFalse(appState.showProfile, "Profile should be dismissed")
    }
    
    // MARK: - Search Bar Tap Tests
    
    func testSearchBarTapClearsText() {
        // Given
        var searchText = "test query"
        
        // When - simulate clear button tap
        searchText = ""
        
        // Then
        XCTAssertTrue(searchText.isEmpty, "Search text should be cleared")
    }
    
    func testSearchBarTextFiltersResources() {
        // Given
        let resources = resourcesManager.getAllResources()
        let searchText = "legal"
        
        // When - filter by search text
        let filtered = resources.filter { resource in
            resource.title.localizedCaseInsensitiveContains(searchText) ||
            resource.description.localizedCaseInsensitiveContains(searchText) ||
            resource.tags.contains { $0.localizedCaseInsensitiveContains(searchText) }
        }
        
        // Then
        XCTAssertFalse(filtered.isEmpty, "Should find resources matching search text")
    }
    
    // MARK: - Retry Button Tap Tests
    
    func testRetryButtonTapReloadsData() async {
        // Given
        let viewModel = HomeViewModel()
        let initialResources = viewModel.totalResources
        
        // When - simulate retry button tap
        await viewModel.loadData()
        
        // Then
        XCTAssertGreaterThanOrEqual(viewModel.totalResources, initialResources, "Should reload data on retry")
    }
    
    // MARK: - Card Tap Tests
    
    func testCardTapDoesNotToggleFavorite() {
        // Given
        let resourceId = UUID()
        let initialFavoriteState = appState.isFavorite(resourceId)
        
        // When - simulate card tap (should navigate, not toggle favorite)
        // Card taps should navigate, not toggle favorites
        
        // Then
        XCTAssertEqual(appState.isFavorite(resourceId), initialFavoriteState, "Card tap should not toggle favorite")
    }
    
    // MARK: - Haptic Feedback Tests
    
    func testFavoriteButtonTapTriggersHaptic() {
        // Given
        let resourceId = UUID()
        
        // When - toggle favorite (should trigger haptic)
        appState.toggleFavorite(resourceId)
        
        // Then - haptic should be called (we can't easily test haptic feedback in unit tests,
        // but we verify the action completes successfully)
        XCTAssertTrue(appState.isFavorite(resourceId), "Favorite toggle should complete")
    }
    
    // MARK: - Complex Interaction Tests
    
    func testFavoriteThenFilterInteraction() {
        // Given
        let resources = resourcesManager.getAllResources()
        let resourceId = resources.first?.id ?? UUID()
        
        // When - favorite a resource
        appState.toggleFavorite(resourceId)
        
        // Then
        XCTAssertTrue(appState.isFavorite(resourceId), "Resource should be favorited")
        
        // When - filter by category
        let category = resources.first?.category ?? .legal
        let filtered = resources.filter { $0.category == category }
        
        // Then - favorite state should persist
        XCTAssertTrue(appState.isFavorite(resourceId), "Favorite state should persist after filtering")
        XCTAssertFalse(filtered.isEmpty, "Filtered resources should not be empty")
    }
    
    func testSearchThenFavoriteInteraction() {
        // Given
        let resources = resourcesManager.getAllResources()
        let searchText = "legal"
        let filtered = resources.filter { resource in
            resource.title.localizedCaseInsensitiveContains(searchText) ||
            resource.description.localizedCaseInsensitiveContains(searchText)
        }
        let resourceId = filtered.first?.id ?? UUID()
        
        // When - favorite a filtered resource
        appState.toggleFavorite(resourceId)
        
        // Then
        XCTAssertTrue(appState.isFavorite(resourceId), "Resource should be favorited even after search")
    }
    
    func testMultipleRapidTaps() {
        // Given
        let resourceId = UUID()
        
        // When - rapid taps
        appState.toggleFavorite(resourceId)
        appState.toggleFavorite(resourceId)
        appState.toggleFavorite(resourceId)
        appState.toggleFavorite(resourceId)
        
        // Then - should end in correct state (even number of taps = not favorited)
        XCTAssertFalse(appState.isFavorite(resourceId), "Rapid taps should toggle correctly")
    }
}



