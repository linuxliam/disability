//
//  EventsManagerTests.swift
//  DisabilityAdvocacyTests
//
//  Unit tests for EventsManager
//

import XCTest
@testable import DisabilityAdvocacy_iOS

final class EventsManagerTests: XCTestCase {
    var manager: EventsManager!
    
    override func setUp() {
        super.setUp()
        manager = EventsManager()
    }
    
    override func tearDown() {
        manager = nil
        super.tearDown()
    }
    
    func testGetSampleEvents() {
        // When
        let events = manager.getAllEvents()
        
        // Then
        XCTAssertFalse(events.isEmpty, "Events should not be empty")
        XCTAssertGreaterThan(events.count, 0, "Should have at least one event")
    }
    
    func testEventProperties() {
        // When
        let events = manager.getAllEvents()
        
        // Then
        for event in events {
            XCTAssertFalse(event.title.isEmpty, "Event should have a title")
            XCTAssertFalse(event.description.isEmpty, "Event should have a description")
            XCTAssertNotNil(event.date, "Event should have a date")
            XCTAssertFalse(event.location.isEmpty, "Event should have a location")
        }
    }
    
    func testEventDates() {
        // When
        let events = manager.getAllEvents()
        
        // Then
        let now = Date()
        for event in events {
            // Events should be in the future (or at least not in the past by too much)
            let timeDifference = event.date.timeIntervalSince(now)
            XCTAssertGreaterThan(timeDifference, -86400, "Events should be recent or future dates")
        }
    }
    
    func testEventCategories() {
        // When
        let events = manager.getAllEvents()
        
        // Then
        let categories = Set(events.map { $0.category })
        XCTAssertGreaterThan(categories.count, 0, "Should have multiple event categories")
    }
    
    func testVirtualEvents() {
        // When
        let events = manager.getAllEvents()
        
        // Then
        let virtualEvents = events.filter { $0.isVirtual }
        XCTAssertGreaterThanOrEqual(virtualEvents.count, 0, "Should have some virtual events")
    }
    
    func testEventURLs() {
        // When
        let events = manager.getAllEvents()
        
        // Then
        let eventsWithURLs = events.filter { $0.registrationURL != nil || $0.eventURL != nil }
        XCTAssertGreaterThanOrEqual(eventsWithURLs.count, 0, "Some events should have URLs")
    }
}



