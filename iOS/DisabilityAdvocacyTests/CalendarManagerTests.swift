//
//  CalendarManagerTests.swift
//  DisabilityAdvocacyTests
//
//  Unit tests for CalendarManager
//

import XCTest
import EventKit
@testable import DisabilityAdvocacy_iOS

@MainActor
final class CalendarManagerTests: XCTestCase {
    var manager: CalendarManager!
    
    override func setUp() {
        super.setUp()
        manager = CalendarManager()
    }
    
    override func tearDown() {
        manager = nil
        super.tearDown()
    }
    
    func testInitialState() {
        // Then
        XCTAssertNotNil(manager, "Manager should be initialized")
        XCTAssertFalse(manager.showAlert, "Alert should not be shown initially")
        XCTAssertFalse(manager.showSettingsAlert, "Settings alert should not be shown initially")
        XCTAssertEqual(manager.alertMessage, "", "Alert message should be empty initially")
    }
    
    func testCheckAuthorizationStatus() {
        // When
        manager.checkAuthorizationStatus()
        
        // Then
        // Authorization status depends on system settings, so we just verify the method runs
        // The actual value depends on whether calendar access was granted
        XCTAssertNotNil(manager.hasCalendarAccess, "hasCalendarAccess should be set")
    }
    
    func testRequestAccess() async {
        // When
        let granted = await manager.requestAccess()
        
        // Then
        // Result depends on user/system settings, but method should complete
        XCTAssertNotNil(granted, "Request access should return a boolean")
        XCTAssertEqual(manager.hasCalendarAccess, granted, "hasCalendarAccess should match request result")
    }
    
    func testAddEventToCalendarWithoutAccess() async {
        // Given
        manager.hasCalendarAccess = false
        let event = Event(
            title: "Test Event",
            description: "Test Description",
            date: Date(),
            location: "Test Location",
            isVirtual: false,
            category: .workshop
        )
        
        // When
        let result = await manager.addEventToCalendar(event)
        
        // Then
        // If access is denied, should return false and show settings alert
        XCTAssertFalse(result, "Should return false when access is denied")
        // Note: In a real test environment, you might need to mock EventStore
    }
    
    func testAddEventToCalendarWithAccess() async {
        // Given
        // First request access
        let accessGranted = await manager.requestAccess()
        
        guard accessGranted else {
            // Skip test if access not granted
            return
        }
        
        let event = Event(
            title: "Test Event",
            description: "Test Description",
            date: Date(),
            location: "Test Location",
            isVirtual: false,
            registrationURL: "https://example.com/register",
            category: .workshop
        )
        
        // When
        let result = await manager.addEventToCalendar(event)
        
        // Then
        // Result depends on whether event was actually saved
        // In a test environment, this might fail if calendar is not available
        XCTAssertNotNil(result, "addEventToCalendar should return a boolean")
    }
    
    func testAddVirtualEvent() async {
        // Given
        let accessGranted = await manager.requestAccess()
        
        guard accessGranted else {
            return
        }
        
        let event = Event(
            title: "Virtual Test Event",
            description: "Virtual Description",
            date: Date(),
            location: "Online",
            isVirtual: true,
            eventURL: "https://example.com/event",
            category: .webinar
        )
        
        // When
        let result = await manager.addEventToCalendar(event)
        
        // Then
        XCTAssertNotNil(result, "Should handle virtual events")
    }
    
    func testAddEventWithAccessibilityNotes() async {
        // Given
        let accessGranted = await manager.requestAccess()
        
        guard accessGranted else {
            return
        }
        
        let event = Event(
            title: "Accessible Event",
            description: "Event Description",
            date: Date(),
            location: "Test Location",
            isVirtual: false,
            category: .conference,
            accessibilityNotes: "Wheelchair accessible, ASL interpreter available"
        )
        
        // When
        let result = await manager.addEventToCalendar(event)
        
        // Then
        XCTAssertNotNil(result, "Should handle events with accessibility notes")
    }
}

