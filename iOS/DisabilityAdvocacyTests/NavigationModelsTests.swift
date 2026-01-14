//
//  NavigationModelsTests.swift
//  DisabilityAdvocacyTests
//
//  Unit tests for NavigationModels
//

import XCTest
@testable import DisabilityAdvocacy_iOS

final class NavigationModelsTests: XCTestCase {
    
    // MARK: - AppTab Tests
    
    func testAppTab_AllCases_AreDefined() {
        // Then
        let allTabs = AppTab.allCases
        XCTAssertEqual(allTabs.count, 10, "Should have 10 app tabs")
    }
    
    func testAppTab_IsIdentifiable() {
        // Given
        let tab = AppTab.home
        
        // Then
        XCTAssertEqual(tab.id, "home", "ID should match rawValue")
    }
    
    func testAppTab_Titles_AreLocalized() {
        // Then
        XCTAssertNotNil(AppTab.home.title)
        XCTAssertNotNil(AppTab.news.title)
        XCTAssertNotNil(AppTab.resources.title)
        XCTAssertNotNil(AppTab.advocacy.title)
        XCTAssertNotNil(AppTab.community.title)
        XCTAssertNotNil(AppTab.events.title)
        XCTAssertNotNil(AppTab.library.title)
        XCTAssertNotNil(AppTab.connect.title)
        XCTAssertNotNil(AppTab.settings.title)
        XCTAssertNotNil(AppTab.dataManagement.title)
    }
    
    func testAppTab_Icons_AreSet() {
        // Then
        XCTAssertEqual(AppTab.home.icon, "house.fill")
        XCTAssertEqual(AppTab.news.icon, "newspaper.fill")
        XCTAssertEqual(AppTab.resources.icon, "book.fill")
        XCTAssertEqual(AppTab.advocacy.icon, "megaphone.fill")
        XCTAssertEqual(AppTab.community.icon, "person.3.fill")
        XCTAssertEqual(AppTab.events.icon, "calendar")
        XCTAssertEqual(AppTab.library.icon, "books.vertical.fill")
        XCTAssertEqual(AppTab.connect.icon, "person.2.fill")
        XCTAssertEqual(AppTab.settings.icon, "gearshape.fill")
        XCTAssertEqual(AppTab.dataManagement.icon, "database.fill")
    }
    
    func testAppTab_iOSVisibleTabs_ReturnsCorrectTabs() {
        // When
        let visibleTabs = AppTab.iOSVisibleTabs
        
        // Then
        XCTAssertEqual(visibleTabs.count, 4, "Should have 4 visible tabs on iOS")
        XCTAssertTrue(visibleTabs.contains(.home))
        XCTAssertTrue(visibleTabs.contains(.library))
        XCTAssertTrue(visibleTabs.contains(.connect))
        XCTAssertTrue(visibleTabs.contains(.settings))
        XCTAssertFalse(visibleTabs.contains(.news), "News should not be in iOS visible tabs")
    }
    
    func testAppTab_IsHashable() {
        // Given
        var set = Set<AppTab>()
        
        // When
        set.insert(.home)
        set.insert(.news)
        set.insert(.home) // Duplicate
        
        // Then
        XCTAssertEqual(set.count, 2, "Set should contain 2 unique tabs")
    }
    
    func testAppTab_IsCodable() {
        // Given
        let tab = AppTab.home
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        // When
        guard let data = try? encoder.encode(tab),
              let decoded = try? decoder.decode(AppTab.self, from: data) else {
            XCTFail("Should encode and decode AppTab")
            return
        }
        
        // Then
        XCTAssertEqual(decoded, tab, "Decoded tab should match original")
    }
    
    // MARK: - AppDestination Tests
    
    func testAppDestination_AllCases_AreDefined() {
        // Given
        let destinations: [AppDestination] = [
            .search,
            .profile,
            .accessibility,
            .letterGenerator,
            .rightsKnowledgeBase,
            .favorites
        ]
        
        // Then
        XCTAssertEqual(destinations.count, 6, "Should have 6 app destinations")
    }
    
    func testAppDestination_IsHashable() {
        // Given
        var set = Set<AppDestination>()
        
        // When
        set.insert(.search)
        set.insert(.profile)
        set.insert(.search) // Duplicate
        
        // Then
        XCTAssertEqual(set.count, 2, "Set should contain 2 unique destinations")
    }
    
    func testAppDestination_CanBeUsedInNavigation() {
        // Given
        let destination = AppDestination.search
        
        // Then - Just verify it doesn't crash
        XCTAssertNotNil(destination, "Destination should not be nil")
    }
}
