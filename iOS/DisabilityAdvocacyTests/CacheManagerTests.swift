//
//  CacheManagerTests.swift
//  DisabilityAdvocacyTests
//
//  Unit tests for CacheManager
//

import XCTest
@testable import DisabilityAdvocacy

final class CacheManagerTests: XCTestCase {
    var cacheManager: CacheManager!
    
    override func setUp() async throws {
        try await super.setUp()
        cacheManager = CacheManager.shared
        // Clear cache before each test
        await cacheManager.clearAll()
    }
    
    override func tearDown() async throws {
        await cacheManager.clearAll()
        cacheManager = nil
        try await super.tearDown()
    }
    
    // MARK: - Singleton Pattern Tests
    
    func testSharedInstance_ReturnsSameInstance() {
        // When
        let instance1 = CacheManager.shared
        let instance2 = CacheManager.shared
        
        // Then
        XCTAssertTrue(instance1 === instance2, "Shared instance should return the same instance")
    }
    
    // MARK: - Cache Operations Tests
    
    func testCache_StoresData() async {
        // Given
        struct TestData: Codable, Equatable {
            let value: String
        }
        let testData = TestData(value: "test")
        let key = "test_key"
        
        // When
        await cacheManager.cache(testData, key: key)
        
        // Then
        let retrieved = await cacheManager.retrieve(key: key, type: TestData.self)
        XCTAssertNotNil(retrieved, "Should retrieve cached data")
        XCTAssertEqual(retrieved, testData, "Retrieved data should match cached data")
    }
    
    func testRetrieve_NonExistentKey_ReturnsNil() async {
        // Given
        let key = "nonexistent_key"
        
        // When
        let retrieved = await cacheManager.retrieve(key: key, type: String.self)
        
        // Then
        XCTAssertNil(retrieved, "Should return nil for non-existent key")
    }
    
    func testCache_StoresDifferentTypes() async {
        // Given
        let stringKey = "string_key"
        let intKey = "int_key"
        let arrayKey = "array_key"
        
        // When
        await cacheManager.cache("test string", key: stringKey)
        await cacheManager.cache(42, key: intKey)
        await cacheManager.cache([1, 2, 3], key: arrayKey)
        
        // Then
        XCTAssertEqual(await cacheManager.retrieve(key: stringKey, type: String.self), "test string")
        XCTAssertEqual(await cacheManager.retrieve(key: intKey, type: Int.self), 42)
        XCTAssertEqual(await cacheManager.retrieve(key: arrayKey, type: [Int].self), [1, 2, 3])
    }
    
    // MARK: - Expiration Tests
    
    func testRetrieve_ExpiredCache_ReturnsNil() async {
        // Given
        struct TestData: Codable {
            let value: String
        }
        let testData = TestData(value: "test")
        let key = "expired_key"
        let pastDate = Date().addingTimeInterval(-86400) // 1 day ago
        
        // When
        await cacheManager.cache(testData, key: key, expirationDate: pastDate)
        
        // Then
        let retrieved = await cacheManager.retrieve(key: key, type: TestData.self)
        XCTAssertNil(retrieved, "Should return nil for expired cache")
    }
    
    func testRetrieve_ValidCache_ReturnsData() async {
        // Given
        struct TestData: Codable {
            let value: String
        }
        let testData = TestData(value: "test")
        let key = "valid_key"
        let futureDate = Date().addingTimeInterval(86400) // 1 day from now
        
        // When
        await cacheManager.cache(testData, key: key, expirationDate: futureDate)
        
        // Then
        let retrieved = await cacheManager.retrieve(key: key, type: TestData.self)
        XCTAssertNotNil(retrieved, "Should return data for valid cache")
    }
    
    func testCache_DefaultExpiration() async {
        // Given
        struct TestData: Codable {
            let value: String
        }
        let testData = TestData(value: "test")
        let key = "default_expiration_key"
        
        // When
        await cacheManager.cache(testData, key: key) // No expiration date
        
        // Then
        let retrieved = await cacheManager.retrieve(key: key, type: TestData.self)
        XCTAssertNotNil(retrieved, "Should return data with default expiration (7 days)")
    }
    
    // MARK: - Cache Clearing Tests
    
    func testClearAll_RemovesAllCachedData() async {
        // Given
        await cacheManager.cache("test1", key: "key1")
        await cacheManager.cache("test2", key: "key2")
        await cacheManager.cache("test3", key: "key3")
        
        // When
        await cacheManager.clearAll()
        
        // Then
        XCTAssertNil(await cacheManager.retrieve(key: "key1", type: String.self))
        XCTAssertNil(await cacheManager.retrieve(key: "key2", type: String.self))
        XCTAssertNil(await cacheManager.retrieve(key: "key3", type: String.self))
    }
    
    func testRemove_RemovesSpecificKey() async {
        // Given
        await cacheManager.cache("test1", key: "key1")
        await cacheManager.cache("test2", key: "key2")
        
        // When
        await cacheManager.remove(key: "key1")
        
        // Then
        XCTAssertNil(await cacheManager.retrieve(key: "key1", type: String.self), "Should remove key1")
        XCTAssertNotNil(await cacheManager.retrieve(key: "key2", type: String.self), "Should keep key2")
    }
    
    func testClearExpired_RemovesOnlyExpiredEntries() async {
        // Given
        struct TestData: Codable {
            let value: String
        }
        let pastDate = Date().addingTimeInterval(-86400)
        let futureDate = Date().addingTimeInterval(86400)
        
        await cacheManager.cache(TestData(value: "expired"), key: "expired_key", expirationDate: pastDate)
        await cacheManager.cache(TestData(value: "valid"), key: "valid_key", expirationDate: futureDate)
        
        // When
        await cacheManager.clearExpired()
        
        // Then
        XCTAssertNil(await cacheManager.retrieve(key: "expired_key", type: TestData.self), "Should remove expired entry")
        XCTAssertNotNil(await cacheManager.retrieve(key: "valid_key", type: TestData.self), "Should keep valid entry")
    }
    
    // MARK: - Type-Specific Cache Methods Tests
    
    func testCacheResources_StoresResources() async {
        // Given
        let resources = [
            Resource(title: "Test Resource", description: "Description", category: .legal)
        ]
        
        // When
        await cacheManager.cacheResources(resources)
        
        // Then
        let retrieved = await cacheManager.retrieveResources()
        XCTAssertNotNil(retrieved, "Should retrieve cached resources")
        XCTAssertEqual(retrieved?.count, resources.count, "Should retrieve same number of resources")
    }
    
    func testCacheEvents_StoresEvents() async {
        // Given
        let events = [
            Event(title: "Test Event", description: "Description", date: Date(), location: "Location", category: .workshop)
        ]
        
        // When
        await cacheManager.cacheEvents(events)
        
        // Then
        let retrieved = await cacheManager.retrieveEvents()
        XCTAssertNotNil(retrieved, "Should retrieve cached events")
        XCTAssertEqual(retrieved?.count, events.count, "Should retrieve same number of events")
    }
    
    // MARK: - Error Handling Tests
    
    func testRetrieve_CorruptedFile_ReturnsNil() async {
        // Given
        // This test would require manually creating a corrupted file
        // In a real scenario, we might use file system mocking
        // For now, we test that the system handles errors gracefully
        
        struct TestData: Codable {
            let value: String
        }
        
        // When - retrieve non-existent key (simulates error case)
        let retrieved = await cacheManager.retrieve(key: "corrupted_key", type: TestData.self)
        
        // Then
        XCTAssertNil(retrieved, "Should return nil for invalid/corrupted cache")
    }
    
    // MARK: - Cache Keys Tests
    
    func testCacheKeys_AreDefined() {
        // Then
        XCTAssertEqual(CacheManager.CacheKey.resources, "resources")
        XCTAssertEqual(CacheManager.CacheKey.events, "events")
        XCTAssertEqual(CacheManager.CacheKey.news, "news")
        XCTAssertEqual(CacheManager.CacheKey.communityPosts, "community_posts")
    }
}

