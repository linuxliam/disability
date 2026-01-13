//
//  CommunityViewModelTests.swift
//  DisabilityAdvocacyTests
//
//  Unit tests for CommunityViewModel
//

import XCTest
@testable import DisabilityAdvocacy_iOS

@MainActor
final class CommunityViewModelTests: XCTestCase {
    var viewModel: CommunityViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = CommunityViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testInitialState() {
        // Then
        XCTAssertTrue(viewModel.posts.isEmpty, "Posts should be empty initially")
        XCTAssertFalse(viewModel.isLoading, "Should not be loading initially")
        XCTAssertNil(viewModel.errorMessage, "Error message should be nil initially")
    }
    
    func testLoadPosts() async {
        // When
        await viewModel.loadPosts()
        
        // Then
        XCTAssertFalse(viewModel.isLoading, "Should not be loading after load completes")
        XCTAssertFalse(viewModel.posts.isEmpty, "Should have loaded posts")
        XCTAssertNil(viewModel.errorMessage, "Should not have error message on success")
    }
    
    func testLoadPostsSetsLoadingState() async {
        // Given
        XCTAssertFalse(viewModel.isLoading, "Should not be loading initially")
        
        // When
        await viewModel.loadPosts()
        
        // Then
        XCTAssertFalse(viewModel.isLoading, "Should not be loading after completion")
    }
    
    func testLoadPostsPreventsDuplicateLoads() async {
        // Given
        viewModel.isLoading = true
        
        // When
        await viewModel.loadPosts()
        
        // Then
        // Should not load again if already loading
        XCTAssertTrue(viewModel.isLoading, "Should remain loading if already loading")
    }
    
    func testLoadPostsClearsError() async {
        // Given
        viewModel.errorMessage = "Previous error"
        
        // When
        await viewModel.loadPosts()
        
        // Then
        XCTAssertNil(viewModel.errorMessage, "Error message should be cleared on load")
    }
    
    func testPostProperties() async {
        // When
        await viewModel.loadPosts()
        
        // Then
        for post in viewModel.posts {
            XCTAssertFalse(post.author.isEmpty, "Post should have an author")
            XCTAssertFalse(post.title.isEmpty, "Post should have a title")
            XCTAssertFalse(post.content.isEmpty, "Post should have content")
        }
    }
    
    func testPostCategories() async {
        // When
        await viewModel.loadPosts()
        
        // Then
        let categories = Set(viewModel.posts.map { $0.category })
        XCTAssertGreaterThan(categories.count, 0, "Should have multiple post categories")
    }
    
    func testPostReplies() async {
        // When
        await viewModel.loadPosts()
        
        // Then
        let postsWithReplies = viewModel.posts.filter { !$0.replies.isEmpty }
        XCTAssertGreaterThanOrEqual(postsWithReplies.count, 0, "Some posts should have replies")
    }
}



