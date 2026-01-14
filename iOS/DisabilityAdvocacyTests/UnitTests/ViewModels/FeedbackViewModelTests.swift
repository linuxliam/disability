//
//  FeedbackViewModelTests.swift
//  DisabilityAdvocacyTests
//
//  Unit tests for FeedbackViewModel
//

import XCTest
@testable import DisabilityAdvocacy_iOS

@MainActor
final class FeedbackViewModelTests: XCTestCase {
    var viewModel: FeedbackViewModel!
    
    override func setUp() async throws {
        try await super.setUp()
        viewModel = FeedbackViewModel()
    }
    
    override func tearDown() async throws {
        viewModel = nil
        try await super.tearDown()
    }
    
    // MARK: - Toast Display Tests
    
    func testShow_AddsToastToList() {
        // Given
        let message = "Test message"
        
        // When
        viewModel.show(message: message, type: .info)
        
        // Then
        XCTAssertEqual(viewModel.toasts.count, 1, "Should have one toast")
        XCTAssertEqual(viewModel.toasts.first?.message, message, "Toast message should match")
        XCTAssertEqual(viewModel.toasts.first?.type, .info, "Toast type should match")
    }
    
    func testShow_WithCustomDuration_SetsDuration() {
        // Given
        let message = "Test message"
        let duration = 5.0
        
        // When
        viewModel.show(message: message, type: .success, duration: duration)
        
        // Then
        XCTAssertEqual(viewModel.toasts.first?.duration, duration, "Toast duration should match")
    }
    
    func testDismiss_RemovesToastFromList() {
        // Given
        viewModel.show(message: "Test", type: .info)
        let toast = viewModel.toasts.first!
        
        // When
        viewModel.dismiss(toast)
        
        // Then
        XCTAssertTrue(viewModel.toasts.isEmpty, "Toast should be removed")
    }
    
    // MARK: - Convenience Method Tests
    
    func testSuccess_ShowsSuccessToast() {
        // When
        viewModel.success("Operation successful")
        
        // Then
        XCTAssertEqual(viewModel.toasts.count, 1, "Should have one toast")
        XCTAssertEqual(viewModel.toasts.first?.type, .success, "Should be success type")
        XCTAssertEqual(viewModel.toasts.first?.message, "Operation successful", "Message should match")
    }
    
    func testError_ShowsErrorToast() {
        // When
        viewModel.error("Operation failed")
        
        // Then
        XCTAssertEqual(viewModel.toasts.count, 1, "Should have one toast")
        XCTAssertEqual(viewModel.toasts.first?.type, .error, "Should be error type")
        XCTAssertEqual(viewModel.toasts.first?.message, "Operation failed", "Message should match")
    }
    
    func testWarning_ShowsWarningToast() {
        // When
        viewModel.warning("Warning message")
        
        // Then
        XCTAssertEqual(viewModel.toasts.count, 1, "Should have one toast")
        XCTAssertEqual(viewModel.toasts.first?.type, .warning, "Should be warning type")
        XCTAssertEqual(viewModel.toasts.first?.message, "Warning message", "Message should match")
    }
    
    func testInfo_ShowsInfoToast() {
        // When
        viewModel.info("Info message")
        
        // Then
        XCTAssertEqual(viewModel.toasts.count, 1, "Should have one toast")
        XCTAssertEqual(viewModel.toasts.first?.type, .info, "Should be info type")
        XCTAssertEqual(viewModel.toasts.first?.message, "Info message", "Message should match")
    }
    
    // MARK: - Multiple Toasts Tests
    
    func testShow_MultipleToasts_AddsAll() {
        // When
        viewModel.show(message: "First", type: .info)
        viewModel.show(message: "Second", type: .success)
        viewModel.show(message: "Third", type: .error)
        
        // Then
        XCTAssertEqual(viewModel.toasts.count, 3, "Should have three toasts")
    }
    
    func testDismiss_SpecificToast_RemovesOnlyThatToast() {
        // Given
        viewModel.show(message: "First", type: .info)
        viewModel.show(message: "Second", type: .success)
        let firstToast = viewModel.toasts.first!
        
        // When
        viewModel.dismiss(firstToast)
        
        // Then
        XCTAssertEqual(viewModel.toasts.count, 1, "Should have one toast remaining")
        XCTAssertEqual(viewModel.toasts.first?.message, "Second", "Remaining toast should be the second one")
    }
    
    // MARK: - FeedbackType Tests
    
    func testFeedbackType_Icons_AreCorrect() {
        XCTAssertEqual(FeedbackType.success.icon, "checkmark.circle.fill")
        XCTAssertEqual(FeedbackType.error.icon, "exclamationmark.circle.fill")
        XCTAssertEqual(FeedbackType.warning.icon, "exclamationmark.triangle.fill")
        XCTAssertEqual(FeedbackType.info.icon, "info.circle.fill")
    }
    
    func testFeedbackType_Colors_AreSet() {
        // Colors are semantic colors, just verify they're not nil
        XCTAssertNotNil(FeedbackType.success.color)
        XCTAssertNotNil(FeedbackType.error.color)
        XCTAssertNotNil(FeedbackType.warning.color)
        XCTAssertNotNil(FeedbackType.info.color)
    }
    
    // MARK: - Toast Model Tests
    
    func testToast_Equality_ComparesById() {
        // Given
        let toast1 = Toast(message: "Test", type: .info)
        let toast2 = Toast(message: "Test", type: .info)
        
        // Then
        XCTAssertNotEqual(toast1, toast2, "Toasts with different IDs should not be equal")
    }
    
    func testToast_DefaultDuration_IsSet() {
        // Given
        let toast = Toast(message: "Test", type: .info)
        
        // Then
        XCTAssertEqual(toast.duration, 3.5, "Default duration should be 3.5 seconds")
    }
}
