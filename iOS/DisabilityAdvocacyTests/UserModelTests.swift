//
//  UserModelTests.swift
//  DisabilityAdvocacyTests
//
//  Unit tests for User model
//

import XCTest
@testable import DisabilityAdvocacy

final class UserModelTests: XCTestCase {
    
    // MARK: - Initialization Tests
    
    func testInitialization_WithAllParameters() {
        // Given
        let id = UUID()
        let name = "Test User"
        let email = "test@example.com"
        let phoneNumber = "123-456-7890"
        let bio = "Test Bio"
        let location = "Test Location"
        let interests = ["Interest 1", "Interest 2"]
        let accessibilityNeeds = ["Need 1", "Need 2"]
        let notificationPreferences = NotificationPreferences(
            eventReminders: true,
            newResources: false,
            communityUpdates: true,
            newsUpdates: false
        )
        
        // When
        var user = User(
            id: id,
            name: name,
            email: email,
            phoneNumber: phoneNumber,
            bio: bio,
            location: location,
            interests: interests,
            accessibilityNeeds: accessibilityNeeds,
            notificationPreferences: notificationPreferences
        )
        
        // Then
        XCTAssertEqual(user.id, id)
        XCTAssertEqual(user.name, name)
        XCTAssertEqual(user.email, email)
        XCTAssertEqual(user.phoneNumber, phoneNumber)
        XCTAssertEqual(user.bio, bio)
        XCTAssertEqual(user.location, location)
        XCTAssertEqual(user.interests, interests)
        XCTAssertEqual(user.accessibilityNeeds, accessibilityNeeds)
        XCTAssertEqual(user.notificationPreferences.eventReminders, notificationPreferences.eventReminders)
        XCTAssertEqual(user.notificationPreferences.newResources, notificationPreferences.newResources)
        XCTAssertEqual(user.notificationPreferences.communityUpdates, notificationPreferences.communityUpdates)
        XCTAssertEqual(user.notificationPreferences.newsUpdates, notificationPreferences.newsUpdates)
    }
    
    func testInitialization_WithDefaultParameters() {
        // When
        var user = User()
        
        // Then
        XCTAssertNotNil(user.id, "Should generate UUID")
        XCTAssertEqual(user.name, "", "Name should be empty string by default")
        XCTAssertEqual(user.email, "", "Email should be empty string by default")
        XCTAssertNil(user.phoneNumber, "Phone number should be nil by default")
        XCTAssertNil(user.bio, "Bio should be nil by default")
        XCTAssertNil(user.location, "Location should be nil by default")
        XCTAssertTrue(user.interests.isEmpty, "Interests should be empty by default")
        XCTAssertTrue(user.accessibilityNeeds.isEmpty, "Accessibility needs should be empty by default")
        XCTAssertNotNil(user.notificationPreferences, "Should have notification preferences")
    }
    
    // MARK: - Codable Tests
    
    func testEncodingAndDecoding() throws {
        // Given
        var user = User(
            name: "Test User",
            email: "test@example.com",
            phoneNumber: "123-456-7890",
            bio: "Test Bio",
            location: "Test Location",
            interests: ["Interest 1"],
            accessibilityNeeds: ["Need 1"],
            notificationPreferences: NotificationPreferences(
                eventReminders: true,
                newResources: false,
                communityUpdates: true,
                newsUpdates: false
            )
        )
        
        // When
        let encoder = JSONEncoder()
        let data = try encoder.encode(user)
        
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(User.self, from: data)
        
        // Then
        XCTAssertEqual(decoded.id, user.id)
        XCTAssertEqual(decoded.name, user.name)
        XCTAssertEqual(decoded.email, user.email)
        XCTAssertEqual(decoded.phoneNumber, user.phoneNumber)
        XCTAssertEqual(decoded.bio, user.bio)
        XCTAssertEqual(decoded.location, user.location)
        XCTAssertEqual(decoded.interests, user.interests)
        XCTAssertEqual(decoded.accessibilityNeeds, user.accessibilityNeeds)
        XCTAssertEqual(decoded.notificationPreferences.eventReminders, user.notificationPreferences.eventReminders)
        XCTAssertEqual(decoded.notificationPreferences.newResources, user.notificationPreferences.newResources)
        XCTAssertEqual(decoded.notificationPreferences.communityUpdates, user.notificationPreferences.communityUpdates)
        XCTAssertEqual(decoded.notificationPreferences.newsUpdates, user.notificationPreferences.newsUpdates)
    }
    
    // MARK: - NotificationPreferences Tests
    
    func testNotificationPreferences_DefaultValues() {
        // Given
        let preferences = NotificationPreferences()
        
        // Then
        XCTAssertTrue(preferences.eventReminders, "Event reminders should be enabled by default")
        XCTAssertTrue(preferences.newResources, "New resources should be enabled by default")
        XCTAssertTrue(preferences.communityUpdates, "Community updates should be enabled by default")
        XCTAssertFalse(preferences.newsUpdates, "News updates should be disabled by default")
    }
    
    func testNotificationPreferences_Codable() throws {
        // Given
        let preferences = NotificationPreferences(
            eventReminders: true,
            newResources: false,
            communityUpdates: true,
            newsUpdates: false
        )
        
        // When
        let encoder = JSONEncoder()
        let data = try encoder.encode(preferences)
        
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(NotificationPreferences.self, from: data)
        
        // Then
        XCTAssertEqual(decoded.eventReminders, preferences.eventReminders)
        XCTAssertEqual(decoded.newResources, preferences.newResources)
        XCTAssertEqual(decoded.communityUpdates, preferences.communityUpdates)
        XCTAssertEqual(decoded.newsUpdates, preferences.newsUpdates)
    }
}

