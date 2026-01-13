//
//  EventModelTests.swift
//  DisabilityAdvocacyTests
//
//  Unit tests for Event model
//

import XCTest
@testable import DisabilityAdvocacy_iOS

final class EventModelTests: XCTestCase {
    
    // MARK: - Initialization Tests
    
    func testInitialization_WithAllParameters() {
        // Given
        let id = UUID()
        let title = "Test Event"
        let description = "Test Description"
        let date = Date()
        let location = "Test Location"
        let isVirtual = true
        let registrationURL = "https://register.com"
        let eventURL = "https://event.com"
        let category = EventCategory.workshop
        let accessibilityNotes = "Accessibility info"
        
        // When
        let event = Event(
            id: id,
            title: title,
            description: description,
            date: date,
            location: location,
            isVirtual: isVirtual,
            registrationURL: registrationURL,
            eventURL: eventURL,
            category: category,
            accessibilityNotes: accessibilityNotes
        )
        
        // Then
        XCTAssertEqual(event.id, id)
        XCTAssertEqual(event.title, title)
        XCTAssertEqual(event.description, description)
        XCTAssertEqual(event.date, date)
        XCTAssertEqual(event.location, location)
        XCTAssertEqual(event.isVirtual, isVirtual)
        XCTAssertEqual(event.registrationURL, registrationURL)
        XCTAssertEqual(event.eventURL, eventURL)
        XCTAssertEqual(event.category, category)
        XCTAssertEqual(event.accessibilityNotes, accessibilityNotes)
    }
    
    func testInitialization_WithDefaultParameters() {
        // Given
        let title = "Test Event"
        let description = "Test Description"
        let date = Date()
        let location = "Test Location"
        let category = EventCategory.workshop
        
        // When
        let event = Event(
            title: title,
            description: description,
            date: date,
            location: location,
            category: category
        )
        
        // Then
        XCTAssertNotNil(event.id, "Should generate UUID")
        XCTAssertEqual(event.title, title)
        XCTAssertEqual(event.description, description)
        XCTAssertEqual(event.date, date)
        XCTAssertEqual(event.location, location)
        XCTAssertFalse(event.isVirtual, "isVirtual should be false by default")
        XCTAssertNil(event.registrationURL, "registrationURL should be nil by default")
        XCTAssertNil(event.eventURL, "eventURL should be nil by default")
        XCTAssertEqual(event.category, category)
        XCTAssertNil(event.accessibilityNotes, "accessibilityNotes should be nil by default")
    }
    
    // MARK: - Codable Tests
    
    func testEncodingAndDecoding() throws {
        // Given
        let event = Event(
            title: "Test Event",
            description: "Test Description",
            date: Date(),
            location: "Test Location",
            isVirtual: true,
            registrationURL: "https://register.com",
            eventURL: "https://event.com",
            category: .workshop,
            accessibilityNotes: "Accessibility info"
        )
        
        // When
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(event)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let decoded = try decoder.decode(Event.self, from: data)
        
        // Then
        XCTAssertEqual(decoded.id, event.id)
        XCTAssertEqual(decoded.title, event.title)
        XCTAssertEqual(decoded.description, event.description)
        XCTAssertLessThanOrEqual(abs(decoded.date.timeIntervalSince(event.date)), 1.0)
        XCTAssertEqual(decoded.location, event.location)
        XCTAssertEqual(decoded.isVirtual, event.isVirtual)
        XCTAssertEqual(decoded.registrationURL, event.registrationURL)
        XCTAssertEqual(decoded.eventURL, event.eventURL)
        XCTAssertEqual(decoded.category, event.category)
        XCTAssertEqual(decoded.accessibilityNotes, event.accessibilityNotes)
    }
    
    // MARK: - EventCategory Tests
    
    func testEventCategory_AllCases() {
        // Then
        let allCases = EventCategory.allCases
        XCTAssertFalse(allCases.isEmpty, "Should have categories")
        XCTAssertTrue(allCases.contains(.workshop), "Should contain workshop category")
        XCTAssertTrue(allCases.contains(.conference), "Should contain conference category")
        XCTAssertTrue(allCases.contains(.webinar), "Should contain webinar category")
    }
    
    func testEventCategory_RawValues() {
        // Then
        XCTAssertEqual(EventCategory.workshop.rawValue, "Workshop")
        XCTAssertEqual(EventCategory.conference.rawValue, "Conference")
        XCTAssertEqual(EventCategory.webinar.rawValue, "Webinar")
        XCTAssertEqual(EventCategory.rally.rawValue, "Rally")
        XCTAssertEqual(EventCategory.meeting.rawValue, "Community Meeting")
        XCTAssertEqual(EventCategory.training.rawValue, "Training")
    }
    
    func testEventCategory_Icons() {
        // Then
        XCTAssertFalse(EventCategory.workshop.icon.isEmpty, "Should have icon")
        XCTAssertFalse(EventCategory.conference.icon.isEmpty, "Should have icon")
        // All categories should have icons
        for category in EventCategory.allCases {
            XCTAssertFalse(category.icon.isEmpty, "Category \(category.rawValue) should have icon")
        }
    }
    
    func testEventCategory_Codable() throws {
        // Given
        let category = EventCategory.workshop
        
        // When
        let encoder = JSONEncoder()
        let data = try encoder.encode(category)
        
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(EventCategory.self, from: data)
        
        // Then
        XCTAssertEqual(decoded, category)
    }
    
    // MARK: - Identifiable Tests
    
    func testIdentifiable_HasId() {
        // Given
        let event = Event(title: "Test", description: "Desc", date: Date(), location: "Loc", category: .workshop)
        
        // Then
        XCTAssertNotNil(event.id, "Should have id for Identifiable")
    }
    
    // MARK: - Date Handling Tests
    
    func testDateComparison() {
        // Given
        let pastDate = Date().addingTimeInterval(-86400)
        let futureDate = Date().addingTimeInterval(86400)
        let pastEvent = Event(title: "Past", description: "Desc", date: pastDate, location: "Loc", category: .workshop)
        let futureEvent = Event(title: "Future", description: "Desc", date: futureDate, location: "Loc", category: .workshop)
        
        // Then
        XCTAssertTrue(pastEvent.date < futureEvent.date, "Past event should be before future event")
    }
    
    // MARK: - Virtual Events Tests
    
    func testIsVirtual_True() {
        // Given
        let event = Event(
            title: "Virtual Event",
            description: "Desc",
            date: Date(),
            location: "Online",
            isVirtual: true,
            category: .webinar
        )
        
        // Then
        XCTAssertTrue(event.isVirtual, "Should be virtual")
    }
    
    func testIsVirtual_False() {
        // Given
        let event = Event(
            title: "In-Person Event",
            description: "Desc",
            date: Date(),
            location: "Physical Location",
            isVirtual: false,
            category: .workshop
        )
        
        // Then
        XCTAssertFalse(event.isVirtual, "Should not be virtual")
    }
}

