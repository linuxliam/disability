//
//  AppThemeTests.swift
//  DisabilityAdvocacyTests
//
//  Unit tests for AppTheme
//

import XCTest
import SwiftUI
@testable import DisabilityAdvocacy_iOS

final class AppThemeTests: XCTestCase {
    
    // MARK: - Constants Tests
    
    func testDefaultContentMaxWidth_IsSet() {
        // Then
        XCTAssertEqual(AppTheme.defaultContentMaxWidth, 1100, "Default content max width should be 1100")
    }
    
    // MARK: - Background Colors Tests
    
    func testGroupedBackgroundColor_IsNotNil() {
        // When
        let color = AppTheme.groupedBackgroundColor
        
        // Then
        XCTAssertNotNil(color, "Grouped background color should not be nil")
    }
    
    // MARK: - Environment Values Tests
    
    func testAppContentMaxWidth_EnvironmentKey_IsSet() {
        // Given
        var environment = EnvironmentValues()
        
        // When
        environment.appContentMaxWidth = 800
        
        // Then
        XCTAssertEqual(environment.appContentMaxWidth, 800, "Environment value should be set")
    }
    
    func testAppContentMaxWidth_DefaultValue_IsCorrect() {
        // Given
        let environment = EnvironmentValues()
        
        // Then
        XCTAssertEqual(environment.appContentMaxWidth, AppTheme.defaultContentMaxWidth, "Default should match AppTheme constant")
    }
}
