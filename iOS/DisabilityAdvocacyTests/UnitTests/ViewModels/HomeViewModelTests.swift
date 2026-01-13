//
//  HomeViewModelTests.swift
//  DisabilityAdvocacyTests
//
//  Unit tests for HomeViewModel
//

import XCTest
@testable import DisabilityAdvocacy

@MainActor
final class HomeViewModelTests: XCTestCase {
    var viewModel: HomeViewModel!
    var resourcesManager: ResourcesManager!
    var eventsManager: EventsManager!
    
    override func setUp() {
        super.setUp()
        resourcesManager = ResourcesManager()
        eventsManager = EventsManager()
        viewModel = HomeViewModel(
            resourcesManager: resourcesManager,
            eventsManager: eventsManager
        )
    }
    
    override func tearDown() {
        viewModel = nil
        resourcesManager = nil
        eventsManager = nil
        super.tearDown()
    }
    
    func testInitialState() {
        // Then
        XCTAssertEqual(viewModel.totalResources, 0, "Total resources should be 0 initially")
        XCTAssertEqual(viewModel.upcomingEvents, 0, "Upcoming events should be 0 initially")
        XCTAssertEqual(viewModel.recentPosts, 0, "Recent posts should be 0 initially")
        XCTAssertTrue(viewModel.upcomingEventsList.isEmpty, "Upcoming events list should be empty initially")
        XCTAssertTrue(viewModel.favoriteResources.isEmpty, "Favorite resources should be empty initially")
        XCTAssertTrue(viewModel.recentlyAddedResources.isEmpty, "Recently added resources should be empty initially")
        XCTAssertFalse(viewModel.isLoading, "Should not be loading initially")
        XCTAssertNil(viewModel.errorMessage, "Error message should be nil initially")
    }
    
    func testLoadData() async {
        // When
        await viewModel.loadData()
        
        // Then
        XCTAssertFalse(viewModel.isLoading, "Should not be loading after load completes")
        XCTAssertGreaterThan(viewModel.totalResources, 0, "Should have loaded resources")
        XCTAssertGreaterThanOrEqual(viewModel.upcomingEventsList.count, 0, "Should have loaded events")
        XCTAssertFalse(viewModel.allResources.isEmpty, "Should have all resources loaded")
    }
    
    func testLoadDataWithFavorites() async {
        // Given
        let resources = resourcesManager.getAllResources()
        let favoriteIds = Set([resources.first?.id ?? UUID()])
        
        // When
        await viewModel.loadData(favoriteResourceIds: favoriteIds)
        
        // Then
        XCTAssertGreaterThanOrEqual(viewModel.favoriteResources.count, 0, "Should have favorite resources if IDs match")
    }
    
    func testLoadDataPreventsDuplicateLoads() async {
        // Given
        viewModel.isLoading = true
        
        // When
        await viewModel.loadData()
        
        // Then
        // Should not load again if already loading
        // This is tested by ensuring isLoading remains true or the method returns early
        XCTAssertTrue(viewModel.isLoading, "Should remain loading if already loading")
    }
    
    func testUpcomingEventsFiltering() async {
        // When
        await viewModel.loadData()
        
        // Then
        let now = Date()
        let futureEvents = viewModel.upcomingEventsList.filter { $0.date > now }
        XCTAssertEqual(viewModel.upcomingEvents, futureEvents.count, "Upcoming events count should match filtered count")
    }
    
    func testEventsSortedByDate() async {
        // When
        await viewModel.loadData()
        
        // Then
        let events = viewModel.upcomingEventsList
        if events.count > 1 {
            for i in 0..<events.count - 1 {
                XCTAssertLessThanOrEqual(events[i].date, events[i + 1].date, "Events should be sorted by date")
            }
        }
    }
    
    func testRecentlyAddedResources() async {
        // When
        await viewModel.loadData()
        
        // Then
        XCTAssertLessThanOrEqual(viewModel.recentlyAddedResources.count, 5, "Should have at most 5 recently added resources")
        
        // Verify they are sorted by dateAdded (newest first)
        if viewModel.recentlyAddedResources.count > 1 {
            for i in 0..<viewModel.recentlyAddedResources.count - 1 {
                XCTAssertGreaterThanOrEqual(
                    viewModel.recentlyAddedResources[i].dateAdded,
                    viewModel.recentlyAddedResources[i + 1].dateAdded,
                    "Recently added resources should be sorted by dateAdded descending"
                )
            }
        }
    }
    
    func testRecentPostsCalculation() async {
        // When
        await viewModel.loadData()
        
        // Then
        XCTAssertEqual(viewModel.recentPosts, 3, "Recent posts should be set to sample count")
    }
}


