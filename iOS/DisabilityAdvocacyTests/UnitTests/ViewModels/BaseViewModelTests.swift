//
//  BaseViewModelTests.swift
//  DisabilityAdvocacyTests
//
//  Unit tests for BaseViewModel protocol
//

import XCTest
@testable import DisabilityAdvocacy_iOS

@MainActor
final class BaseViewModelTests: XCTestCase {
    
    // Create a concrete implementation for testing
    class TestViewModel: BaseViewModelProtocol {
        var isLoading: Bool = false
        var errorMessage: String?
        var showError: Bool = false
    }
    
    var viewModel: TestViewModel!
    
    override func setUp() async throws {
        try await super.setUp()
        viewModel = TestViewModel()
    }
    
    // MARK: - Error Handling Tests
    
    func testHandleError_WithAppError_SetsErrorMessage() {
        // Given
        let appError = AppError.networkError("Test network error")
        
        // When
        viewModel.handleError(appError)
        
        // Then
        XCTAssertNotNil(viewModel.errorMessage, "Error message should be set")
        XCTAssertTrue(viewModel.showError, "Show error should be true")
        XCTAssertEqual(viewModel.errorMessage, appError.errorDescription, "Error message should match AppError description")
    }
    
    func testHandleError_WithGenericError_SetsErrorMessage() {
        // Given
        let error = NSError(domain: "TestDomain", code: 123, userInfo: [NSLocalizedDescriptionKey: "Test error"])
        
        // When
        viewModel.handleError(error)
        
        // Then
        XCTAssertNotNil(viewModel.errorMessage, "Error message should be set")
        XCTAssertTrue(viewModel.showError, "Show error should be true")
        XCTAssertEqual(viewModel.errorMessage, error.localizedDescription, "Error message should match localized description")
    }
    
    func testClearError_ResetsErrorState() {
        // Given
        viewModel.errorMessage = "Test error"
        viewModel.showError = true
        
        // When
        viewModel.clearError()
        
        // Then
        XCTAssertNil(viewModel.errorMessage, "Error message should be nil")
        XCTAssertFalse(viewModel.showError, "Show error should be false")
    }
    
    // MARK: - State Management Tests
    
    func testIsLoading_CanBeSet() {
        // When
        viewModel.isLoading = true
        
        // Then
        XCTAssertTrue(viewModel.isLoading, "isLoading should be true")
        
        // When
        viewModel.isLoading = false
        
        // Then
        XCTAssertFalse(viewModel.isLoading, "isLoading should be false")
    }
    
    func testErrorState_CanBeSet() {
        // When
        viewModel.errorMessage = "Test error"
        viewModel.showError = true
        
        // Then
        XCTAssertEqual(viewModel.errorMessage, "Test error", "Error message should be set")
        XCTAssertTrue(viewModel.showError, "Show error should be true")
    }
}
