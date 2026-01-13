//
//  UserManagerTests.swift
//  DisabilityAdvocacyTests
//
//  Unit tests for UserManager
//

import XCTest
@testable import DisabilityAdvocacy_iOS

@MainActor
final class UserManagerTests: XCTestCase {
    var manager: UserManager!
    
    override func setUp() {
        super.setUp()
        // Clear any existing user data
        UserDefaults.standard.removeObject(forKey: "savedUserProfile")
        manager = UserManager.shared
    }
    
    override func tearDown() {
        UserDefaults.standard.removeObject(forKey: "savedUserProfile")
        super.tearDown()
    }
    
    func testSaveAndLoadUser() async {
        // Given
        let testUser = User(
            name: "Test User",
            email: "test@example.com",
            phoneNumber: "123-456-7890",
            location: "Test Location"
        )
        
        // When
        let saveResult = await manager.saveUser(testUser)
        let loadResult = await manager.loadUser()
        
        // Then
        switch saveResult {
        case .success:
            break
        case .failure(let error):
            XCTFail("Save should succeed, but got error: \(error)")
        }
        
        switch loadResult {
        case .success(let loadedUser):
            XCTAssertEqual(loadedUser.name, testUser.name, "User name should match")
            XCTAssertEqual(loadedUser.email, testUser.email, "User email should match")
            XCTAssertEqual(loadedUser.phoneNumber, testUser.phoneNumber, "User phone should match")
            XCTAssertEqual(loadedUser.location, testUser.location, "User location should match")
        case .failure(let error):
            XCTFail("Load should succeed, but got error: \(error)")
        }
    }
    
    func testLoadUserWhenNoneExists() async {
        // When
        let result = await manager.loadUser()
        
        // Then
        switch result {
        case .success(let user):
            // Should return default user
            XCTAssertNotNil(user, "Should return a default user when none exists")
        case .failure:
            // Expected - no user exists yet
            break
        }
    }
    
    func testUserPersistence() async {
        // Given
        let testUser = User(
            name: "Persistence Test",
            email: "persist@example.com",
            phoneNumber: "555-1234",
            location: "Test City"
        )
        
        // When
        _ = await manager.saveUser(testUser)
        let loadedUser = await manager.loadUser()
        
        // Then
        switch loadedUser {
        case .success(let user):
            XCTAssertEqual(user.name, testUser.name, "User should persist across operations")
        case .failure:
            XCTFail("User should persist successfully")
        }
    }
    
    func testDeleteUser() async {
        // Given
        let testUser = User(
            name: "Delete Test",
            email: "delete@example.com",
            phoneNumber: "555-9999",
            location: "Test City"
        )
        _ = await manager.saveUser(testUser)
        
        // When
        await manager.deleteUser()
        let loadResult = await manager.loadUser()
        
        // Then
        switch loadResult {
        case .success:
            XCTFail("User should be deleted and load should fail")
        case .failure:
            // Expected - user should be deleted
            break
        }
    }
    
    func testSaveUserWithEmptyName() async {
        // Given
        let testUser = User(
            name: "",
            email: "test@example.com",
            phoneNumber: "123-456-7890",
            location: "Test Location"
        )
        
        // When
        let result = await manager.saveUser(testUser)
        
        // Then
        switch result {
        case .success:
            // Should still succeed - empty name is valid
            break
        case .failure(let error):
            XCTFail("Save should succeed even with empty name, but got error: \(error)")
        }
    }
    
    func testSaveUserWithSpecialCharacters() async {
        // Given
        let testUser = User(
            name: "Test User O'Brien",
            email: "test+user@example.com",
            phoneNumber: "(555) 123-4567",
            location: "New York, NY"
        )
        
        // When
        let saveResult = await manager.saveUser(testUser)
        let loadResult = await manager.loadUser()
        
        // Then
        switch saveResult {
        case .success:
            break
        case .failure(let error):
            XCTFail("Save should succeed, but got error: \(error)")
        }
        
        switch loadResult {
        case .success(let loadedUser):
            XCTAssertEqual(loadedUser.name, testUser.name, "Special characters should be preserved")
            XCTAssertEqual(loadedUser.email, testUser.email, "Email with special characters should be preserved")
        case .failure(let error):
            XCTFail("Load should succeed, but got error: \(error)")
        }
    }
    
    func testLoadUserAfterDelete() async {
        // Given
        let testUser = User(
            name: "Delete Test 2",
            email: "delete2@example.com",
            phoneNumber: "555-8888",
            location: "Test City"
        )
        _ = await manager.saveUser(testUser)
        await manager.deleteUser()
        
        // When
        let result = await manager.loadUser()
        
        // Then
        switch result {
        case .success:
            XCTFail("Should fail to load deleted user")
        case .failure:
            // Expected
            break
        }
    }
}

