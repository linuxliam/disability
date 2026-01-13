//
//  EventsViewModelTests.swift
//  DisabilityAdvocacyTests
//
//  Unit tests for EventsViewModel
//

import XCTest
@testable import DisabilityAdvocacy_iOS

@MainActor
final class EventsViewModelTests: XCTestCase {
    var viewModel: EventsViewModel!
    var eventsManager: EventsManager!
    
    override func setUp() {
        super.setUp()
        eventsManager = EventsManager()
        viewModel = EventsViewModel(eventsManager: eventsManager)
    }
    
    override func tearDown() {
        viewModel = nil
        eventsManager = nil
        super.tearDown()
    }
    
    func testInitialState() {
        // Then
        XCTAssertTrue(viewModel.events.isEmpty, "Events should be empty initially")
        XCTAssertFalse(viewModel.isLoading, "Should not be loading initially")
        XCTAssertNil(viewModel.errorMessage, "Error message should be nil initially")
    }
    
    func testLoadEvents() async {
        // When
        await viewModel.loadEvents()
        
        // Then
        XCTAssertFalse(viewModel.isLoading, "Should not be loading after load completes")
        XCTAssertFalse(viewModel.events.isEmpty, "Should have loaded events")
        XCTAssertNil(viewModel.errorMessage, "Should not have error message on success")
    }
    
    func testLoadEventsSetsLoadingState() async {
        // Given
        XCTAssertFalse(viewModel.isLoading, "Should not be loading initially")
        
        // When
        await viewModel.loadEvents()
        
        // Then
        XCTAssertFalse(viewModel.isLoading, "Should not be loading after completion")
    }
    
    func testLoadEventsPreventsDuplicateLoads() async {
        // Given
        viewModel.isLoading = true
        
        // When
        await viewModel.loadEvents()
        
        // Then
        // Should not load again if already loading
        XCTAssertTrue(viewModel.isLoading, "Should remain loading if already loading")
    }
    
    func testLoadEventsClearsError() async {
        // Given
        viewModel.errorMessage = "Previous error"
        
        // When
        await viewModel.loadEvents()
        
        // Then
        XCTAssertNil(viewModel.errorMessage, "Error message should be cleared on load")
    }
    
    func testEventsLoadedFromManager() async {
        // Given
        let expectedEvents = eventsManager.getAllEvents()
        
        // When
        await viewModel.loadEvents()
        
        // Then
        XCTAssertEqual(viewModel.events.count, expectedEvents.count, "Should load all events from manager")
    }
}



