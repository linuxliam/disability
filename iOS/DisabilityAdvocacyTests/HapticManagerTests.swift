//
//  HapticManagerTests.swift
//  DisabilityAdvocacyTests
//
//  Unit tests for HapticManager
//

import XCTest
@testable import DisabilityAdvocacy

@MainActor
final class HapticManagerTests: XCTestCase {
    
    func testLightHaptic() {
        // When/Then - should not crash
        HapticManager.light()
        // Haptic feedback doesn't return a value, so we just verify it doesn't crash
    }
    
    func testMediumHaptic() {
        // When/Then
        HapticManager.medium()
    }
    
    func testHeavyHaptic() {
        // When/Then
        HapticManager.heavy()
    }
    
    func testSuccessHaptic() {
        // When/Then
        HapticManager.success()
    }
    
    func testErrorHaptic() {
        // When/Then
        HapticManager.error()
    }
    
    func testWarningHaptic() {
        // When/Then
        HapticManager.warning()
    }
    
    func testSelectionHaptic() {
        // When/Then
        HapticManager.selection()
    }
    
    func testMultipleHaptics() {
        // When - trigger multiple haptics in sequence
        HapticManager.light()
        HapticManager.medium()
        HapticManager.heavy()
        
        // Then - should not crash
        // Haptic feedback is fire-and-forget, so we just verify it doesn't crash
    }
    
    func testHapticSequence() {
        // When - simulate a user interaction sequence
        HapticManager.selection() // User selects an item
        HapticManager.light()    // Item is highlighted
        HapticManager.success()   // Action completes
        
        // Then - should not crash
    }
}



