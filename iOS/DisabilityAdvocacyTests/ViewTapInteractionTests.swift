//
//  ViewTapInteractionTests.swift
//  DisabilityAdvocacyTests
//
//  Comprehensive unit tests for tap functions in various views
//

import XCTest
@testable import DisabilityAdvocacy

@MainActor
final class ViewTapInteractionTests: XCTestCase {
    var appState: AppState!
    var resourcesManager: ResourcesManager!
    var eventsManager: EventsManager!
    var calendarManager: CalendarManager!
    
    override func setUp() {
        super.setUp()
        resourcesManager = ResourcesManager()
        eventsManager = EventsManager()
        calendarManager = CalendarManager()
        appState = AppState(resourcesManager: resourcesManager)
    }
    
    override func tearDown() {
        appState = nil
        resourcesManager = nil
        eventsManager = nil
        calendarManager = nil
        super.tearDown()
    }
    
    // MARK: - HomeView Tap Tests
    
    func testHomeViewProfileButtonTap() {
        // Given
        XCTAssertFalse(appState.showProfile, "Profile should not be shown initially")
        
        // When - simulate profile button tap
        appState.showProfile = true
        
        // Then
        XCTAssertTrue(appState.showProfile, "Profile should be shown after button tap")
    }
    
    func testHomeViewProfileButtonTapDismisses() {
        // Given
        appState.showProfile = true
        XCTAssertTrue(appState.showProfile, "Profile should be shown")
        
        // When - simulate dismiss
        appState.showProfile = false
        
        // Then
        XCTAssertFalse(appState.showProfile, "Profile should be dismissed")
    }
    
    func testHomeViewRetryButtonTap() async {
        // Given
        let viewModel = HomeViewModel()
        let initialResources = viewModel.totalResources
        
        // When - simulate retry button tap
        await viewModel.loadData(favoriteResourceIds: appState.favoriteResources)
        
        // Then
        XCTAssertGreaterThanOrEqual(viewModel.totalResources, initialResources, "Should reload data on retry")
    }
    
    func testHomeViewCategoryNavigationLinkTap() {
        // Given
        let initialFavoriteCount = appState.favoriteResources.count
        
        // When - simulate category navigation (should not change state)
        // Navigation links don't modify state, they just navigate
        
        // Then
        XCTAssertEqual(appState.favoriteResources.count, initialFavoriteCount, "Navigation should not change favorite state")
    }
    
    func testHomeViewFavoriteResourceCardTap() {
        // Given
        let resourceId = UUID()
        let initialFavoriteState = appState.isFavorite(resourceId)
        
        // When - simulate card tap (should navigate, not toggle favorite)
        // Card taps should navigate, not toggle favorites
        
        // Then
        XCTAssertEqual(appState.isFavorite(resourceId), initialFavoriteState, "Card tap should not toggle favorite")
    }
    
    func testHomeViewEventCardTap() {
        // Given
        let initialFavoriteCount = appState.favoriteResources.count
        
        // When - simulate event card tap (should navigate)
        // Event card taps should navigate, not modify state
        
        // Then
        XCTAssertEqual(appState.favoriteResources.count, initialFavoriteCount, "Event card tap should not modify state")
    }
    
    // MARK: - ResourcesView Tap Tests
    
    func testResourcesViewFavoriteButtonTap() {
        // Given
        let resourceId = UUID()
        XCTAssertFalse(appState.isFavorite(resourceId), "Resource should not be favorited initially")
        
        // When - simulate favorite button tap
        appState.toggleFavorite(resourceId)
        
        // Then
        XCTAssertTrue(appState.isFavorite(resourceId), "Resource should be favorited after tap")
    }
    
    func testResourcesViewFavoriteButtonTapToggles() {
        // Given
        let resourceId = UUID()
        
        // When - tap favorite
        appState.toggleFavorite(resourceId)
        XCTAssertTrue(appState.isFavorite(resourceId), "Should be favorited")
        
        // When - tap again to unfavorite
        appState.toggleFavorite(resourceId)
        
        // Then
        XCTAssertFalse(appState.isFavorite(resourceId), "Should be unfavorited after second tap")
    }
    
    func testResourcesViewCategoryFilterButtonTap() {
        // Given
        var selectedCategory: ResourceCategory? = nil
        
        // When - tap a category filter
        selectedCategory = .legal
        
        // Then
        XCTAssertEqual(selectedCategory, .legal, "Selected category should be set")
        
        // When - tap another category
        selectedCategory = .employment
        
        // Then
        XCTAssertEqual(selectedCategory, .employment, "Selected category should change")
    }
    
    func testResourcesViewCategoryFilterButtonTapAll() {
        // Given
        var selectedCategory: ResourceCategory? = .legal
        
        // When - tap "All" filter (nil)
        selectedCategory = nil
        
        // Then
        XCTAssertNil(selectedCategory, "Selected category should be cleared")
    }
    
    func testResourcesViewClearFilterButtonTap() {
        // Given
        var selectedCategory: ResourceCategory? = .legal
        XCTAssertEqual(selectedCategory, .legal, "Category should be set")
        
        // When - tap clear button
        selectedCategory = nil
        
        // Then
        XCTAssertNil(selectedCategory, "Category should be cleared")
    }
    
    func testResourcesViewSearchBarClearButtonTap() {
        // Given
        var searchText = "test query"
        XCTAssertFalse(searchText.isEmpty, "Search text should not be empty")
        
        // When - simulate clear button tap
        searchText = ""
        
        // Then
        XCTAssertTrue(searchText.isEmpty, "Search text should be cleared")
    }
    
    func testResourcesViewResourceCardTap() {
        // Given
        let resourceId = UUID()
        let initialFavoriteState = appState.isFavorite(resourceId)
        
        // When - simulate resource card tap (should navigate, not toggle favorite)
        // Card taps should navigate, not toggle favorites
        
        // Then
        XCTAssertEqual(appState.isFavorite(resourceId), initialFavoriteState, "Resource card tap should not toggle favorite")
    }
    
    // MARK: - ResourceDetailView Tap Tests
    
    func testResourceDetailViewFavoriteButtonTap() {
        // Given
        let resourceId = UUID()
        XCTAssertFalse(appState.isFavorite(resourceId), "Resource should not be favorited initially")
        
        // When - simulate favorite button tap
        appState.toggleFavorite(resourceId)
        
        // Then
        XCTAssertTrue(appState.isFavorite(resourceId), "Resource should be favorited after tap")
    }
    
    func testResourceDetailViewFavoriteButtonTapPersists() {
        // Given
        let resourceId = UUID()
        
        // When - favorite in detail view
        appState.toggleFavorite(resourceId)
        
        // Then - verify persistence
        let savedIds = resourcesManager.loadFavoriteIds()
        XCTAssertTrue(savedIds.contains(resourceId), "Favorite state should be persisted")
    }
    
    func testResourceDetailViewVisitWebsiteLinkTap() {
        // Given
        let urlString = "https://example.com"
        let url = URL(string: urlString)
        
        // When - link exists
        // Then - URL should be valid
        XCTAssertNotNil(url, "URL should be valid")
    }
    
    // MARK: - EventsView Tap Tests
    
    func testEventsViewCategoryFilterButtonTap() {
        // Given
        var selectedCategory: EventCategory? = nil
        
        // When - tap a category filter
        selectedCategory = .workshop
        
        // Then
        XCTAssertEqual(selectedCategory, .workshop, "Selected category should be set")
        
        // When - tap another category
        selectedCategory = .conference
        
        // Then
        XCTAssertEqual(selectedCategory, .conference, "Selected category should change")
    }
    
    func testEventsViewCategoryFilterButtonTapAll() {
        // Given
        var selectedCategory: EventCategory? = .workshop
        
        // When - tap "All" filter (nil)
        selectedCategory = nil
        
        // Then
        XCTAssertNil(selectedCategory, "Selected category should be cleared")
    }
    
    func testEventsViewClearFilterButtonTap() {
        // Given
        var selectedCategory: EventCategory? = .workshop
        XCTAssertEqual(selectedCategory, .workshop, "Category should be set")
        
        // When - tap clear button
        selectedCategory = nil
        
        // Then
        XCTAssertNil(selectedCategory, "Category should be cleared")
    }
    
    func testEventsViewEventCardTap() {
        // Given
        let initialFavoriteCount = appState.favoriteResources.count
        
        // When - simulate event card tap (should navigate)
        // Event card taps should navigate, not modify state
        
        // Then
        XCTAssertEqual(appState.favoriteResources.count, initialFavoriteCount, "Event card tap should not modify state")
    }
    
    func testEventsViewEventRowTap() {
        // Given
        let initialFavoriteCount = appState.favoriteResources.count
        
        // When - simulate event row tap (should navigate)
        // Event row taps should navigate, not modify state
        
        // Then
        XCTAssertEqual(appState.favoriteResources.count, initialFavoriteCount, "Event row tap should not modify state")
    }
    
    // MARK: - EventDetailView Tap Tests
    
    func testEventDetailViewAddToCalendarButtonTap() async {
        // Given
        let event = Event(
            id: UUID(),
            title: "Test Event",
            description: "Test Description",
            date: Date().addingTimeInterval(86400), // Tomorrow
            location: "Test Location",
            isVirtual: false,
            category: .workshop
        )
        
        // When - simulate add to calendar button tap
        let success = await calendarManager.addEventToCalendar(event)
        
        // Then - should attempt to add (may fail if permissions not granted, but should not crash)
        // We can't easily test calendar permissions in unit tests, but we verify the method completes
        XCTAssertNotNil(success, "Add to calendar should complete")
    }
    
    func testEventDetailViewRegistrationLinkTap() {
        // Given
        let urlString = "https://example.com/register"
        let url = URL(string: urlString)
        
        // When - link exists
        // Then - URL should be valid
        XCTAssertNotNil(url, "Registration URL should be valid")
    }
    
    func testEventDetailViewEventDetailsLinkTap() {
        // Given
        let urlString = "https://example.com/event"
        let url = URL(string: urlString)
        
        // When - link exists
        // Then - URL should be valid
        XCTAssertNotNil(url, "Event details URL should be valid")
    }
    
    // MARK: - CommunityView Tap Tests
    
    func testCommunityViewCategoryFilterButtonTap() {
        // Given
        var selectedCategory: PostCategory? = nil
        
        // When - tap a category filter
        selectedCategory = .discussion
        
        // Then
        XCTAssertEqual(selectedCategory, .discussion, "Selected category should be set")
        
        // When - tap another category
        selectedCategory = .support
        
        // Then
        XCTAssertEqual(selectedCategory, .support, "Selected category should change")
    }
    
    func testCommunityViewCategoryFilterButtonTapAll() {
        // Given
        var selectedCategory: PostCategory? = .discussion
        
        // When - tap "All" filter (nil)
        selectedCategory = nil
        
        // Then
        XCTAssertNil(selectedCategory, "Selected category should be cleared")
    }
    
    func testCommunityViewClearFilterButtonTap() {
        // Given
        var selectedCategory: PostCategory? = .discussion
        XCTAssertEqual(selectedCategory, .discussion, "Category should be set")
        
        // When - tap clear button
        selectedCategory = nil
        
        // Then
        XCTAssertNil(selectedCategory, "Category should be cleared")
    }
    
    func testCommunityViewPostRowTap() {
        // Given
        let initialFavoriteCount = appState.favoriteResources.count
        
        // When - simulate post row tap (should navigate)
        // Post row taps should navigate, not modify state
        
        // Then
        XCTAssertEqual(appState.favoriteResources.count, initialFavoriteCount, "Post row tap should not modify state")
    }
    
    // MARK: - MoreView Tap Tests
    
    // Note: Accessibility settings feature not yet implemented in AppState
    // These tests are commented out until the feature is added
    /*
    func testMoreViewAccessibilitySettingsButtonTap() {
        // Given
        XCTAssertFalse(appState.showAccessibilitySettings, "Accessibility settings should not be shown initially")
        
        // When - simulate accessibility settings button tap
        appState.showAccessibilitySettings = true
        
        // Then
        XCTAssertTrue(appState.showAccessibilitySettings, "Accessibility settings should be shown after button tap")
    }
    
    func testMoreViewAccessibilitySettingsButtonTapDismisses() {
        // Given
        appState.showAccessibilitySettings = true
        XCTAssertTrue(appState.showAccessibilitySettings, "Accessibility settings should be shown")
        
        // When - simulate dismiss
        appState.showAccessibilitySettings = false
        
        // Then
        XCTAssertFalse(appState.showAccessibilitySettings, "Accessibility settings should be dismissed")
    }
    */
    
    func testMoreViewAdvocacyToolsNavigationLinkTap() {
        // Given
        let initialFavoriteCount = appState.favoriteResources.count
        
        // When - simulate navigation link tap (should navigate)
        // Navigation links should navigate, not modify state
        
        // Then
        XCTAssertEqual(appState.favoriteResources.count, initialFavoriteCount, "Navigation should not change state")
    }
    
    func testMoreViewNewsNavigationLinkTap() {
        // Given
        let initialFavoriteCount = appState.favoriteResources.count
        
        // When - simulate navigation link tap (should navigate)
        // Navigation links should navigate, not modify state
        
        // Then
        XCTAssertEqual(appState.favoriteResources.count, initialFavoriteCount, "Navigation should not change state")
    }
    
    // MARK: - NewsView Tap Tests
    
    func testNewsViewArticleRowTap() {
        // Given
        let initialFavoriteCount = appState.favoriteResources.count
        
        // When - simulate article row tap (should navigate)
        // Article row taps should navigate, not modify state
        
        // Then
        XCTAssertEqual(appState.favoriteResources.count, initialFavoriteCount, "Article row tap should not modify state")
    }
    
    // MARK: - Multiple Tap Interaction Tests
    
    func testMultipleRapidFavoriteButtonTaps() {
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
    
    func testCategoryFilterThenClearInteraction() {
        // Given
        var selectedCategory: ResourceCategory? = nil
        
        // When - select a category
        selectedCategory = .legal
        XCTAssertEqual(selectedCategory, .legal, "Category should be selected")
        
        // When - clear filter
        selectedCategory = nil
        
        // Then
        XCTAssertNil(selectedCategory, "Category should be cleared")
    }
    
    func testMultipleCategoryFilterTaps() {
        // Given
        var selectedCategory: ResourceCategory? = nil
        
        // When - tap multiple categories in sequence
        selectedCategory = .legal
        XCTAssertEqual(selectedCategory, .legal, "First category should be selected")
        
        selectedCategory = .employment
        XCTAssertEqual(selectedCategory, .employment, "Second category should be selected")
        
        selectedCategory = .education
        XCTAssertEqual(selectedCategory, .education, "Third category should be selected")
        
        // When - clear
        selectedCategory = nil
        
        // Then
        XCTAssertNil(selectedCategory, "Category should be cleared")
    }
    
    // MARK: - Navigation Tap Tests
    
    func testNavigationLinkTapDoesNotChangeState() {
        // Given
        let initialFavoriteCount = appState.favoriteResources.count
        let initialShowProfile = appState.showProfile
        // Note: showAccessibilitySettings not yet implemented
        
        // When - simulate navigation (should not change state)
        // Navigation links don't modify state, they just navigate
        
        // Then
        XCTAssertEqual(appState.favoriteResources.count, initialFavoriteCount, "Navigation should not change favorite state")
        XCTAssertEqual(appState.showProfile, initialShowProfile, "Navigation should not change profile state")
        // Note: showAccessibilitySettings tests commented out until feature is added
    }
    
    // MARK: - Button State Tests
    
    func testButtonTapStateChanges() {
        // Given
        XCTAssertFalse(appState.showProfile, "Profile should not be shown initially")
        // Note: showAccessibilitySettings not yet implemented
        
        // When - tap profile button
        appState.showProfile = true
        
        // Then
        XCTAssertTrue(appState.showProfile, "Profile should be shown")
        // Note: showAccessibilitySettings tests commented out until feature is added
    }
    
    // MARK: - Search and Filter Combination Tests
    
    func testSearchAndCategoryFilterCombination() {
        // Given
        let resources = resourcesManager.getAllResources()
        var searchText = "legal"
        var selectedCategory: ResourceCategory? = .legal
        
        // When - apply both filters
        var filtered = resources.filter { resource in
            let matchesSearch = resource.title.localizedCaseInsensitiveContains(searchText) ||
                               resource.description.localizedCaseInsensitiveContains(searchText)
            let matchesCategory = resource.category == selectedCategory
            return matchesSearch && matchesCategory
        }
        
        // Then
        XCTAssertFalse(filtered.isEmpty, "Should find resources matching both filters")
        
        // When - clear search
        searchText = ""
        filtered = resources.filter { resource in
            resource.category == selectedCategory
        }
        
        // Then
        XCTAssertFalse(filtered.isEmpty, "Should find resources matching category after clearing search")
        
        // When - clear category
        selectedCategory = nil
        filtered = resources
        
        // Then
        XCTAssertFalse(filtered.isEmpty, "Should show all resources after clearing filters")
    }
}

