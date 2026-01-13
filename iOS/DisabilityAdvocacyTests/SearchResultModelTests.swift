//
//  SearchResultModelTests.swift
//  DisabilityAdvocacyTests
//
//  Unit tests for SearchResult model
//

import XCTest
@testable import DisabilityAdvocacy_iOS

final class SearchResultModelTests: XCTestCase {
    
    // MARK: - Initialization Tests
    
    func testInitialization_WithAllParameters() {
        // Given
        let id = UUID()
        let type = SearchResultType.resource
        let title = "Test Result"
        let subtitle = "Test Subtitle"
        let summary = "Test Summary"
        let category = "Test Category"
        let date = Date()
        let resourceId = UUID()
        let eventId = UUID()
        let postId = UUID()
        let articleId = UUID()
        
        // When
        let result = SearchResult(
            id: id,
            type: type,
            title: title,
            subtitle: subtitle,
            summary: summary,
            category: category,
            date: date,
            resourceId: resourceId,
            eventId: eventId,
            postId: postId,
            articleId: articleId
        )
        
        // Then
        XCTAssertEqual(result.id, id)
        XCTAssertEqual(result.type, type)
        XCTAssertEqual(result.title, title)
        XCTAssertEqual(result.subtitle, subtitle)
        XCTAssertEqual(result.summary, summary)
        XCTAssertEqual(result.category, category)
        XCTAssertEqual(result.date, date)
        XCTAssertEqual(result.resourceId, resourceId)
        XCTAssertEqual(result.eventId, eventId)
        XCTAssertEqual(result.postId, postId)
        XCTAssertEqual(result.articleId, articleId)
    }
    
    func testInitialization_WithDefaultParameters() {
        // Given
        let type = SearchResultType.resource
        let title = "Test Result"
        let subtitle = "Test Subtitle"
        let summary = "Test Summary"
        let category = "Test Category"
        
        // When
        let result = SearchResult(
            type: type,
            title: title,
            subtitle: subtitle,
            summary: summary,
            category: category
        )
        
        // Then
        XCTAssertNotNil(result.id, "Should generate UUID")
        XCTAssertEqual(result.type, type)
        XCTAssertEqual(result.title, title)
        XCTAssertEqual(result.subtitle, subtitle)
        XCTAssertEqual(result.summary, summary)
        XCTAssertEqual(result.category, category)
        XCTAssertNil(result.date, "Date should be nil by default")
        XCTAssertNil(result.resourceId, "resourceId should be nil by default")
        XCTAssertNil(result.eventId, "eventId should be nil by default")
        XCTAssertNil(result.postId, "postId should be nil by default")
        XCTAssertNil(result.articleId, "articleId should be nil by default")
    }
    
    // MARK: - SearchResultType Tests
    
    func testSearchResultType_AllCases() {
        // Given
        let allCases: [SearchResultType] = [.resource, .event, .post, .article]
        
        // Then
        XCTAssertEqual(allCases.count, 4, "Should have 4 result types")
    }
    
    // MARK: - Icon Tests
    
    func testIcon_Resource() {
        // Given
        let result = SearchResult(type: .resource, title: "Test", subtitle: "Sub", summary: "Summary", category: "Cat")
        
        // Then
        XCTAssertEqual(result.icon, "book.fill", "Resource should have book icon")
    }
    
    func testIcon_Event() {
        // Given
        let result = SearchResult(type: .event, title: "Test", subtitle: "Sub", summary: "Summary", category: "Cat")
        
        // Then
        XCTAssertEqual(result.icon, "calendar", "Event should have calendar icon")
    }
    
    func testIcon_Post() {
        // Given
        let result = SearchResult(type: .post, title: "Test", subtitle: "Sub", summary: "Summary", category: "Cat")
        
        // Then
        XCTAssertEqual(result.icon, "bubble.left.and.bubble.right.fill", "Post should have bubble icon")
    }
    
    func testIcon_Article() {
        // Given
        let result = SearchResult(type: .article, title: "Test", subtitle: "Sub", summary: "Summary", category: "Cat")
        
        // Then
        XCTAssertEqual(result.icon, "newspaper.fill", "Article should have newspaper icon")
    }
    
    // MARK: - TypeLabel Tests
    
    func testTypeLabel_Resource() {
        // Given
        let result = SearchResult(type: .resource, title: "Test", subtitle: "Sub", summary: "Summary", category: "Cat")
        
        // Then
        XCTAssertFalse(result.typeLabel.isEmpty, "Should have type label")
    }
    
    func testTypeLabel_Event() {
        // Given
        let result = SearchResult(type: .event, title: "Test", subtitle: "Sub", summary: "Summary", category: "Cat")
        
        // Then
        XCTAssertFalse(result.typeLabel.isEmpty, "Should have type label")
    }
    
    // MARK: - Identifiable Tests
    
    func testIdentifiable_HasId() {
        // Given
        let result = SearchResult(type: .resource, title: "Test", subtitle: "Sub", summary: "Summary", category: "Cat")
        
        // Then
        XCTAssertNotNil(result.id, "Should have id for Identifiable")
    }
}

