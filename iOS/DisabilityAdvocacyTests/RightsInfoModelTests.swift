//
//  RightsInfoModelTests.swift
//  DisabilityAdvocacyTests
//
//  Unit tests for RightsInfo model
//

import XCTest
@testable import DisabilityAdvocacy

final class RightsInfoModelTests: XCTestCase {
    
    // MARK: - Initialization Tests
    
    func testInitialization_WithAllParameters() {
        // Given
        let id = UUID()
        let title = "Test Title"
        let category = RightsCategory.employment
        let law = "Test Law"
        let summary = "Test Summary"
        let keyPoints = ["Point 1", "Point 2"]
        let detailedDescription = "Test Description"
        let relatedResources = ["Resource 1", "Resource 2"]
        
        // When
        let rightsInfo = RightsInfo(
            id: id,
            title: title,
            category: category,
            law: law,
            summary: summary,
            keyPoints: keyPoints,
            detailedDescription: detailedDescription,
            relatedResources: relatedResources
        )
        
        // Then
        XCTAssertEqual(rightsInfo.id, id)
        XCTAssertEqual(rightsInfo.title, title)
        XCTAssertEqual(rightsInfo.category, category)
        XCTAssertEqual(rightsInfo.law, law)
        XCTAssertEqual(rightsInfo.summary, summary)
        XCTAssertEqual(rightsInfo.keyPoints, keyPoints)
        XCTAssertEqual(rightsInfo.detailedDescription, detailedDescription)
        XCTAssertEqual(rightsInfo.relatedResources, relatedResources)
    }
    
    func testInitialization_WithDefaultParameters() {
        // Given
        let title = "Test Title"
        let category = RightsCategory.employment
        let law = "Test Law"
        let summary = "Test Summary"
        let keyPoints = ["Point 1", "Point 2"]
        let detailedDescription = "Test Description"
        
        // When
        let rightsInfo = RightsInfo(
            title: title,
            category: category,
            law: law,
            summary: summary,
            keyPoints: keyPoints,
            detailedDescription: detailedDescription
        )
        
        // Then
        XCTAssertNotNil(rightsInfo.id, "Should generate UUID")
        XCTAssertEqual(rightsInfo.title, title)
        XCTAssertEqual(rightsInfo.category, category)
        XCTAssertEqual(rightsInfo.law, law)
        XCTAssertEqual(rightsInfo.summary, summary)
        XCTAssertEqual(rightsInfo.keyPoints, keyPoints)
        XCTAssertEqual(rightsInfo.detailedDescription, detailedDescription)
        XCTAssertTrue(rightsInfo.relatedResources.isEmpty, "Related resources should be empty by default")
    }
    
    // MARK: - Codable Tests
    
    func testEncodingAndDecoding() throws {
        // Given
        let rightsInfo = RightsInfo(
            title: "Test Title",
            category: .employment,
            law: "Test Law",
            summary: "Test Summary",
            keyPoints: ["Point 1", "Point 2"],
            detailedDescription: "Test Description",
            relatedResources: ["Resource 1"]
        )
        
        // When
        let encoder = JSONEncoder()
        let data = try encoder.encode(rightsInfo)
        
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(RightsInfo.self, from: data)
        
        // Then
        XCTAssertEqual(decoded.id, rightsInfo.id)
        XCTAssertEqual(decoded.title, rightsInfo.title)
        XCTAssertEqual(decoded.category, rightsInfo.category)
        XCTAssertEqual(decoded.law, rightsInfo.law)
        XCTAssertEqual(decoded.summary, rightsInfo.summary)
        XCTAssertEqual(decoded.keyPoints, rightsInfo.keyPoints)
        XCTAssertEqual(decoded.detailedDescription, rightsInfo.detailedDescription)
        XCTAssertEqual(decoded.relatedResources, rightsInfo.relatedResources)
    }
    
    // MARK: - RightsCategory Tests
    
    func testRightsCategory_AllCases() {
        // Then
        let allCases = RightsCategory.allCases
        XCTAssertFalse(allCases.isEmpty, "Should have categories")
        XCTAssertTrue(allCases.contains(.employment), "Should contain employment category")
        XCTAssertTrue(allCases.contains(.education), "Should contain education category")
        XCTAssertTrue(allCases.contains(.housing), "Should contain housing category")
    }
    
    func testRightsCategory_RawValues() {
        // Then
        XCTAssertEqual(RightsCategory.employment.rawValue, "Employment")
        XCTAssertEqual(RightsCategory.education.rawValue, "Education")
        XCTAssertEqual(RightsCategory.housing.rawValue, "Housing")
        XCTAssertEqual(RightsCategory.transportation.rawValue, "Transportation")
        XCTAssertEqual(RightsCategory.healthcare.rawValue, "Healthcare")
        XCTAssertEqual(RightsCategory.publicAccommodations.rawValue, "Public Accommodations")
        XCTAssertEqual(RightsCategory.voting.rawValue, "Voting")
        XCTAssertEqual(RightsCategory.technology.rawValue, "Technology & Digital")
    }
    
    func testRightsCategory_Icons() {
        // Then
        XCTAssertFalse(RightsCategory.employment.icon.isEmpty, "Should have icon")
        XCTAssertFalse(RightsCategory.education.icon.isEmpty, "Should have icon")
        // All categories should have icons
        for category in RightsCategory.allCases {
            XCTAssertFalse(category.icon.isEmpty, "Category \(category.rawValue) should have icon")
        }
    }
    
    func testRightsCategory_Codable() throws {
        // Given
        let category = RightsCategory.employment
        
        // When
        let encoder = JSONEncoder()
        let data = try encoder.encode(category)
        
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(RightsCategory.self, from: data)
        
        // Then
        XCTAssertEqual(decoded, category)
    }
    
    // MARK: - Sample Rights Tests
    
    func testSampleRights_NotEmpty() {
        // Then
        XCTAssertFalse(RightsInfo.sampleRights.isEmpty, "Should have sample rights")
    }
    
    func testSampleRights_ValidStructure() {
        // Given
        let sampleRights = RightsInfo.sampleRights
        
        // Then
        for rightsInfo in sampleRights {
            XCTAssertFalse(rightsInfo.title.isEmpty, "Should have title")
            XCTAssertFalse(rightsInfo.law.isEmpty, "Should have law")
            XCTAssertFalse(rightsInfo.summary.isEmpty, "Should have summary")
            XCTAssertFalse(rightsInfo.keyPoints.isEmpty, "Should have key points")
            XCTAssertFalse(rightsInfo.detailedDescription.isEmpty, "Should have detailed description")
        }
    }
    
    // MARK: - Identifiable Tests
    
    func testIdentifiable_HasId() {
        // Given
        let rightsInfo = RightsInfo(
            title: "Test",
            category: .employment,
            law: "Law",
            summary: "Summary",
            keyPoints: [],
            detailedDescription: "Description"
        )
        
        // Then
        XCTAssertNotNil(rightsInfo.id, "Should have id for Identifiable")
    }
}

