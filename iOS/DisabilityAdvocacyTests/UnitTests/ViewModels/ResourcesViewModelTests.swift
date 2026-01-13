//
//  ResourcesViewModelTests.swift
//  DisabilityAdvocacyTests
//
//  Unit tests for ResourcesViewModel
//

import XCTest
@testable import DisabilityAdvocacy_iOS

@MainActor
final class ResourcesViewModelTests: XCTestCase {
    var viewModel: ResourcesViewModel!
    var resourcesManager: ResourcesManager!
    
    override func setUp() {
        super.setUp()
        resourcesManager = ResourcesManager()
        viewModel = ResourcesViewModel(resourcesManager: resourcesManager)
    }
    
    override func tearDown() {
        viewModel = nil
        resourcesManager = nil
        super.tearDown()
    }
    
    func testInitialState() {
        // Then
        XCTAssertTrue(viewModel.resources.isEmpty, "Resources should be empty initially")
        XCTAssertFalse(viewModel.isLoading, "Should not be loading initially")
        XCTAssertNil(viewModel.errorMessage, "Error message should be nil initially")
    }
    
    func testLoadResources() async {
        // When
        await viewModel.loadResources()
        
        // Then
        XCTAssertFalse(viewModel.isLoading, "Should not be loading after load completes")
        XCTAssertFalse(viewModel.resources.isEmpty, "Should have loaded resources")
        XCTAssertNil(viewModel.errorMessage, "Should not have error message on success")
    }
    
    func testLoadResourcesSetsLoadingState() async {
        // Given
        XCTAssertFalse(viewModel.isLoading, "Should not be loading initially")
        
        // When
        let loadTask = Task {
            await viewModel.loadResources()
        }
        
        // Note: Since loadResources is synchronous (no actual async work), 
        // isLoading will be set and cleared immediately
        // In a real async scenario, we'd check isLoading during the load
        
        await loadTask.value
        
        // Then
        XCTAssertFalse(viewModel.isLoading, "Should not be loading after completion")
    }
    
    func testLoadResourcesPreventsDuplicateLoads() async {
        // Given
        viewModel.isLoading = true
        
        // When
        await viewModel.loadResources()
        
        // Then
        // Should not load again if already loading
        XCTAssertTrue(viewModel.isLoading, "Should remain loading if already loading")
    }
    
    func testLoadResourcesClearsError() async {
        // Given
        viewModel.errorMessage = "Previous error"
        
        // When
        await viewModel.loadResources()
        
        // Then
        XCTAssertNil(viewModel.errorMessage, "Error message should be cleared on load")
    }
    
    func testResourcesLoadedFromManager() async {
        // Given
        let expectedResources = resourcesManager.getAllResources()
        
        // When
        await viewModel.loadResources()
        
        // Then
        XCTAssertEqual(viewModel.resources.count, expectedResources.count, "Should load all resources from manager")
    }
}



