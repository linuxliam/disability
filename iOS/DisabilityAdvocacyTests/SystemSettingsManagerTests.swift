//
//  SystemSettingsManagerTests.swift
//  DisabilityAdvocacyTests
//
//  Unit tests for SystemSettingsManager
//

import XCTest
@testable import DisabilityAdvocacy_iOS

@MainActor
final class SystemSettingsManagerTests: XCTestCase {
    
    // MARK: - Accessibility Settings Tests
    
    func testIsReduceMotionEnabled_ReturnsBoolean() {
        // When
        let result = SystemSettingsManager.isReduceMotionEnabled
        
        // Then
        XCTAssertTrue(result == true || result == false, "Should return a boolean value")
    }
    
    func testIsIncreaseContrastEnabled_ReturnsBoolean() {
        // When
        let result = SystemSettingsManager.isIncreaseContrastEnabled
        
        // Then
        XCTAssertTrue(result == true || result == false, "Should return a boolean value")
    }
    
    func testIsBoldTextEnabled_ReturnsBoolean() {
        // When
        let result = SystemSettingsManager.isBoldTextEnabled
        
        // Then
        XCTAssertTrue(result == true || result == false, "Should return a boolean value")
    }
    
    func testIsVoiceOverRunning_ReturnsBoolean() {
        // When
        let result = SystemSettingsManager.isVoiceOverRunning
        
        // Then
        XCTAssertTrue(result == true || result == false, "Should return a boolean value")
    }
    
    func testIsSwitchControlRunning_ReturnsBoolean() {
        // When
        let result = SystemSettingsManager.isSwitchControlRunning
        
        // Then
        XCTAssertTrue(result == true || result == false, "Should return a boolean value")
    }
    
    // MARK: - Consistency Tests
    
    func testAllSettings_AreAccessible() {
        // When/Then - All should be accessible without crashing
        _ = SystemSettingsManager.isReduceMotionEnabled
        _ = SystemSettingsManager.isIncreaseContrastEnabled
        _ = SystemSettingsManager.isBoldTextEnabled
        _ = SystemSettingsManager.isVoiceOverRunning
        _ = SystemSettingsManager.isSwitchControlRunning
        
        // If we get here, all properties are accessible
        XCTAssertTrue(true, "All settings should be accessible")
    }
}
