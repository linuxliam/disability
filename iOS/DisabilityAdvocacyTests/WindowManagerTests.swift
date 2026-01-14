//
//  WindowManagerTests.swift
//  DisabilityAdvocacyTests
//
//  Unit tests for WindowManager
//

import XCTest
@testable import DisabilityAdvocacy_iOS

@MainActor
final class WindowManagerTests: XCTestCase {
    var manager: WindowManager!
    
    override func setUp() async throws {
        try await super.setUp()
        manager = WindowManager.shared
    }
    
    // MARK: - Singleton Pattern Tests
    
    func testSharedInstance_ReturnsSameInstance() {
        // When
        let instance1 = WindowManager.shared
        let instance2 = WindowManager.shared
        
        // Then
        XCTAssertTrue(instance1 === instance2, "Shared instance should return the same instance")
    }
    
    #if os(macOS)
    // macOS-specific tests would go here
    // Note: Testing window state requires actual NSWindow instances
    // which is complex in unit tests, so we focus on basic functionality
    #endif
    
    // MARK: - Basic Functionality Tests
    
    func testManager_CanBeInitialized() {
        // Then
        XCTAssertNotNil(manager, "Manager should be initialized")
    }
    
    func testResetWindowState_DoesNotCrash() async {
        // When/Then - Should not crash
        await manager.resetWindowState()
        XCTAssertTrue(true, "Reset should complete without crashing")
    }
}
