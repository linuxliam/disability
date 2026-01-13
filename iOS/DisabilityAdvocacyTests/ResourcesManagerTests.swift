//
//  ResourcesManagerTests.swift
//  DisabilityAdvocacyTests
//
//  Unit tests for ResourcesManager
//

import XCTest
@testable import DisabilityAdvocacy

@MainActor
final class ResourcesManagerTests: XCTestCase {
    var manager: ResourcesManager!
    
    override func setUp() {
        super.setUp()
        manager = ResourcesManager()
    }
    
    override func tearDown() {
        manager = nil
        super.tearDown()
    }
    
    func testGetSampleResources() async {
        // Given
        let resources = manager.getAllResources()
        
        // Then
        XCTAssertFalse(resources.isEmpty, "Resources should not be empty")
        XCTAssertGreaterThan(resources.count, 0, "Should have at least one resource")
    }
    
    func testLoadSavedResources() {
        // Given
        let testResources = [
            Resource(
                title: "Test Resource",
                description: "Test Description",
                category: .legal,
                url: "https://example.com",
                tags: ["test"]
            )
        ]
        
        // When
        manager.saveResources(testResources)
        let loadedResources = manager.loadSavedResources()
        
        // Then
        XCTAssertEqual(loadedResources.count, testResources.count, "Loaded resources should match saved resources")
        XCTAssertEqual(loadedResources.first?.title, testResources.first?.title, "Resource title should match")
    }
    
    func testFavoriteIdsPersistence() {
        // Given
        let favoriteIds = [UUID(), UUID(), UUID()]
        
        // When
        manager.saveFavoriteIds(favoriteIds)
        let loadedIds = manager.loadFavoriteIds()
        
        // Then
        XCTAssertEqual(loadedIds.count, favoriteIds.count, "Loaded favorite IDs should match saved IDs")
        XCTAssertEqual(Set(loadedIds), Set(favoriteIds), "Favorite IDs should match exactly")
    }
    
    func testLoadFavoriteIdsEmpty() {
        // When
        let ids = manager.loadFavoriteIds()
        
        // Then
        XCTAssertTrue(ids.isEmpty, "Initially, favorite IDs should be empty")
    }
    
    func testValidateResourcesJSON() {
        // When
        let isValid = ResourcesManager.validateResourcesJSON()
        
        // Then
        XCTAssertTrue(isValid, "Resources JSON validation should pass")
    }
    
    func testSaveAndLoadResources() {
        // Given
        let testResources = [
            Resource(
                title: "Test Resource 1",
                description: "Test Description 1",
                category: .legal,
                url: "https://example.com/1",
                tags: ["test", "legal"]
            ),
            Resource(
                title: "Test Resource 2",
                description: "Test Description 2",
                category: .employment,
                url: "https://example.com/2",
                tags: ["test", "employment"]
            )
        ]
        
        // When
        manager.saveResources(testResources)
        let loadedResources = manager.loadSavedResources()
        
        // Then
        XCTAssertEqual(loadedResources.count, testResources.count, "Loaded resources count should match")
        XCTAssertEqual(loadedResources.first?.title, testResources.first?.title, "First resource title should match")
        XCTAssertEqual(loadedResources.last?.title, testResources.last?.title, "Last resource title should match")
    }
    
    func testLoadSavedResourcesWhenEmpty() {
        // Given - clear saved resources
        UserDefaults.standard.removeObject(forKey: "savedResources")
        
        // When
        let resources = manager.loadSavedResources()
        
        // Then
        XCTAssertTrue(resources.isEmpty, "Should return empty array when no saved resources")
    }
    
    func testSaveFavoriteIdsWithEmptyArray() {
        // Given
        let emptyIds: [UUID] = []
        
        // When
        manager.saveFavoriteIds(emptyIds)
        let loadedIds = manager.loadFavoriteIds()
        
        // Then
        XCTAssertTrue(loadedIds.isEmpty, "Should save and load empty array")
    }
    
    func testSaveFavoriteIdsWithSingleId() {
        // Given
        let id = UUID()
        
        // When
        manager.saveFavoriteIds([id])
        let loadedIds = manager.loadFavoriteIds()
        
        // Then
        XCTAssertEqual(loadedIds.count, 1, "Should have one favorite ID")
        XCTAssertEqual(loadedIds.first, id, "Favorite ID should match")
    }
    
    func testSaveFavoriteIdsWithMultipleIds() {
        // Given
        let ids = [UUID(), UUID(), UUID(), UUID(), UUID()]
        
        // When
        manager.saveFavoriteIds(ids)
        let loadedIds = manager.loadFavoriteIds()
        
        // Then
        XCTAssertEqual(loadedIds.count, ids.count, "Should save and load all IDs")
        XCTAssertEqual(Set(loadedIds), Set(ids), "IDs should match exactly")
    }
    
    func testGetSampleResourcesReturnsNonEmpty() {
        // When
        let resources = manager.getAllResources()
        
        // Then
        XCTAssertFalse(resources.isEmpty, "Should return non-empty resources")
        XCTAssertGreaterThan(resources.count, 0, "Should have at least one resource")
    }
    
    func testGetSampleResourcesHasValidProperties() {
        // When
        let resources = manager.getAllResources()
        
        // Then
        for resource in resources {
            XCTAssertFalse(resource.title.isEmpty, "Resource should have a title")
            XCTAssertFalse(resource.description.isEmpty, "Resource should have a description")
            XCTAssertFalse(resource.tags.isEmpty, "Resource should have tags")
        }
    }
    
    func testGetSampleResourcesHasValidCategories() {
        // When
        let resources = manager.getAllResources()
        
        // Then
        let categories = Set(resources.map { $0.category })
        XCTAssertGreaterThan(categories.count, 0, "Should have multiple resource categories")
    }
}

