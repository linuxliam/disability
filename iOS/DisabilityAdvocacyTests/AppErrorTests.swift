//
//  AppErrorTests.swift
//  DisabilityAdvocacyTests
//
//  Unit tests for AppError
//

import XCTest
@testable import DisabilityAdvocacy_iOS

final class AppErrorTests: XCTestCase {
    
    // MARK: - Error Description Tests
    
    func testUserSaveFailed_ErrorDescription() {
        // Given
        let underlyingError = NSError(domain: "test", code: 1, userInfo: [NSLocalizedDescriptionKey: "Save failed"])
        let error = AppError.userSaveFailed(underlyingError)
        
        // Then
        XCTAssertNotNil(error.errorDescription, "Should have error description")
        XCTAssertTrue(error.errorDescription?.contains("Failed to save user profile") ?? false, "Should contain error message")
    }
    
    func testUserLoadFailed_ErrorDescription() {
        // Given
        let underlyingError = NSError(domain: "test", code: 1, userInfo: [NSLocalizedDescriptionKey: "Load failed"])
        let error = AppError.userLoadFailed(underlyingError)
        
        // Then
        XCTAssertNotNil(error.errorDescription, "Should have error description")
        XCTAssertTrue(error.errorDescription?.contains("Failed to load user profile") ?? false, "Should contain error message")
    }
    
    func testUserDecodeFailed_ErrorDescription() {
        // Given
        let underlyingError = NSError(domain: "test", code: 1, userInfo: [NSLocalizedDescriptionKey: "Decode failed"])
        let error = AppError.userDecodeFailed(underlyingError)
        
        // Then
        XCTAssertNotNil(error.errorDescription, "Should have error description")
        XCTAssertTrue(error.errorDescription?.contains("Failed to decode user profile") ?? false, "Should contain error message")
    }
    
    func testResourcesLoadFailed_ErrorDescription() {
        // Given
        let underlyingError = NSError(domain: "test", code: 1, userInfo: [NSLocalizedDescriptionKey: "Load failed"])
        let error = AppError.resourcesLoadFailed(underlyingError)
        
        // Then
        XCTAssertNotNil(error.errorDescription, "Should have error description")
        XCTAssertTrue(error.errorDescription?.contains("Failed to load resources") ?? false, "Should contain error message")
    }
    
    func testUnknown_ErrorDescription() {
        // Given
        let underlyingError = NSError(domain: "test", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unknown error"])
        let error = AppError.unknown(underlyingError)
        
        // Then
        XCTAssertNotNil(error.errorDescription, "Should have error description")
        XCTAssertTrue(error.errorDescription?.contains("An unexpected error occurred") ?? false, "Should contain error message")
    }
    
    // MARK: - User Facing Message Tests
    
    func testUserSaveFailed_UserFacingMessage() {
        // Given
        let underlyingError = NSError(domain: "test", code: 1)
        let error = AppError.userSaveFailed(underlyingError)
        
        // Then
        XCTAssertNotNil(error.userFacingMessage, "Should have user-facing message")
        XCTAssertFalse(error.userFacingMessage.isEmpty, "User-facing message should not be empty")
    }
    
    func testUserLoadFailed_UserFacingMessage() {
        // Given
        let underlyingError = NSError(domain: "test", code: 1)
        let error = AppError.userLoadFailed(underlyingError)
        
        // Then
        XCTAssertNotNil(error.userFacingMessage, "Should have user-facing message")
        XCTAssertFalse(error.userFacingMessage.isEmpty, "User-facing message should not be empty")
    }
    
    func testUserDecodeFailed_UserFacingMessage() {
        // Given
        let underlyingError = NSError(domain: "test", code: 1)
        let error = AppError.userDecodeFailed(underlyingError)
        
        // Then
        XCTAssertNotNil(error.userFacingMessage, "Should have user-facing message")
        XCTAssertFalse(error.userFacingMessage.isEmpty, "User-facing message should not be empty")
    }
    
    func testResourcesLoadFailed_UserFacingMessage() {
        // Given
        let underlyingError = NSError(domain: "test", code: 1)
        let error = AppError.resourcesLoadFailed(underlyingError)
        
        // Then
        XCTAssertNotNil(error.userFacingMessage, "Should have user-facing message")
        XCTAssertFalse(error.userFacingMessage.isEmpty, "User-facing message should not be empty")
    }
    
    func testUnknown_UserFacingMessage() {
        // Given
        let underlyingError = NSError(domain: "test", code: 1)
        let error = AppError.unknown(underlyingError)
        
        // Then
        XCTAssertNotNil(error.userFacingMessage, "Should have user-facing message")
        XCTAssertFalse(error.userFacingMessage.isEmpty, "User-facing message should not be empty")
    }
    
    // MARK: - LocalizedError Conformance Tests
    
    func testLocalizedError_Conformance() {
        // Given
        let underlyingError = NSError(domain: "test", code: 1)
        let error = AppError.userSaveFailed(underlyingError)
        
        // Then
        // Verify it conforms to LocalizedError by checking errorDescription exists
        XCTAssertNotNil(error.errorDescription, "Should conform to LocalizedError")
    }
}

