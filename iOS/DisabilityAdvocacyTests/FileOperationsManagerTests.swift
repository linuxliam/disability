//
//  FileOperationsManagerTests.swift
//  DisabilityAdvocacyTests
//
//  Unit tests for FileOperationsManager
//

import XCTest
@testable import DisabilityAdvocacy_iOS

@MainActor
final class FileOperationsManagerTests: XCTestCase {
    var manager: FileOperationsManager!
    
    override func setUp() async throws {
        try await super.setUp()
        manager = FileOperationsManager.shared
    }
    
    // MARK: - Singleton Pattern Tests
    
    func testSharedInstance_ReturnsSameInstance() {
        // When
        let instance1 = FileOperationsManager.shared
        let instance2 = FileOperationsManager.shared
        
        // Then
        XCTAssertTrue(instance1 === instance2, "Shared instance should return the same instance")
    }
    
    // MARK: - Platform-Specific Tests
    
    #if os(iOS)
    func testImportResources_ReturnsNilOniOS() async {
        // When
        let result = await manager.importResources()
        
        // Then
        XCTAssertNil(result, "Should return nil on iOS (not implemented)")
    }
    
    func testImportEvents_ReturnsNilOniOS() async {
        // When
        let result = await manager.importEvents()
        
        // Then
        XCTAssertNil(result, "Should return nil on iOS (not implemented)")
    }
    
    func testExportResources_ReturnsFalseOniOS() async {
        // Given
        let resources = [TestDataFactory.makeResource()]
        
        // When
        let result = await manager.exportResources(resources)
        
        // Then
        XCTAssertFalse(result, "Should return false on iOS (not implemented)")
    }
    
    func testExportEvents_ReturnsFalseOniOS() async {
        // Given
        let events = [TestDataFactory.makeEvent()]
        
        // When
        let result = await manager.exportEvents(events)
        
        // Then
        XCTAssertFalse(result, "Should return false on iOS (not implemented)")
    }
    #endif
    
    // MARK: - Error Handling Tests
    
    func testManager_CanBeInitialized() {
        // Then
        XCTAssertNotNil(manager, "Manager should be initialized")
    }
}
