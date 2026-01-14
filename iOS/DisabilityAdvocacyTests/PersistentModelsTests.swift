//
//  PersistentModelsTests.swift
//  DisabilityAdvocacyTests
//
//  Unit tests for PersistentModels (SwiftData models)
//

import XCTest
@testable import DisabilityAdvocacy_iOS

final class PersistentModelsTests: XCTestCase {
    
    // MARK: - PersistentResource Tests
    
    func testPersistentResource_InitFromResource_CopiesAllProperties() {
        // Given
        let resource = TestDataFactory.makeResource()
        
        // When
        let persistent = PersistentResource(from: resource)
        
        // Then
        XCTAssertEqual(persistent.id, resource.id)
        XCTAssertEqual(persistent.title, resource.title)
        XCTAssertEqual(persistent.resourceDescription, resource.description)
        XCTAssertEqual(persistent.category, resource.category.rawValue)
        XCTAssertEqual(persistent.url, resource.url)
        XCTAssertEqual(persistent.tags, resource.tags)
        XCTAssertEqual(persistent.dateAdded, resource.dateAdded)
        XCTAssertFalse(persistent.isFavorite, "isFavorite should default to false")
    }
    
    func testPersistentResource_ToResource_ConvertsBack() {
        // Given
        let originalResource = TestDataFactory.makeResource()
        let persistent = PersistentResource(from: originalResource)
        
        // When
        let convertedResource = persistent.toResource()
        
        // Then
        XCTAssertEqual(convertedResource.id, originalResource.id)
        XCTAssertEqual(convertedResource.title, originalResource.title)
        XCTAssertEqual(convertedResource.description, originalResource.description)
        XCTAssertEqual(convertedResource.category, originalResource.category)
        XCTAssertEqual(convertedResource.url, originalResource.url)
        XCTAssertEqual(convertedResource.tags, originalResource.tags)
    }
    
    func testPersistentResource_ToResource_HandlesInvalidCategory() {
        // Given
        let persistent = PersistentResource(from: TestDataFactory.makeResource())
        persistent.category = "InvalidCategory"
        
        // When
        let resource = persistent.toResource()
        
        // Then
        // Should default to .legal when category is invalid
        XCTAssertEqual(resource.category, .legal, "Should default to .legal for invalid category")
    }
    
    // MARK: - PersistentEvent Tests
    
    func testPersistentEvent_InitFromEvent_CopiesAllProperties() {
        // Given
        let event = TestDataFactory.makeEvent()
        
        // When
        let persistent = PersistentEvent(from: event)
        
        // Then
        XCTAssertEqual(persistent.id, event.id)
        XCTAssertEqual(persistent.title, event.title)
        XCTAssertEqual(persistent.eventDescription, event.description)
        XCTAssertEqual(persistent.date, event.date)
        XCTAssertEqual(persistent.location, event.location)
        XCTAssertEqual(persistent.isVirtual, event.isVirtual)
        XCTAssertEqual(persistent.registrationURL, event.registrationURL)
        XCTAssertEqual(persistent.eventURL, event.eventURL)
        XCTAssertEqual(persistent.category, event.category.rawValue)
        XCTAssertEqual(persistent.accessibilityNotes, event.accessibilityNotes)
    }
    
    func testPersistentEvent_ToEvent_ConvertsBack() {
        // Given
        let originalEvent = TestDataFactory.makeEvent()
        let persistent = PersistentEvent(from: originalEvent)
        
        // When
        let convertedEvent = persistent.toEvent()
        
        // Then
        XCTAssertEqual(convertedEvent.id, originalEvent.id)
        XCTAssertEqual(convertedEvent.title, originalEvent.title)
        XCTAssertEqual(convertedEvent.description, originalEvent.description)
        XCTAssertEqual(convertedEvent.date, originalEvent.date)
        XCTAssertEqual(convertedEvent.location, originalEvent.location)
        XCTAssertEqual(convertedEvent.isVirtual, originalEvent.isVirtual)
        XCTAssertEqual(convertedEvent.category, originalEvent.category)
    }
    
    func testPersistentEvent_ToEvent_HandlesInvalidCategory() {
        // Given
        let persistent = PersistentEvent(from: TestDataFactory.makeEvent())
        persistent.category = "InvalidCategory"
        
        // When
        let event = persistent.toEvent()
        
        // Then
        // Should default to .workshop when category is invalid
        XCTAssertEqual(event.category, .workshop, "Should default to .workshop for invalid category")
    }
    
    // MARK: - PersistentUser Tests
    
    func testPersistentUser_InitFromUser_CopiesAllProperties() {
        // Given
        let user = TestDataFactory.makeUser()
        
        // When
        let persistent = PersistentUser(from: user)
        
        // Then
        XCTAssertEqual(persistent.id, user.id)
        XCTAssertEqual(persistent.name, user.name)
        XCTAssertEqual(persistent.email, user.email)
        XCTAssertEqual(persistent.phoneNumber, user.phoneNumber)
        XCTAssertEqual(persistent.bio, user.bio)
        XCTAssertEqual(persistent.location, user.location)
        XCTAssertEqual(persistent.interests, user.interests)
        XCTAssertEqual(persistent.accessibilityNeeds, user.accessibilityNeeds)
        XCTAssertEqual(persistent.eventReminders, user.notificationPreferences.eventReminders)
        XCTAssertEqual(persistent.newResources, user.notificationPreferences.newResources)
        XCTAssertEqual(persistent.communityUpdates, user.notificationPreferences.communityUpdates)
        XCTAssertEqual(persistent.newsUpdates, user.notificationPreferences.newsUpdates)
    }
    
    func testPersistentUser_ToUser_ConvertsBack() {
        // Given
        let originalUser = TestDataFactory.makeUser()
        let persistent = PersistentUser(from: originalUser)
        
        // When
        let convertedUser = persistent.toUser()
        
        // Then
        XCTAssertEqual(convertedUser.id, originalUser.id)
        XCTAssertEqual(convertedUser.name, originalUser.name)
        XCTAssertEqual(convertedUser.email, originalUser.email)
        XCTAssertEqual(convertedUser.phoneNumber, originalUser.phoneNumber)
        XCTAssertEqual(convertedUser.bio, originalUser.bio)
        XCTAssertEqual(convertedUser.location, originalUser.location)
        XCTAssertEqual(convertedUser.interests, originalUser.interests)
        XCTAssertEqual(convertedUser.accessibilityNeeds, originalUser.accessibilityNeeds)
        XCTAssertEqual(convertedUser.notificationPreferences.eventReminders, originalUser.notificationPreferences.eventReminders)
        XCTAssertEqual(convertedUser.notificationPreferences.newResources, originalUser.notificationPreferences.newResources)
        XCTAssertEqual(convertedUser.notificationPreferences.communityUpdates, originalUser.notificationPreferences.communityUpdates)
        XCTAssertEqual(convertedUser.notificationPreferences.newsUpdates, originalUser.notificationPreferences.newsUpdates)
    }
    
    // MARK: - Round Trip Tests
    
    func testPersistentResource_RoundTrip_PreservesData() {
        // Given
        let original = TestDataFactory.makeResource()
        
        // When
        let persistent = PersistentResource(from: original)
        let converted = persistent.toResource()
        
        // Then
        XCTAssertEqual(converted.id, original.id)
        XCTAssertEqual(converted.title, original.title)
        XCTAssertEqual(converted.description, original.description)
        XCTAssertEqual(converted.category, original.category)
    }
    
    func testPersistentEvent_RoundTrip_PreservesData() {
        // Given
        let original = TestDataFactory.makeEvent()
        
        // When
        let persistent = PersistentEvent(from: original)
        let converted = persistent.toEvent()
        
        // Then
        XCTAssertEqual(converted.id, original.id)
        XCTAssertEqual(converted.title, original.title)
        XCTAssertEqual(converted.date, original.date)
        XCTAssertEqual(converted.location, original.location)
    }
    
    func testPersistentUser_RoundTrip_PreservesData() {
        // Given
        let original = TestDataFactory.makeUser()
        
        // When
        let persistent = PersistentUser(from: original)
        let converted = persistent.toUser()
        
        // Then
        XCTAssertEqual(converted.id, original.id)
        XCTAssertEqual(converted.name, original.name)
        XCTAssertEqual(converted.email, original.email)
        XCTAssertEqual(converted.notificationPreferences.eventReminders, original.notificationPreferences.eventReminders)
    }
}
