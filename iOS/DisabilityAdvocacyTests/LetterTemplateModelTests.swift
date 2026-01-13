//
//  LetterTemplateModelTests.swift
//  DisabilityAdvocacyTests
//
//  Unit tests for LetterTemplate model
//

import XCTest
@testable import DisabilityAdvocacy

final class LetterTemplateModelTests: XCTestCase {
    
    // MARK: - Initialization Tests
    
    func testInitialization_WithAllParameters() {
        // Given
        let id = UUID()
        let title = "Test Template"
        let description = "Test Description"
        let category = LetterCategory.employer
        let templateText = "Test template text"
        let placeholders = [Placeholder(key: "key1", label: "Label 1", required: true)]
        
        // When
        let template = LetterTemplate(
            id: id,
            title: title,
            description: description,
            category: category,
            templateText: templateText,
            placeholders: placeholders
        )
        
        // Then
        XCTAssertEqual(template.id, id)
        XCTAssertEqual(template.title, title)
        XCTAssertEqual(template.description, description)
        XCTAssertEqual(template.category, category)
        XCTAssertEqual(template.templateText, templateText)
        XCTAssertEqual(template.placeholders.count, placeholders.count, "Should have same number of placeholders")
        // Compare placeholders manually since Placeholder doesn't conform to Equatable
        for (index, placeholder) in placeholders.enumerated() {
            XCTAssertEqual(template.placeholders[index].id, placeholder.id, "Placeholder \(index) should have same id")
            XCTAssertEqual(template.placeholders[index].key, placeholder.key, "Placeholder \(index) should have same key")
        }
    }
    
    func testInitialization_WithDefaultParameters() {
        // Given
        let title = "Test Template"
        let description = "Test Description"
        let category = LetterCategory.employer
        let templateText = "Test template text"
        
        // When
        let template = LetterTemplate(
            title: title,
            description: description,
            category: category,
            templateText: templateText
        )
        
        // Then
        XCTAssertNotNil(template.id, "Should generate UUID")
        XCTAssertEqual(template.title, title)
        XCTAssertEqual(template.description, description)
        XCTAssertEqual(template.category, category)
        XCTAssertEqual(template.templateText, templateText)
        XCTAssertTrue(template.placeholders.isEmpty, "Placeholders should be empty by default")
    }
    
    // MARK: - Codable Tests
    
    func testEncodingAndDecoding() throws {
        // Given
        let template = LetterTemplate(
            title: "Test Template",
            description: "Test Description",
            category: .employer,
            templateText: "Test template text",
            placeholders: [
                Placeholder(key: "key1", label: "Label 1", required: true),
                Placeholder(key: "key2", label: "Label 2", required: false)
            ]
        )
        
        // When
        let encoder = JSONEncoder()
        let data = try encoder.encode(template)
        
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(LetterTemplate.self, from: data)
        
        // Then
        XCTAssertEqual(decoded.id, template.id)
        XCTAssertEqual(decoded.title, template.title)
        XCTAssertEqual(decoded.description, template.description)
        XCTAssertEqual(decoded.category, template.category)
        XCTAssertEqual(decoded.templateText, template.templateText)
        XCTAssertEqual(decoded.placeholders.count, template.placeholders.count)
    }
    
    // MARK: - LetterCategory Tests
    
    func testLetterCategory_AllCases() {
        // Then
        let allCases = LetterCategory.allCases
        XCTAssertFalse(allCases.isEmpty, "Should have categories")
        XCTAssertTrue(allCases.contains(.legislator), "Should contain legislator category")
        XCTAssertTrue(allCases.contains(.employer), "Should contain employer category")
        XCTAssertTrue(allCases.contains(.serviceProvider), "Should contain serviceProvider category")
    }
    
    func testLetterCategory_RawValues() {
        // Then
        XCTAssertEqual(LetterCategory.legislator.rawValue, "Legislator")
        XCTAssertEqual(LetterCategory.employer.rawValue, "Employer")
        XCTAssertEqual(LetterCategory.serviceProvider.rawValue, "Service Provider")
        XCTAssertEqual(LetterCategory.school.rawValue, "School/University")
        XCTAssertEqual(LetterCategory.accommodation.rawValue, "Accommodation Request")
        XCTAssertEqual(LetterCategory.complaint.rawValue, "Complaint")
    }
    
    func testLetterCategory_Icons() {
        // Then
        XCTAssertFalse(LetterCategory.legislator.icon.isEmpty, "Should have icon")
        XCTAssertFalse(LetterCategory.employer.icon.isEmpty, "Should have icon")
        // All categories should have icons
        for category in LetterCategory.allCases {
            XCTAssertFalse(category.icon.isEmpty, "Category \(category.rawValue) should have icon")
        }
    }
    
    func testLetterCategory_Codable() throws {
        // Given
        let category = LetterCategory.employer
        
        // When
        let encoder = JSONEncoder()
        let data = try encoder.encode(category)
        
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(LetterCategory.self, from: data)
        
        // Then
        XCTAssertEqual(decoded, category)
    }
    
    // MARK: - Placeholder Tests
    
    func testPlaceholder_Initialization() {
        // Given
        let id = UUID()
        let key = "test_key"
        let label = "Test Label"
        let required = true
        let value = "Test Value"
        
        // When
        let placeholder = Placeholder(id: id, key: key, label: label, required: required, value: value)
        
        // Then
        XCTAssertEqual(placeholder.id, id)
        XCTAssertEqual(placeholder.key, key)
        XCTAssertEqual(placeholder.label, label)
        XCTAssertEqual(placeholder.required, required)
        XCTAssertEqual(placeholder.value, value)
    }
    
    func testPlaceholder_DefaultParameters() {
        // Given
        let key = "test_key"
        let label = "Test Label"
        
        // When
        let placeholder = Placeholder(key: key, label: label)
        
        // Then
        XCTAssertNotNil(placeholder.id, "Should generate UUID")
        XCTAssertEqual(placeholder.key, key)
        XCTAssertEqual(placeholder.label, label)
        XCTAssertTrue(placeholder.required, "Required should be true by default")
        XCTAssertEqual(placeholder.value, "", "Value should be empty by default")
    }
    
    func testPlaceholder_Codable() throws {
        // Given
        let placeholder = Placeholder(key: "test_key", label: "Test Label", required: true, value: "Test Value")
        
        // When
        let encoder = JSONEncoder()
        let data = try encoder.encode(placeholder)
        
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(Placeholder.self, from: data)
        
        // Then
        XCTAssertEqual(decoded.id, placeholder.id)
        XCTAssertEqual(decoded.key, placeholder.key)
        XCTAssertEqual(decoded.label, placeholder.label)
        XCTAssertEqual(decoded.required, placeholder.required)
        XCTAssertEqual(decoded.value, placeholder.value)
    }
    
    // MARK: - Sample Templates Tests
    
    func testSampleTemplates_NotEmpty() {
        // Then
        XCTAssertFalse(LetterTemplate.sampleTemplates.isEmpty, "Should have sample templates")
    }
    
    func testSampleTemplates_ValidStructure() {
        // Given
        let templates = LetterTemplate.sampleTemplates
        
        // Then
        for template in templates {
            XCTAssertFalse(template.title.isEmpty, "Template should have title")
            XCTAssertFalse(template.description.isEmpty, "Template should have description")
            XCTAssertFalse(template.templateText.isEmpty, "Template should have template text")
            // Templates should have at least some placeholders
            XCTAssertFalse(template.placeholders.isEmpty, "Template should have placeholders")
        }
    }
    
    // MARK: - Identifiable Tests
    
    func testIdentifiable_HasId() {
        // Given
        let template = LetterTemplate(title: "Test", description: "Desc", category: .employer, templateText: "Text")
        
        // Then
        XCTAssertNotNil(template.id, "Should have id for Identifiable")
    }
}

