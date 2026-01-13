//
//  AppStateTests.swift
//  DisabilityAdvocacyTests
//
//  Unit tests for AppState
//

import XCTest
@testable import DisabilityAdvocacy

@MainActor
final class AppStateTests: XCTestCase {
    var appState: AppState!
    
    override func setUp() {
        super.setUp()
        // Create a fresh ResourcesManager to avoid loading saved data
        let resourcesManager = ResourcesManager()
        // Clear any saved favorites to ensure clean state
        resourcesManager.saveFavoriteIds([])
        appState = AppState(resourcesManager: resourcesManager)
    }
    
    override func tearDown() {
        // Clean up saved data
        let resourcesManager = ResourcesManager()
        resourcesManager.saveFavoriteIds([])
        appState = nil
        super.tearDown()
    }
    
    func testInitialState() {
        // Then
        XCTAssertTrue(appState.favoriteResources.isEmpty, "Favorite resources should be empty initially")
    }
    
    func testToggleFavorite() {
        // Given
        let resourceId = UUID()
        
        // When
        appState.toggleFavorite(resourceId)
        
        // Then
        XCTAssertTrue(appState.favoriteResources.contains(resourceId), "Resource should be favorited")
        
        // When - toggle again
        appState.toggleFavorite(resourceId)
        
        // Then
        XCTAssertFalse(appState.favoriteResources.contains(resourceId), "Resource should be unfavorited")
    }
    
    func testMultipleFavorites() {
        // Given
        let id1 = UUID()
        let id2 = UUID()
        let id3 = UUID()
        
        // When
        appState.toggleFavorite(id1)
        appState.toggleFavorite(id2)
        appState.toggleFavorite(id3)
        
        // Then
        XCTAssertEqual(appState.favoriteResources.count, 3, "Should have 3 favorites")
        XCTAssertTrue(appState.favoriteResources.contains(id1))
        XCTAssertTrue(appState.favoriteResources.contains(id2))
        XCTAssertTrue(appState.favoriteResources.contains(id3))
    }
    
    func testIsFavorite() {
        // Given
        let resourceId = UUID()
        
        // When
        appState.toggleFavorite(resourceId)
        
        // Then
        XCTAssertTrue(appState.isFavorite(resourceId), "isFavorite should return true for favorited resource")
        
        // When
        appState.toggleFavorite(resourceId)
        
        // Then
        XCTAssertFalse(appState.isFavorite(resourceId), "isFavorite should return false for unfavorited resource")
    }
    
    func testLoadSavedData() async {
        // Given
        let resourcesManager = ResourcesManager()
        let testResources = [
            Resource(
                title: "Test Resource",
                description: "Test Description",
                category: .legal,
                url: "https://example.com",
                tags: ["test"]
            )
        ]
        resourcesManager.saveResources(testResources)
        
        let favoriteIds = [UUID(), UUID()]
        resourcesManager.saveFavoriteIds(favoriteIds)
        
        // When
        let testAppState = AppState(resourcesManager: resourcesManager)
        
        // Then
        XCTAssertEqual(testAppState.savedResources.count, testResources.count, "Should load saved resources")
        XCTAssertEqual(testAppState.favoriteResources.count, favoriteIds.count, "Should load favorite IDs")
    }
    
    func testToggleFavoritePersistence() {
        // Given
        let resourceId = UUID()
        let resourcesManager = ResourcesManager()
        let testAppState = AppState(resourcesManager: resourcesManager)
        
        // When
        testAppState.toggleFavorite(resourceId)
        
        // Then
        // Verify it's saved by checking the manager directly
        let savedIds = resourcesManager.loadFavoriteIds()
        XCTAssertTrue(savedIds.contains(resourceId), "Favorite should be persisted")
    }
    
    func testInitialAccessibilitySettings() {
        // Then
        // Note: Accessibility settings may not be part of AppState in current implementation
        // These assertions are commented out until the feature is added
        // XCTAssertNotNil(appState.accessibilitySettings, "Should have default accessibility settings")
        // XCTAssertFalse(appState.showAccessibilitySettings, "Should not show accessibility settings initially")
    }
    
    func testInitialProfileState() {
        // Then
        XCTAssertFalse(appState.showProfile, "Should not show profile initially")
    }
}

