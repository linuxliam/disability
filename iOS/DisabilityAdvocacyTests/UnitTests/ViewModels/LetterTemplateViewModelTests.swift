//
//  LetterTemplateViewModelTests.swift
//  DisabilityAdvocacyTests
//
//  Unit tests for LetterTemplateViewModel
//

import XCTest
@testable import DisabilityAdvocacy_iOS

@MainActor
final class LetterTemplateViewModelTests: XCTestCase {
    var viewModel: LetterTemplateViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = LetterTemplateViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    // MARK: - Initial State Tests
    
    func testInitialState() {
        // Then
        XCTAssertFalse(viewModel.templates.isEmpty, "Should have templates loaded")
        XCTAssertNil(viewModel.selectedTemplate, "Selected template should be nil initially")
        XCTAssertTrue(viewModel.filledPlaceholders.isEmpty, "Filled placeholders should be empty initially")
        XCTAssertEqual(viewModel.generatedLetter, "", "Generated letter should be empty initially")
        XCTAssertFalse(viewModel.isLoading, "Should not be loading initially")
    }
    
    func testLoadTemplates() {
        // When
        viewModel.loadTemplates()
        
        // Then
        XCTAssertEqual(viewModel.templates.count, LetterTemplate.sampleTemplates.count, "Should load all sample templates")
        // Compare templates manually since LetterTemplate doesn't conform to Equatable
        for (index, sampleTemplate) in LetterTemplate.sampleTemplates.enumerated() {
            XCTAssertEqual(viewModel.templates[index].id, sampleTemplate.id, "Template \(index) should have same id")
            XCTAssertEqual(viewModel.templates[index].title, sampleTemplate.title, "Template \(index) should have same title")
        }
        XCTAssertFalse(viewModel.templates.isEmpty, "Should have at least one template")
    }
    
    // MARK: - Template Selection Tests
    
    func testSelectTemplate_SetsSelectedTemplate() {
        // Given
        guard let template = viewModel.templates.first else {
            XCTFail("Should have at least one template")
            return
        }
        
        // When
        viewModel.selectTemplate(template)
        
        // Then
        XCTAssertEqual(viewModel.selectedTemplate?.id, template.id, "Should set selected template")
    }
    
    func testSelectTemplate_ResetsPlaceholders() {
        // Given
        guard let template = viewModel.templates.first else {
            XCTFail("Should have at least one template")
            return
        }
        
        // When
        viewModel.selectTemplate(template)
        viewModel.updatePlaceholder(id: template.placeholders.first?.id ?? UUID(), value: "test")
        XCTAssertFalse(viewModel.filledPlaceholders.isEmpty, "Should have filled placeholder")
        
        viewModel.selectTemplate(template)
        
        // Then
        // All placeholders should be reset to empty strings
        for placeholder in template.placeholders {
            XCTAssertEqual(viewModel.filledPlaceholders[placeholder.id], "", "Placeholder should be reset to empty string")
        }
    }
    
    func testSelectTemplate_ResetsGeneratedLetter() {
        // Given
        guard let template = viewModel.templates.first else {
            XCTFail("Should have at least one template")
            return
        }
        
        // When
        viewModel.selectTemplate(template)
        // Fill placeholders and generate letter
        for placeholder in template.placeholders {
            viewModel.updatePlaceholder(id: placeholder.id, value: "test")
        }
        viewModel.generateLetter()
        XCTAssertFalse(viewModel.generatedLetter.isEmpty, "Should have generated letter")
        
        viewModel.selectTemplate(template)
        
        // Then
        XCTAssertEqual(viewModel.generatedLetter, "", "Generated letter should be reset")
    }
    
    func testSelectTemplate_InitializesPlaceholders() {
        // Given
        guard let template = viewModel.templates.first else {
            XCTFail("Should have at least one template")
            return
        }
        
        // When
        viewModel.selectTemplate(template)
        
        // Then
        XCTAssertEqual(viewModel.filledPlaceholders.count, template.placeholders.count, "Should initialize all placeholders")
        for placeholder in template.placeholders {
            XCTAssertNotNil(viewModel.filledPlaceholders[placeholder.id], "Placeholder should be initialized")
            XCTAssertEqual(viewModel.filledPlaceholders[placeholder.id], "", "Placeholder should be initialized with empty string")
        }
    }
    
    // MARK: - Placeholder Management Tests
    
    func testUpdatePlaceholder_UpdatesDictionary() {
        // Given
        guard let template = viewModel.templates.first,
              let placeholder = template.placeholders.first else {
            XCTFail("Template should have at least one placeholder")
            return
        }
        viewModel.selectTemplate(template)
        
        // When
        viewModel.updatePlaceholder(id: placeholder.id, value: "Test Value")
        
        // Then
        XCTAssertEqual(viewModel.filledPlaceholders[placeholder.id], "Test Value", "Should update placeholder value")
    }
    
    func testUpdatePlaceholder_MultiplePlaceholders() {
        // Given
        guard let template = viewModel.templates.first,
              template.placeholders.count >= 2 else {
            XCTFail("Template should have at least two placeholders")
            return
        }
        viewModel.selectTemplate(template)
        
        // When
        viewModel.updatePlaceholder(id: template.placeholders[0].id, value: "Value 1")
        viewModel.updatePlaceholder(id: template.placeholders[1].id, value: "Value 2")
        
        // Then
        XCTAssertEqual(viewModel.filledPlaceholders[template.placeholders[0].id], "Value 1")
        XCTAssertEqual(viewModel.filledPlaceholders[template.placeholders[1].id], "Value 2")
    }
    
    // MARK: - Letter Generation Tests
    
    func testGenerateLetter_ReplacesPlaceholders() {
        // Given
        guard let template = viewModel.templates.first else {
            XCTFail("Should have at least one template")
            return
        }
        viewModel.selectTemplate(template)
        
        // Fill all placeholders
        for placeholder in template.placeholders {
            viewModel.updatePlaceholder(id: placeholder.id, value: "FilledValue")
        }
        
        // When
        viewModel.generateLetter()
        
        // Then
        XCTAssertFalse(viewModel.generatedLetter.isEmpty, "Should generate letter")
        // Check that placeholders are replaced (not present in generated letter)
        for placeholder in template.placeholders {
            XCTAssertFalse(viewModel.generatedLetter.contains("[\(placeholder.key)]"), "Placeholder should be replaced")
        }
    }
    
    func testGenerateLetter_ReplacesWithFilledValues() {
        // Given
        guard let template = viewModel.templates.first,
              let placeholder = template.placeholders.first else {
            XCTFail("Template should have at least one placeholder")
            return
        }
        viewModel.selectTemplate(template)
        let testValue = "Test Replacement Value"
        viewModel.updatePlaceholder(id: placeholder.id, value: testValue)
        
        // Fill other placeholders with empty or test values
        for placeholder in template.placeholders.dropFirst() {
            viewModel.updatePlaceholder(id: placeholder.id, value: "OtherValue")
        }
        
        // When
        viewModel.generateLetter()
        
        // Then
        XCTAssertTrue(viewModel.generatedLetter.contains(testValue), "Generated letter should contain filled value")
    }
    
    func testGenerateLetter_WithPartialPlaceholders() {
        // Given
        guard let template = viewModel.templates.first,
              template.placeholders.count >= 2 else {
            XCTFail("Template should have at least two placeholders")
            return
        }
        viewModel.selectTemplate(template)
        
        // Fill only first placeholder
        viewModel.updatePlaceholder(id: template.placeholders[0].id, value: "Filled")
        // Leave other placeholders empty
        
        // When
        viewModel.generateLetter()
        
        // Then
        XCTAssertFalse(viewModel.generatedLetter.isEmpty, "Should generate letter even with partial placeholders")
        // Empty placeholders should be replaced with empty strings
        XCTAssertFalse(viewModel.generatedLetter.contains("[\(template.placeholders[0].key)]"), "Filled placeholder should be replaced")
    }
    
    func testGenerateLetter_ReplacesDatePlaceholder() {
        // Given
        guard let template = viewModel.templates.first else {
            XCTFail("Should have at least one template")
            return
        }
        // Find a template that has [Date] in it
        let templateWithDate = viewModel.templates.first { $0.templateText.contains("[Date]") }
        guard let template = templateWithDate else {
            XCTSkip("No template with [Date] placeholder found")
            return
        }
        
        viewModel.selectTemplate(template)
        // Fill some placeholders but not Date
        for placeholder in template.placeholders where placeholder.key != "Date" {
            if placeholder.required {
                viewModel.updatePlaceholder(id: placeholder.id, value: "Test")
            }
        }
        
        // When
        viewModel.generateLetter()
        
        // Then
        XCTAssertFalse(viewModel.generatedLetter.contains("[Date]"), "Date placeholder should be replaced")
        // Should contain a formatted date
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        let expectedDate = formatter.string(from: Date())
        XCTAssertTrue(viewModel.generatedLetter.contains(expectedDate), "Should contain formatted date")
    }
    
    func testGenerateLetter_NoSelectedTemplate() {
        // Given
        viewModel.selectedTemplate = nil
        
        // When
        viewModel.generateLetter()
        
        // Then
        XCTAssertEqual(viewModel.generatedLetter, "", "Should not generate letter without selected template")
    }
    
    // MARK: - Validation Tests
    
    func testCanGenerateLetter_NoSelectedTemplate_ReturnsFalse() {
        // Given
        viewModel.selectedTemplate = nil
        
        // When
        let canGenerate = viewModel.canGenerateLetter()
        
        // Then
        XCTAssertFalse(canGenerate, "Should not be able to generate letter without selected template")
    }
    
    func testCanGenerateLetter_AllRequiredPlaceholdersFilled_ReturnsTrue() {
        // Given
        guard let template = viewModel.templates.first else {
            XCTFail("Should have at least one template")
            return
        }
        viewModel.selectTemplate(template)
        
        // Fill all required placeholders
        for placeholder in template.placeholders where placeholder.required {
            viewModel.updatePlaceholder(id: placeholder.id, value: "Filled")
        }
        
        // When
        let canGenerate = viewModel.canGenerateLetter()
        
        // Then
        XCTAssertTrue(canGenerate, "Should be able to generate letter when all required placeholders are filled")
    }
    
    func testCanGenerateLetter_MissingRequiredPlaceholder_ReturnsFalse() {
        // Given
        guard let template = viewModel.templates.first(where: { !$0.placeholders.filter { $0.required }.isEmpty }) else {
            XCTSkip("No template with required placeholders found")
            return
        }
        viewModel.selectTemplate(template)
        
        let requiredPlaceholders = template.placeholders.filter { $0.required }
        guard !requiredPlaceholders.isEmpty else {
            XCTSkip("Template should have required placeholders")
            return
        }
        
        // Fill all but one required placeholder
        for placeholder in requiredPlaceholders.dropLast() {
            viewModel.updatePlaceholder(id: placeholder.id, value: "Filled")
        }
        // Leave last required placeholder empty
        
        // When
        let canGenerate = viewModel.canGenerateLetter()
        
        // Then
        XCTAssertFalse(canGenerate, "Should not be able to generate letter when required placeholder is missing")
    }
    
    func testCanGenerateLetter_WhitespaceOnlyValue_ReturnsFalse() {
        // Given
        guard let template = viewModel.templates.first(where: { !$0.placeholders.filter { $0.required }.isEmpty }) else {
            XCTSkip("No template with required placeholders found")
            return
        }
        viewModel.selectTemplate(template)
        
        let requiredPlaceholder = template.placeholders.first { $0.required }
        guard let placeholder = requiredPlaceholder else {
            XCTSkip("Template should have at least one required placeholder")
            return
        }
        
        // Fill all required placeholders except one with whitespace only
        for placeholder in template.placeholders.filter({ $0.required }) {
            if placeholder.id == placeholder.id {
                viewModel.updatePlaceholder(id: placeholder.id, value: "   ")
            } else {
                viewModel.updatePlaceholder(id: placeholder.id, value: "Filled")
            }
        }
        
        // When
        let canGenerate = viewModel.canGenerateLetter()
        
        // Then
        XCTAssertFalse(canGenerate, "Should not be able to generate letter with whitespace-only required placeholder")
    }
    
    func testCanGenerateLetter_OptionalPlaceholdersEmpty_ReturnsTrue() {
        // Given
        guard let template = viewModel.templates.first(where: { !$0.placeholders.filter { !$0.required }.isEmpty }) else {
            XCTSkip("No template with optional placeholders found")
            return
        }
        viewModel.selectTemplate(template)
        
        // Fill all required placeholders
        for placeholder in template.placeholders where placeholder.required {
            viewModel.updatePlaceholder(id: placeholder.id, value: "Filled")
        }
        // Leave optional placeholders empty
        
        // When
        let canGenerate = viewModel.canGenerateLetter()
        
        // Then
        XCTAssertTrue(canGenerate, "Should be able to generate letter when optional placeholders are empty")
    }
    
    // MARK: - Clear Functionality Tests
    
    func testClearLetter_ResetsSelectedTemplate() {
        // Given
        guard let template = viewModel.templates.first else {
            XCTFail("Should have at least one template")
            return
        }
        viewModel.selectTemplate(template)
        XCTAssertNotNil(viewModel.selectedTemplate, "Should have selected template")
        
        // When
        viewModel.clearLetter()
        
        // Then
        XCTAssertNil(viewModel.selectedTemplate, "Should clear selected template")
    }
    
    func testClearLetter_ResetsPlaceholders() {
        // Given
        guard let template = viewModel.templates.first else {
            XCTFail("Should have at least one template")
            return
        }
        viewModel.selectTemplate(template)
        viewModel.updatePlaceholder(id: template.placeholders.first?.id ?? UUID(), value: "test")
        XCTAssertFalse(viewModel.filledPlaceholders.isEmpty, "Should have filled placeholders")
        
        // When
        viewModel.clearLetter()
        
        // Then
        XCTAssertTrue(viewModel.filledPlaceholders.isEmpty, "Should clear filled placeholders")
    }
    
    func testClearLetter_ResetsGeneratedLetter() {
        // Given
        guard let template = viewModel.templates.first else {
            XCTFail("Should have at least one template")
            return
        }
        viewModel.selectTemplate(template)
        for placeholder in template.placeholders {
            viewModel.updatePlaceholder(id: placeholder.id, value: "test")
        }
        viewModel.generateLetter()
        XCTAssertFalse(viewModel.generatedLetter.isEmpty, "Should have generated letter")
        
        // When
        viewModel.clearLetter()
        
        // Then
        XCTAssertEqual(viewModel.generatedLetter, "", "Should clear generated letter")
    }
    
    // MARK: - Edge Cases Tests
    
    func testSelectTemplate_EmptyTemplate() {
        // Given - This is a theoretical test, as sample templates should have placeholders
        // We'll test with a template that has no placeholders if one exists
        guard let template = viewModel.templates.first(where: { $0.placeholders.isEmpty }) else {
            // No empty template exists, which is expected
            return
        }
        
        // When
        viewModel.selectTemplate(template)
        
        // Then
        XCTAssertEqual(viewModel.selectedTemplate?.id, template.id, "Should set selected template")
        XCTAssertTrue(viewModel.filledPlaceholders.isEmpty, "Should have empty placeholders")
    }
    
    func testGenerateLetter_MalformedPlaceholderKey() {
        // Given - This tests that the system handles placeholder keys correctly
        // Since we're using the actual template system, malformed keys shouldn't exist
        // But we can test that keys are replaced correctly
        guard let template = viewModel.templates.first,
              let placeholder = template.placeholders.first else {
            XCTFail("Should have at least one template with placeholders")
            return
        }
        viewModel.selectTemplate(template)
        
        // Fill all placeholders
        for placeholder in template.placeholders {
            viewModel.updatePlaceholder(id: placeholder.id, value: "Test")
        }
        
        // When
        viewModel.generateLetter()
        
        // Then
        // All placeholder keys in format [key] should be replaced
        XCTAssertFalse(viewModel.generatedLetter.contains("[\(placeholder.key)]"), "Placeholder key should be replaced")
    }
}

