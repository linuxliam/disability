//
//  JSONStorageManagerTests.swift
//  DisabilityAdvocacyTests
//
//  Unit tests for JSONStorageManager
//

import XCTest
@testable import DisabilityAdvocacy_iOS

@MainActor
final class JSONStorageManagerTests: XCTestCase {
    var manager: JSONStorageManager!
    var testFilename: String!
    
    override func setUp() async throws {
        try await super.setUp()
        manager = JSONStorageManager.shared
        testFilename = "test_data_\(UUID().uuidString).json"
    }
    
    override func tearDown() async throws {
        // Clean up test files
        if let url = manager.getLocalFileURL(for: testFilename) {
            try? FileManager.default.removeItem(at: url)
        }
        try await super.tearDown()
    }
    
    // MARK: - Singleton Pattern Tests
    
    func testSharedInstance_ReturnsSameInstance() {
        // When
        let instance1 = JSONStorageManager.shared
        let instance2 = JSONStorageManager.shared
        
        // Then
        XCTAssertTrue(instance1 === instance2, "Shared instance should return the same instance")
    }
    
    // MARK: - Save and Load Tests
    
    func testSaveAndLoad_StoresAndRetrievesData() {
        // Given
        struct TestData: Codable, Equatable {
            let id: Int
            let name: String
        }
        let testData = [
            TestData(id: 1, name: "Test 1"),
            TestData(id: 2, name: "Test 2")
        ]
        
        // When
        manager.save(testData, filename: testFilename)
        let loaded: [TestData] = manager.load(filename: testFilename)
        
        // Then
        XCTAssertEqual(loaded.count, 2, "Should load 2 items")
        XCTAssertEqual(loaded, testData, "Loaded data should match saved data")
    }
    
    func testLoad_ReturnsEmptyArrayWhenFileDoesNotExist() {
        // When
        struct TestData: Codable {
            let id: Int
        }
        let loaded: [TestData] = manager.load(filename: "nonexistent_file.json")
        
        // Then
        XCTAssertTrue(loaded.isEmpty, "Should return empty array when file doesn't exist")
    }
    
    func testSave_OverwritesExistingFile() {
        // Given
        struct TestData: Codable, Equatable {
            let value: String
        }
        let initialData = [TestData(value: "Initial")]
        let updatedData = [TestData(value: "Updated")]
        
        // When
        manager.save(initialData, filename: testFilename)
        manager.save(updatedData, filename: testFilename)
        let loaded: [TestData] = manager.load(filename: testFilename)
        
        // Then
        XCTAssertEqual(loaded.count, 1, "Should have one item")
        XCTAssertEqual(loaded.first?.value, "Updated", "Should contain updated data")
    }
    
    // MARK: - File URL Tests
    
    func testGetLocalFileURL_ReturnsNilWhenFileDoesNotExist() {
        // When
        let url = manager.getLocalFileURL(for: "nonexistent_file.json")
        
        // Then
        XCTAssertNil(url, "Should return nil when file doesn't exist")
    }
    
    func testGetLocalFileURL_ReturnsURLWhenFileExists() {
        // Given
        struct TestData: Codable {
            let value: String
        }
        let testData = [TestData(value: "test")]
        manager.save(testData, filename: testFilename)
        
        // When
        let url = manager.getLocalFileURL(for: testFilename)
        
        // Then
        XCTAssertNotNil(url, "Should return URL when file exists")
        XCTAssertTrue(FileManager.default.fileExists(atPath: url!.path), "File should exist at returned URL")
    }
    
    // MARK: - Edge Cases
    
    func testSave_HandlesEmptyArray() {
        // Given
        struct TestData: Codable {
            let value: String
        }
        let emptyData: [TestData] = []
        
        // When
        manager.save(emptyData, filename: testFilename)
        let loaded: [TestData] = manager.load(filename: testFilename)
        
        // Then
        XCTAssertTrue(loaded.isEmpty, "Should handle empty array")
    }
    
    func testLoad_HandlesInvalidJSON() {
        // Given
        let invalidJSON = "invalid json content"
        if let url = manager.getLocalFileURL(for: testFilename) ?? FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(testFilename) {
            try? invalidJSON.write(to: url, atomically: true, encoding: .utf8)
        }
        
        // When
        struct TestData: Codable {
            let value: String
        }
        let loaded: [TestData] = manager.load(filename: testFilename)
        
        // Then
        XCTAssertTrue(loaded.isEmpty, "Should return empty array for invalid JSON")
    }
}
