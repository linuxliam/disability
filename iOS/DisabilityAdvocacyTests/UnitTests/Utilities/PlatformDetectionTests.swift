//
//  PlatformDetectionTests.swift
//  DisabilityAdvocacyTests
//
//  Unit tests for PlatformDetection
//

import XCTest
@testable import DisabilityAdvocacy_iOS

final class PlatformDetectionTests: XCTestCase {
    
    // MARK: - Platform Detection Tests
    
    func testIsIOS_ReturnsTrueOnIOS() {
        // When
        let isIOS = PlatformDetection.isIOS
        
        // Then
        #if os(iOS)
        XCTAssertTrue(isIOS, "Should return true on iOS")
        #else
        XCTAssertFalse(isIOS, "Should return false on macOS")
        #endif
    }
    
    func testIsMacOS_ReturnsTrueOnMacOS() {
        // When
        let isMacOS = PlatformDetection.isMacOS
        
        // Then
        #if os(macOS)
        XCTAssertTrue(isMacOS, "Should return true on macOS")
        #else
        XCTAssertFalse(isMacOS, "Should return false on iOS")
        #endif
    }
    
    func testPlatformName_ReturnsCorrectPlatform() {
        // When
        let platformName = PlatformDetection.platformName
        
        // Then
        #if os(iOS)
        XCTAssertEqual(platformName, "iOS", "Should return 'iOS' on iOS")
        #elseif os(macOS)
        XCTAssertEqual(platformName, "macOS", "Should return 'macOS' on macOS")
        #else
        XCTAssertEqual(platformName, "Unknown", "Should return 'Unknown' on other platforms")
        #endif
    }
    
    // MARK: - Version Detection Tests
    
    func testIOSVersion_ReturnsVersionOnIOS() {
        // When
        let version = PlatformDetection.iOSVersion
        
        // Then
        #if os(iOS)
        XCTAssertGreaterThan(version.major, 0, "Major version should be greater than 0 on iOS")
        #else
        XCTAssertEqual(version.major, 0, "Should return 0.0.0 on macOS")
        XCTAssertEqual(version.minor, 0, "Should return 0.0.0 on macOS")
        XCTAssertEqual(version.patch, 0, "Should return 0.0.0 on macOS")
        #endif
    }
    
    func testMacOSVersion_ReturnsVersionOnMacOS() {
        // When
        let version = PlatformDetection.macOSVersion
        
        // Then
        #if os(macOS)
        XCTAssertGreaterThan(version.major, 0, "Major version should be greater than 0 on macOS")
        #else
        XCTAssertEqual(version.major, 0, "Should return 0.0.0 on iOS")
        XCTAssertEqual(version.minor, 0, "Should return 0.0.0 on iOS")
        XCTAssertEqual(version.patch, 0, "Should return 0.0.0 on iOS")
        #endif
    }
    
    // MARK: - Feature Availability Tests
    
    func testIsFeatureAvailable_HapticFeedback_IsIOSOnly() {
        // When
        let available = PlatformDetection.isFeatureAvailable(.hapticFeedback)
        
        // Then
        #if os(iOS)
        XCTAssertTrue(available, "Haptic feedback should be available on iOS")
        #else
        XCTAssertFalse(available, "Haptic feedback should not be available on macOS")
        #endif
    }
    
    func testIsFeatureAvailable_ShareSheet_IsAvailableOnBoth() {
        // When
        let available = PlatformDetection.isFeatureAvailable(.shareSheet)
        
        // Then
        XCTAssertTrue(available, "Share sheet should be available on both platforms")
    }
    
    func testIsFeatureAvailable_FilePicker_IsMacOSOnly() {
        // When
        let available = PlatformDetection.isFeatureAvailable(.filePicker)
        
        // Then
        #if os(macOS)
        XCTAssertTrue(available, "File picker should be available on macOS")
        #else
        XCTAssertFalse(available, "File picker should not be available on iOS")
        #endif
    }
    
    func testIsFeatureAvailable_SystemSettings_IsAvailableOnBoth() {
        // When
        let available = PlatformDetection.isFeatureAvailable(.systemSettings)
        
        // Then
        XCTAssertTrue(available, "System settings should be available on both platforms")
    }
    
    func testIsFeatureAvailable_Notifications_IsAvailableOnBoth() {
        // When
        let available = PlatformDetection.isFeatureAvailable(.notifications)
        
        // Then
        XCTAssertTrue(available, "Notifications should be available on both platforms")
    }
    
    // MARK: - List Style Tests
    
    func testDefaultListStyle_ReturnsPlatformAppropriateStyle() {
        // When
        let listStyle = PlatformDetection.defaultListStyle
        
        // Then
        // Just verify it doesn't crash and returns a value
        XCTAssertNotNil(listStyle, "List style should not be nil")
    }
    
    // MARK: - Platform Feature Enum Tests
    
    func testPlatformFeature_AllCasesExist() {
        // Then
        let features: [PlatformFeature] = [
            .hapticFeedback,
            .shareSheet,
            .filePicker,
            .systemSettings,
            .notifications
        ]
        
        XCTAssertEqual(features.count, 5, "Should have 5 platform features")
    }
}
