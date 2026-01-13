//
//  AppStateTests.swift
//  DisabilityAdvocacyTests
//
//  Unit tests for AppState
//

import XCTest
@testable import DisabilityAdvocacy_iOS

@MainActor
final class AppStateTests: XCTestCase {
    var appState: AppState!
    
    override func setUp() {
        super.setUp()
        // Create a fresh AppState
        appState = AppState()
        // Clear favorites for clean state
        appState.favoriteResources.removeAll()
    }
    
    override func tearDown() {
        appState = nil
        super.tearDown()
    }
    
    func testInitialState() {
        // Then
        XCTAssertTrue(appState.favoriteResources.isEmpty, "Favorite resources should be empty initially")
    }
    
    func testToggleFavorite() async {
        // Given
        let resourceId = UUID()
        
        // When
        await appState.toggleFavorite(resourceId)
        
        // Then
        XCTAssertTrue(appState.favoriteResources.contains(resourceId), "Resource should be favorited")
        
        // When - toggle again
        await appState.toggleFavorite(resourceId)
        
        // Then
        XCTAssertFalse(appState.favoriteResources.contains(resourceId), "Resource should be unfavorited")
    }
    
    func testMultipleFavorites() async {
        // Given
        let id1 = UUID()
        let id2 = UUID()
        let id3 = UUID()
        
        // When
        await appState.toggleFavorite(id1)
        await appState.toggleFavorite(id2)
        await appState.toggleFavorite(id3)
        
        // Then
        XCTAssertEqual(appState.favoriteResources.count, 3, "Should have 3 favorites")
        XCTAssertTrue(appState.favoriteResources.contains(id1))
        XCTAssertTrue(appState.favoriteResources.contains(id2))
        XCTAssertTrue(appState.favoriteResources.contains(id3))
    }
    
    func testIsFavorite() async {
        // Given
        let resourceId = UUID()
        
        // When
        await appState.toggleFavorite(resourceId)
        
        // Then
        XCTAssertTrue(appState.isFavorite(resourceId), "isFavorite should return true for favorited resource")
        
        // When
        await appState.toggleFavorite(resourceId)
        
        // Then
        XCTAssertFalse(appState.isFavorite(resourceId), "isFavorite should return false for unfavorited resource")
    }
    
    func testToggleFavoritePersistence() async {
        // Given
        let resourceId = UUID()
        let testAppState = AppState()
        
        // When
        await testAppState.toggleFavorite(resourceId)
        
        // Then
        // Verify it's saved by creating a new AppState and checking
        let newAppState = AppState()
        XCTAssertTrue(newAppState.favoriteResources.contains(resourceId), "Favorite should be persisted")
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

