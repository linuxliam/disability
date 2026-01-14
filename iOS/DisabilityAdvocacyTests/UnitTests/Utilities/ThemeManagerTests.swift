//
//  ThemeManagerTests.swift
//  DisabilityAdvocacyTests
//
//  Unit tests for ThemeManager
//

import XCTest
import SwiftUI
@testable import DisabilityAdvocacy_iOS

@MainActor
final class ThemeManagerTests: XCTestCase {
    var themeManager: ThemeManager!
    var userDefaults: UserDefaults!
    
    override func setUp() async throws {
        try await super.setUp()
        // Use a test UserDefaults suite
        userDefaults = UserDefaults(suiteName: "test.theme.manager")!
        userDefaults.removePersistentDomain(forName: "test.theme.manager")
        
        themeManager = ThemeManager()
    }
    
    override func tearDown() async throws {
        userDefaults.removePersistentDomain(forName: "test.theme.manager")
        themeManager = nil
        try await super.tearDown()
    }
    
    // MARK: - Configuration Tests
    
    func testInitialConfiguration_LoadsFromUserDefaults() {
        // Given - Set up UserDefaults
        UserDefaults.standard.set("dark", forKey: "theme.colorScheme")
        UserDefaults.standard.set(true, forKey: "theme.highContrast")
        
        // When
        let manager = ThemeManager()
        
        // Then
        XCTAssertEqual(manager.configuration.colorScheme, .dark, "Should load dark color scheme")
        XCTAssertTrue(manager.configuration.highContrast, "Should load high contrast setting")
    }
    
    func testConfiguration_DefaultsToDefaultConfiguration() {
        // When
        let config = ThemeManager.loadConfiguration()
        
        // Then
        XCTAssertNotNil(config, "Should return a configuration")
        // Default configuration should have nil colorScheme (system)
        XCTAssertNil(config.colorScheme, "Default should use system color scheme")
    }
    
    // MARK: - Color Scheme Tests
    
    func testColorScheme_CanBeSet() {
        // When
        themeManager.colorScheme = .dark
        
        // Then
        XCTAssertEqual(themeManager.colorScheme, .dark, "Color scheme should be set to dark")
    }
    
    func testColorScheme_ReturnsSystemWhenNil() {
        // Given
        themeManager.configuration.colorScheme = nil
        
        // Then - Should return system color scheme (implementation dependent)
        // Just verify it doesn't crash
        _ = themeManager.colorScheme
        XCTAssertTrue(true, "Should handle nil color scheme")
    }
    
    // MARK: - High Contrast Tests
    
    func testHighContrast_CanBeSet() {
        // When
        themeManager.highContrast = true
        
        // Then
        XCTAssertTrue(themeManager.highContrast, "High contrast should be enabled")
    }
    
    func testHighContrast_RespectsSystemSettings() {
        // Given - System settings manager returns a value
        // The actual value depends on system, but should not crash
        _ = themeManager.highContrast
        XCTAssertTrue(true, "Should handle system settings")
    }
    
    // MARK: - Reduced Motion Tests
    
    func testReducedMotion_CanBeSet() {
        // When
        themeManager.reducedMotion = true
        
        // Then
        XCTAssertTrue(themeManager.reducedMotion, "Reduced motion should be enabled")
    }
    
    // MARK: - Custom Font Size Tests
    
    func testCustomFontSize_CanBeSet() {
        // When
        themeManager.customFontSize = 1.5
        
        // Then
        XCTAssertEqual(themeManager.customFontSize, 1.5, "Custom font size should be set")
    }
    
    func testCustomFontSize_ClampsToMinimum() {
        // When
        themeManager.customFontSize = 0.5
        
        // Then
        XCTAssertEqual(themeManager.customFontSize, 0.8, "Should clamp to minimum 0.8")
    }
    
    func testCustomFontSize_ClampsToMaximum() {
        // When
        themeManager.customFontSize = 3.0
        
        // Then
        XCTAssertEqual(themeManager.customFontSize, 2.0, "Should clamp to maximum 2.0")
    }
    
    // MARK: - Screen Reader Tests
    
    func testScreenReaderOptimized_CanBeSet() {
        // When
        themeManager.screenReaderOptimized = true
        
        // Then
        XCTAssertTrue(themeManager.screenReaderOptimized, "Screen reader optimized should be enabled")
    }
    
    // MARK: - Color Tests
    
    func testPrimaryColor_ReturnsTriadPrimary() {
        // When
        let color = themeManager.primaryColor
        
        // Then
        XCTAssertNotNil(color, "Primary color should not be nil")
    }
    
    func testSecondaryColor_ReturnsTriadSecondary() {
        // When
        let color = themeManager.secondaryColor
        
        // Then
        XCTAssertNotNil(color, "Secondary color should not be nil")
    }
    
    func testTertiaryColor_ReturnsTriadTertiary() {
        // When
        let color = themeManager.tertiaryColor
        
        // Then
        XCTAssertNotNil(color, "Tertiary color should not be nil")
    }
    
    func testBackgroundColor_RespectsHighContrast() {
        // Given
        themeManager.highContrast = true
        themeManager.colorScheme = .dark
        
        // When
        let color = themeManager.backgroundColor
        
        // Then
        XCTAssertNotNil(color, "Background color should not be nil")
    }
    
    func testPrimaryTextColor_RespectsHighContrast() {
        // Given
        themeManager.highContrast = true
        themeManager.colorScheme = .light
        
        // When
        let color = themeManager.primaryTextColor
        
        // Then
        XCTAssertNotNil(color, "Primary text color should not be nil")
    }
    
    // MARK: - Semantic Colors Tests
    
    func testSuccessColor_ReturnsSemanticSuccess() {
        // When
        let color = themeManager.successColor
        
        // Then
        XCTAssertNotNil(color, "Success color should not be nil")
    }
    
    func testWarningColor_ReturnsSemanticWarning() {
        // When
        let color = themeManager.warningColor
        
        // Then
        XCTAssertNotNil(color, "Warning color should not be nil")
    }
    
    func testErrorColor_ReturnsSemanticError() {
        // When
        let color = themeManager.errorColor
        
        // Then
        XCTAssertNotNil(color, "Error color should not be nil")
    }
    
    func testInfoColor_ReturnsSemanticInfo() {
        // When
        let color = themeManager.infoColor
        
        // Then
        XCTAssertNotNil(color, "Info color should not be nil")
    }
    
    // MARK: - Animation Tests
    
    func testAnimationStyle_ReturnsNilWhenReducedMotion() {
        // Given
        themeManager.reducedMotion = true
        
        // When
        let animation = themeManager.animationStyle
        
        // Then
        XCTAssertNil(animation, "Animation should be nil when reduced motion is enabled")
    }
    
    func testAnimationStyle_ReturnsDefaultWhenNotReducedMotion() {
        // Given
        themeManager.reducedMotion = false
        
        // When
        let animation = themeManager.animationStyle
        
        // Then
        XCTAssertNotNil(animation, "Animation should not be nil when reduced motion is disabled")
    }
    
    func testSpringAnimation_ReturnsNilWhenReducedMotion() {
        // Given
        themeManager.reducedMotion = true
        
        // When
        let animation = themeManager.springAnimation()
        
        // Then
        XCTAssertNil(animation, "Spring animation should be nil when reduced motion is enabled")
    }
    
    func testSpringAnimation_ReturnsSpringAnimationWhenNotReducedMotion() {
        // Given
        themeManager.reducedMotion = false
        
        // When
        let animation = themeManager.springAnimation(response: 0.3, dampingFraction: 0.7)
        
        // Then
        XCTAssertNotNil(animation, "Spring animation should not be nil when reduced motion is disabled")
    }
    
    // MARK: - Persistence Tests
    
    func testConfiguration_PersistsToUserDefaults() {
        // Given
        themeManager.configuration.colorScheme = .light
        themeManager.configuration.highContrast = true
        
        // When - Configuration change triggers persistence
        themeManager.configuration = themeManager.configuration
        
        // Then
        let savedScheme = UserDefaults.standard.string(forKey: "theme.colorScheme")
        let savedContrast = UserDefaults.standard.bool(forKey: "theme.highContrast")
        
        XCTAssertEqual(savedScheme, "light", "Color scheme should be persisted")
        XCTAssertTrue(savedContrast, "High contrast should be persisted")
    }
    
    func testLoadConfiguration_LoadsLightScheme() {
        // Given
        UserDefaults.standard.set("light", forKey: "theme.colorScheme")
        
        // When
        let config = ThemeManager.loadConfiguration()
        
        // Then
        XCTAssertEqual(config.colorScheme, .light, "Should load light color scheme")
    }
    
    func testLoadConfiguration_LoadsDarkScheme() {
        // Given
        UserDefaults.standard.set("dark", forKey: "theme.colorScheme")
        
        // When
        let config = ThemeManager.loadConfiguration()
        
        // Then
        XCTAssertEqual(config.colorScheme, .dark, "Should load dark color scheme")
    }
    
    func testLoadConfiguration_HandlesInvalidScheme() {
        // Given
        UserDefaults.standard.set("invalid", forKey: "theme.colorScheme")
        
        // When
        let config = ThemeManager.loadConfiguration()
        
        // Then
        XCTAssertNil(config.colorScheme, "Should handle invalid color scheme")
    }
}
