//
//  DataManagerTests.swift
//  DisabilityAdvocacyTests
//
//  Unit tests for DataManager
//

import XCTest
import SwiftData
@testable import DisabilityAdvocacy_iOS

@MainActor
final class DataManagerTests: XCTestCase {
    var dataManager: DataManager!
    
    override func setUp() async throws {
        try await super.setUp()
        dataManager = DataManager.shared
        await dataManager.ensureModelContainer()
    }
    
    override func tearDown() async throws {
        // Clean up test data
        if let context = dataManager.context {
            try? context.delete(model: PersistentResource.self)
            try? context.delete(model: PersistentEvent.self)
            try? context.delete(model: PersistentUser.self)
        }
        try await super.tearDown()
    }
    
    // MARK: - Singleton Pattern Tests
    
    func testSharedInstance_ReturnsSameInstance() {
        // When
        let instance1 = DataManager.shared
        let instance2 = DataManager.shared
        
        // Then
        XCTAssertTrue(instance1 === instance2, "Shared instance should return the same instance")
    }
    
    // MARK: - Model Container Tests
    
    func testEnsureModelContainer_CreatesContainer() async {
        // Given
        let manager = DataManager.shared
        
        // When
        await manager.ensureModelContainer()
        
        // Then
        XCTAssertNotNil(manager.context, "Model context should be created")
    }
    
    func testContext_IsAvailableAfterSetup() async {
        // Given
        await dataManager.ensureModelContainer()
        
        // Then
        XCTAssertNotNil(dataManager.context, "Context should be available")
    }
    
    // MARK: - Resource Tests
    
    func testSaveResource_CreatesNewResource() async {
        // Given
        let resource = TestDataFactory.makeResource()
        
        // When
        await dataManager.saveResource(resource)
        
        // Then
        let loaded = await dataManager.loadResources()
        XCTAssertEqual(loaded.count, 1, "Should have one resource")
        XCTAssertEqual(loaded.first?.id, resource.id, "Resource ID should match")
    }
    
    func testSaveResource_UpdatesExistingResource() async {
        // Given
        var resource = TestDataFactory.makeResource()
        await dataManager.saveResource(resource)
        
        // When
        resource = Resource(
            id: resource.id,
            title: "Updated Title",
            description: resource.description,
            category: resource.category,
            url: resource.url,
            tags: resource.tags
        )
        await dataManager.saveResource(resource)
        
        // Then
        let loaded = await dataManager.loadResources()
        XCTAssertEqual(loaded.first?.title, "Updated Title", "Resource should be updated")
    }
    
    func testLoadResources_ReturnsEmptyArrayWhenNoResources() async {
        // When
        let resources = await dataManager.loadResources()
        
        // Then
        XCTAssertTrue(resources.isEmpty, "Should return empty array when no resources")
    }
    
    func testLoadResources_ReturnsResourcesInReverseDateOrder() async {
        // Given
        let resource1 = TestDataFactory.makeResource()
        let resource2 = TestDataFactory.makeResource()
        await dataManager.saveResource(resource1)
        try? await Task.sleep(nanoseconds: 100_000_000) // Small delay
        await dataManager.saveResource(resource2)
        
        // When
        let loaded = await dataManager.loadResources()
        
        // Then
        XCTAssertEqual(loaded.count, 2, "Should have two resources")
        // Most recent should be first
        XCTAssertEqual(loaded.first?.id, resource2.id, "Most recent resource should be first")
    }
    
    func testToggleFavorite_TogglesFavoriteStatus() async {
        // Given
        let resource = TestDataFactory.makeResource()
        await dataManager.saveResource(resource)
        
        // When
        await dataManager.toggleFavorite(resource.id)
        
        // Then
        let favorites = await dataManager.getFavoriteIds()
        XCTAssertTrue(favorites.contains(resource.id), "Resource should be favorited")
        
        // When - toggle again
        await dataManager.toggleFavorite(resource.id)
        
        // Then
        let favoritesAfter = await dataManager.getFavoriteIds()
        XCTAssertFalse(favoritesAfter.contains(resource.id), "Resource should not be favorited")
    }
    
    func testGetFavoriteIds_ReturnsEmptySetWhenNoFavorites() async {
        // When
        let favorites = await dataManager.getFavoriteIds()
        
        // Then
        XCTAssertTrue(favorites.isEmpty, "Should return empty set when no favorites")
    }
    
    func testGetFavoriteIds_ReturnsFavoriteIds() async {
        // Given
        let resource1 = TestDataFactory.makeResource()
        let resource2 = TestDataFactory.makeResource()
        await dataManager.saveResource(resource1)
        await dataManager.saveResource(resource2)
        await dataManager.toggleFavorite(resource1.id)
        
        // When
        let favorites = await dataManager.getFavoriteIds()
        
        // Then
        XCTAssertEqual(favorites.count, 1, "Should have one favorite")
        XCTAssertTrue(favorites.contains(resource1.id), "Should contain favorited resource")
        XCTAssertFalse(favorites.contains(resource2.id), "Should not contain non-favorited resource")
    }
    
    // MARK: - Event Tests
    
    func testSaveEvent_CreatesNewEvent() async {
        // Given
        let event = TestDataFactory.makeEvent()
        
        // When
        await dataManager.saveEvent(event)
        
        // Then
        let loaded = await dataManager.loadEvents()
        XCTAssertEqual(loaded.count, 1, "Should have one event")
        XCTAssertEqual(loaded.first?.id, event.id, "Event ID should match")
    }
    
    func testSaveEvent_UpdatesExistingEvent() async {
        // Given
        var event = TestDataFactory.makeEvent()
        await dataManager.saveEvent(event)
        
        // When
        event = Event(
            id: event.id,
            title: "Updated Event",
            description: event.description,
            date: event.date,
            location: event.location,
            isVirtual: event.isVirtual,
            registrationURL: event.registrationURL,
            eventURL: event.eventURL,
            category: event.category,
            accessibilityNotes: event.accessibilityNotes
        )
        await dataManager.saveEvent(event)
        
        // Then
        let loaded = await dataManager.loadEvents()
        XCTAssertEqual(loaded.first?.title, "Updated Event", "Event should be updated")
    }
    
    func testLoadEvents_ReturnsEmptyArrayWhenNoEvents() async {
        // When
        let events = await dataManager.loadEvents()
        
        // Then
        XCTAssertTrue(events.isEmpty, "Should return empty array when no events")
    }
    
    func testLoadEvents_ReturnsEventsInDateOrder() async {
        // Given
        let event1 = TestDataFactory.makeEvent(date: Date().addingTimeInterval(86400))
        let event2 = TestDataFactory.makeEvent(date: Date())
        await dataManager.saveEvent(event1)
        await dataManager.saveEvent(event2)
        
        // When
        let loaded = await dataManager.loadEvents()
        
        // Then
        XCTAssertEqual(loaded.count, 2, "Should have two events")
        // Earlier date should be first
        XCTAssertEqual(loaded.first?.id, event2.id, "Earlier event should be first")
    }
    
    // MARK: - User Tests
    
    func testSaveUser_CreatesNewUser() async {
        // Given
        let user = TestDataFactory.makeUser()
        
        // When
        await dataManager.saveUser(user)
        
        // Then
        let loaded = await dataManager.loadUser()
        XCTAssertNotNil(loaded, "User should be loaded")
        XCTAssertEqual(loaded?.id, user.id, "User ID should match")
    }
    
    func testSaveUser_UpdatesExistingUser() async {
        // Given
        var user = TestDataFactory.makeUser()
        await dataManager.saveUser(user)
        
        // When
        user = User(
            id: user.id,
            name: "Updated Name",
            email: user.email,
            phoneNumber: user.phoneNumber,
            bio: user.bio,
            location: user.location,
            interests: user.interests,
            accessibilityNeeds: user.accessibilityNeeds,
            notificationPreferences: user.notificationPreferences
        )
        await dataManager.saveUser(user)
        
        // Then
        let loaded = await dataManager.loadUser()
        XCTAssertEqual(loaded?.name, "Updated Name", "User should be updated")
    }
    
    func testLoadUser_ReturnsNilWhenNoUser() async {
        // When
        let user = await dataManager.loadUser()
        
        // Then
        XCTAssertNil(user, "Should return nil when no user")
    }
    
    func testDeleteUser_RemovesUser() async {
        // Given
        let user = TestDataFactory.makeUser()
        await dataManager.saveUser(user)
        
        // When
        await dataManager.deleteUser()
        
        // Then
        let loaded = await dataManager.loadUser()
        XCTAssertNil(loaded, "User should be deleted")
    }
    
    // MARK: - JSON Storage Manager Tests
    
    func testGetJSONStorageManager_ReturnsSharedInstance() {
        // When
        let manager1 = dataManager.getJSONStorageManager()
        let manager2 = dataManager.getJSONStorageManager()
        
        // Then
        XCTAssertTrue(manager1 === manager2, "Should return same JSONStorageManager instance")
    }
}
