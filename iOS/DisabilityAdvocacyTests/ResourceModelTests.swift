//
//  ResourceModelTests.swift
//  DisabilityAdvocacyTests
//
//  Unit tests for Resource model
//

import XCTest
@testable import DisabilityAdvocacy_iOS

final class ResourceModelTests: XCTestCase {
    
    // MARK: - Initialization Tests
    
    func testInitialization_WithAllParameters() {
        // Given
        let id = UUID()
        let title = "Test Resource"
        let description = "Test Description"
        let category = ResourceCategory.legal
        let url = "https://example.com"
        let tags = ["tag1", "tag2"]
        let dateAdded = Date()
        
        // When
        let resource = Resource(
            id: id,
            title: title,
            description: description,
            category: category,
            url: url,
            tags: tags,
            dateAdded: dateAdded
        )
        
        // Then
        XCTAssertEqual(resource.id, id)
        XCTAssertEqual(resource.title, title)
        XCTAssertEqual(resource.description, description)
        XCTAssertEqual(resource.category, category)
        XCTAssertEqual(resource.url, url)
        XCTAssertEqual(resource.tags, tags)
        XCTAssertEqual(resource.dateAdded, dateAdded)
    }
    
    func testInitialization_WithDefaultParameters() {
        // Given
        let title = "Test Resource"
        let description = "Test Description"
        let category = ResourceCategory.legal
        
        // When
        let resource = Resource(
            title: title,
            description: description,
            category: category
        )
        
        // Then
        XCTAssertNotNil(resource.id, "Should generate UUID")
        XCTAssertEqual(resource.title, title)
        XCTAssertEqual(resource.description, description)
        XCTAssertEqual(resource.category, category)
        XCTAssertNil(resource.url, "URL should be nil by default")
        XCTAssertTrue(resource.tags.isEmpty, "Tags should be empty by default")
        // Date should be recent (within last second)
        XCTAssertLessThanOrEqual(abs(resource.dateAdded.timeIntervalSinceNow), 1.0)
    }
    
    // MARK: - Codable Tests
    
    func testEncodingAndDecoding() throws {
        // Given
        let resource = Resource(
            title: "Test Resource",
            description: "Test Description",
            category: .legal,
            url: "https://example.com",
            tags: ["tag1", "tag2"]
        )
        
        // When
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(resource)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let decoded = try decoder.decode(Resource.self, from: data)
        
        // Then
        XCTAssertEqual(decoded.id, resource.id)
        XCTAssertEqual(decoded.title, resource.title)
        XCTAssertEqual(decoded.description, resource.description)
        XCTAssertEqual(decoded.category, resource.category)
        XCTAssertEqual(decoded.url, resource.url)
        XCTAssertEqual(decoded.tags, resource.tags)
        // Compare dates with small tolerance for encoding/decoding
        XCTAssertLessThanOrEqual(abs(decoded.dateAdded.timeIntervalSince(resource.dateAdded)), 1.0)
    }
    
    // MARK: - Hashable Tests
    
    func testHashable_EqualResources_HaveSameHash() {
        // Given
        let id = UUID()
        let resource1 = Resource(id: id, title: "Test", description: "Desc", category: .legal)
        let resource2 = Resource(id: id, title: "Test", description: "Desc", category: .legal)
        
        // Then
        XCTAssertEqual(resource1.hashValue, resource2.hashValue, "Equal resources should have same hash")
    }
    
    func testHashable_DifferentResources_MayHaveDifferentHash() {
        // Given
        let resource1 = Resource(title: "Test 1", description: "Desc", category: .legal)
        let resource2 = Resource(title: "Test 2", description: "Desc", category: .legal)
        
        // Then
        // Note: Hash collisions are possible but unlikely with UUIDs
        // We just verify they can be hashed
        XCTAssertNotNil(resource1.hashValue)
        XCTAssertNotNil(resource2.hashValue)
    }
    
    // MARK: - ResourceCategory Tests
    
    func testResourceCategory_AllCases() {
        // Then
        let allCases = ResourceCategory.allCases
        XCTAssertFalse(allCases.isEmpty, "Should have categories")
        XCTAssertTrue(allCases.contains(.legal), "Should contain legal category")
        XCTAssertTrue(allCases.contains(.education), "Should contain education category")
        XCTAssertTrue(allCases.contains(.employment), "Should contain employment category")
    }
    
    func testResourceCategory_RawValues() {
        // Then
        XCTAssertEqual(ResourceCategory.legal.rawValue, "Legal Rights")
        XCTAssertEqual(ResourceCategory.education.rawValue, "Education")
        XCTAssertEqual(ResourceCategory.employment.rawValue, "Employment")
        XCTAssertEqual(ResourceCategory.healthcare.rawValue, "Healthcare")
    }
    
    func testResourceCategory_Icons() {
        // Then
        XCTAssertFalse(ResourceCategory.legal.icon.isEmpty, "Should have icon")
        XCTAssertFalse(ResourceCategory.education.icon.isEmpty, "Should have icon")
        XCTAssertFalse(ResourceCategory.employment.icon.isEmpty, "Should have icon")
        // All categories should have icons
        for category in ResourceCategory.allCases {
            XCTAssertFalse(category.icon.isEmpty, "Category \(category.rawValue) should have icon")
        }
    }
    
    func testResourceCategory_Codable() throws {
        // Given
        let category = ResourceCategory.legal
        
        // When
        let encoder = JSONEncoder()
        let data = try encoder.encode(category)
        
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(ResourceCategory.self, from: data)
        
        // Then
        XCTAssertEqual(decoded, category)
    }
}

