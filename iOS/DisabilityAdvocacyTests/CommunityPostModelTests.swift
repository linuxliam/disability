//
//  CommunityPostModelTests.swift
//  DisabilityAdvocacyTests
//
//  Unit tests for CommunityPost model
//

import XCTest
@testable import DisabilityAdvocacy

final class CommunityPostModelTests: XCTestCase {
    
    // MARK: - Initialization Tests
    
    func testInitialization_WithAllParameters() {
        // Given
        let id = UUID()
        let author = "Test Author"
        let title = "Test Post"
        let content = "Test Content"
        let datePosted = Date()
        let category = PostCategory.discussion
        let replies = [Reply(author: "Reply Author", content: "Reply Content")]
        let likes = 5
        
        // When
        let post = CommunityPost(
            id: id,
            author: author,
            title: title,
            content: content,
            datePosted: datePosted,
            category: category,
            replies: replies,
            likes: likes
        )
        
        // Then
        XCTAssertEqual(post.id, id)
        XCTAssertEqual(post.author, author)
        XCTAssertEqual(post.title, title)
        XCTAssertEqual(post.content, content)
        XCTAssertEqual(post.datePosted, datePosted)
        XCTAssertEqual(post.category, category)
        XCTAssertEqual(post.replies.count, replies.count, "Should have same number of replies")
        // Compare replies manually since Reply doesn't conform to Equatable
        for (index, reply) in replies.enumerated() {
            XCTAssertEqual(post.replies[index].id, reply.id, "Reply \(index) should have same id")
            XCTAssertEqual(post.replies[index].author, reply.author, "Reply \(index) should have same author")
        }
        XCTAssertEqual(post.likes, likes)
    }
    
    func testInitialization_WithDefaultParameters() {
        // Given
        let author = "Test Author"
        let title = "Test Post"
        let content = "Test Content"
        let category = PostCategory.discussion
        
        // When
        let post = CommunityPost(
            author: author,
            title: title,
            content: content,
            category: category
        )
        
        // Then
        XCTAssertNotNil(post.id, "Should generate UUID")
        XCTAssertEqual(post.author, author)
        XCTAssertEqual(post.title, title)
        XCTAssertEqual(post.content, content)
        XCTAssertLessThanOrEqual(abs(post.datePosted.timeIntervalSinceNow), 1.0)
        XCTAssertEqual(post.category, category)
        XCTAssertTrue(post.replies.isEmpty, "Replies should be empty by default")
        XCTAssertEqual(post.likes, 0, "Likes should be 0 by default")
    }
    
    // MARK: - Codable Tests
    
    func testEncodingAndDecoding() throws {
        // Given
        let post = CommunityPost(
            author: "Test Author",
            title: "Test Post",
            content: "Test Content",
            category: .discussion,
            replies: [Reply(author: "Reply Author", content: "Reply Content")],
            likes: 5
        )
        
        // When
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(post)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let decoded = try decoder.decode(CommunityPost.self, from: data)
        
        // Then
        XCTAssertEqual(decoded.id, post.id)
        XCTAssertEqual(decoded.author, post.author)
        XCTAssertEqual(decoded.title, post.title)
        XCTAssertEqual(decoded.content, post.content)
        XCTAssertLessThanOrEqual(abs(decoded.datePosted.timeIntervalSince(post.datePosted)), 1.0)
        XCTAssertEqual(decoded.category, post.category)
        XCTAssertEqual(decoded.replies.count, post.replies.count)
        XCTAssertEqual(decoded.likes, post.likes)
    }
    
    // MARK: - PostCategory Tests
    
    func testPostCategory_AllCases() {
        // Then
        let allCases = PostCategory.allCases
        XCTAssertFalse(allCases.isEmpty, "Should have categories")
        XCTAssertTrue(allCases.contains(.discussion), "Should contain discussion category")
        XCTAssertTrue(allCases.contains(.support), "Should contain support category")
        XCTAssertTrue(allCases.contains(.resources), "Should contain resources category")
    }
    
    func testPostCategory_RawValues() {
        // Then
        XCTAssertEqual(PostCategory.discussion.rawValue, "Discussion")
        XCTAssertEqual(PostCategory.support.rawValue, "Support")
        XCTAssertEqual(PostCategory.resources.rawValue, "Resources")
        XCTAssertEqual(PostCategory.events.rawValue, "Events")
        XCTAssertEqual(PostCategory.advocacy.rawValue, "Advocacy")
        XCTAssertEqual(PostCategory.general.rawValue, "General")
    }
    
    func testPostCategory_Icons() {
        // Then
        XCTAssertFalse(PostCategory.discussion.icon.isEmpty, "Should have icon")
        XCTAssertFalse(PostCategory.support.icon.isEmpty, "Should have icon")
        // All categories should have icons
        for category in PostCategory.allCases {
            XCTAssertFalse(category.icon.isEmpty, "Category \(category.rawValue) should have icon")
        }
    }
    
    func testPostCategory_Codable() throws {
        // Given
        let category = PostCategory.discussion
        
        // When
        let encoder = JSONEncoder()
        let data = try encoder.encode(category)
        
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(PostCategory.self, from: data)
        
        // Then
        XCTAssertEqual(decoded, category)
    }
    
    // MARK: - Reply Tests
    
    func testReply_Initialization() {
        // Given
        let id = UUID()
        let author = "Reply Author"
        let content = "Reply Content"
        let datePosted = Date()
        
        // When
        let reply = Reply(id: id, author: author, content: content, datePosted: datePosted)
        
        // Then
        XCTAssertEqual(reply.id, id)
        XCTAssertEqual(reply.author, author)
        XCTAssertEqual(reply.content, content)
        XCTAssertEqual(reply.datePosted, datePosted)
    }
    
    func testReply_DefaultParameters() {
        // Given
        let author = "Reply Author"
        let content = "Reply Content"
        
        // When
        let reply = Reply(author: author, content: content)
        
        // Then
        XCTAssertNotNil(reply.id, "Should generate UUID")
        XCTAssertEqual(reply.author, author)
        XCTAssertEqual(reply.content, content)
        XCTAssertLessThanOrEqual(abs(reply.datePosted.timeIntervalSinceNow), 1.0)
    }
    
    func testReply_Codable() throws {
        // Given
        let reply = Reply(author: "Test Author", content: "Test Content")
        
        // When
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(reply)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let decoded = try decoder.decode(Reply.self, from: data)
        
        // Then
        XCTAssertEqual(decoded.id, reply.id)
        XCTAssertEqual(decoded.author, reply.author)
        XCTAssertEqual(decoded.content, reply.content)
        XCTAssertLessThanOrEqual(abs(decoded.datePosted.timeIntervalSince(reply.datePosted)), 1.0)
    }
    
    // MARK: - Identifiable Tests
    
    func testIdentifiable_HasId() {
        // Given
        let post = CommunityPost(author: "Test", title: "Title", content: "Content", category: .discussion)
        
        // Then
        XCTAssertNotNil(post.id, "Should have id for Identifiable")
    }
}

