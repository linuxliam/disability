//
//  SearchHighlightingTests.swift
//  DisabilityAdvocacyTests
//
//  Unit tests for SearchHighlighting
//

import XCTest
@testable import DisabilityAdvocacy_iOS

final class SearchHighlightingTests: XCTestCase {
    
    // MARK: - Basic Highlighting Tests
    
    func testHighlight_EmptyQuery_ReturnsUnhighlightedText() {
        // Given
        let text = "This is a test"
        let query = ""
        
        // When
        let segments = SearchHighlighting.highlight(text, query: query)
        
        // Then
        XCTAssertEqual(segments.count, 1, "Should return one segment")
        XCTAssertEqual(segments.first?.text, text, "Text should match")
        XCTAssertFalse(segments.first?.isHighlighted ?? true, "Should not be highlighted")
    }
    
    func testHighlight_EmptyText_ReturnsUnhighlightedText() {
        // Given
        let text = ""
        let query = "test"
        
        // When
        let segments = SearchHighlighting.highlight(text, query: query)
        
        // Then
        XCTAssertEqual(segments.count, 1, "Should return one segment")
        XCTAssertEqual(segments.first?.text, text, "Text should be empty")
        XCTAssertFalse(segments.first?.isHighlighted ?? true, "Should not be highlighted")
    }
    
    func testHighlight_SingleMatch_HighlightsMatch() {
        // Given
        let text = "This is a test"
        let query = "test"
        
        // When
        let segments = SearchHighlighting.highlight(text, query: query)
        
        // Then
        XCTAssertEqual(segments.count, 2, "Should have two segments")
        XCTAssertEqual(segments[0].text, "This is a ", "First segment should be before match")
        XCTAssertFalse(segments[0].isHighlighted, "First segment should not be highlighted")
        XCTAssertEqual(segments[1].text, "test", "Second segment should be the match")
        XCTAssertTrue(segments[1].isHighlighted, "Second segment should be highlighted")
    }
    
    func testHighlight_MultipleMatches_HighlightsAllMatches() {
        // Given
        let text = "test this test"
        let query = "test"
        
        // When
        let segments = SearchHighlighting.highlight(text, query: query)
        
        // Then
        XCTAssertTrue(segments.count >= 3, "Should have multiple segments")
        let highlightedCount = segments.filter { $0.isHighlighted }.count
        XCTAssertEqual(highlightedCount, 2, "Should highlight both matches")
    }
    
    func testHighlight_CaseInsensitive_HighlightsMatch() {
        // Given
        let text = "This is a Test"
        let query = "test"
        
        // When
        let segments = SearchHighlighting.highlight(text, query: query)
        
        // Then
        let highlightedSegments = segments.filter { $0.isHighlighted }
        XCTAssertEqual(highlightedSegments.count, 1, "Should find one match")
        XCTAssertEqual(highlightedSegments.first?.text, "Test", "Should match case-insensitively")
    }
    
    func testHighlight_NoMatch_ReturnsUnhighlightedText() {
        // Given
        let text = "This is a test"
        let query = "xyz"
        
        // When
        let segments = SearchHighlighting.highlight(text, query: query)
        
        // Then
        XCTAssertEqual(segments.count, 1, "Should return one segment")
        XCTAssertEqual(segments.first?.text, text, "Text should match")
        XCTAssertFalse(segments.first?.isHighlighted ?? true, "Should not be highlighted")
    }
    
    // MARK: - Multiple Query Tests
    
    func testHighlightMultiple_EmptyQueries_ReturnsUnhighlightedText() {
        // Given
        let text = "This is a test"
        let queries: [String] = []
        
        // When
        let segments = SearchHighlighting.highlightMultiple(text, queries: queries)
        
        // Then
        XCTAssertEqual(segments.count, 1, "Should return one segment")
        XCTAssertFalse(segments.first?.isHighlighted ?? true, "Should not be highlighted")
    }
    
    func testHighlightMultiple_SingleQuery_HighlightsMatch() {
        // Given
        let text = "This is a test"
        let queries = ["test"]
        
        // When
        let segments = SearchHighlighting.highlightMultiple(text, queries: queries)
        
        // Then
        let highlightedCount = segments.filter { $0.isHighlighted }.count
        XCTAssertGreaterThan(highlightedCount, 0, "Should highlight matches")
    }
    
    func testHighlightMultiple_MultipleQueries_HighlightsAllMatches() {
        // Given
        let text = "This is a test and another test"
        let queries = ["test", "another"]
        
        // When
        let segments = SearchHighlighting.highlightMultiple(text, queries: queries)
        
        // Then
        let highlightedCount = segments.filter { $0.isHighlighted }.count
        XCTAssertGreaterThan(highlightedCount, 0, "Should highlight matches from all queries")
    }
    
    func testHighlightMultiple_EmptyQueryInList_IgnoresEmptyQuery() {
        // Given
        let text = "This is a test"
        let queries = ["test", "", "another"]
        
        // When
        let segments = SearchHighlighting.highlightMultiple(text, queries: queries)
        
        // Then
        // Should still highlight "test" and ignore empty query
        let highlightedCount = segments.filter { $0.isHighlighted }.count
        XCTAssertGreaterThan(highlightedCount, 0, "Should highlight non-empty query matches")
    }
    
    // MARK: - Edge Cases
    
    func testHighlight_QueryMatchesEntireText_HighlightsAll() {
        // Given
        let text = "test"
        let query = "test"
        
        // When
        let segments = SearchHighlighting.highlight(text, query: query)
        
        // Then
        XCTAssertEqual(segments.count, 1, "Should have one segment")
        XCTAssertTrue(segments.first?.isHighlighted ?? false, "Should be highlighted")
        XCTAssertEqual(segments.first?.text, text, "Text should match")
    }
    
    func testHighlight_QueryAtStart_HighlightsCorrectly() {
        // Given
        let text = "test this"
        let query = "test"
        
        // When
        let segments = SearchHighlighting.highlight(text, query: query)
        
        // Then
        XCTAssertTrue(segments.first?.isHighlighted ?? false, "First segment should be highlighted")
        XCTAssertEqual(segments.first?.text, "test", "First segment should be the match")
    }
    
    func testHighlight_QueryAtEnd_HighlightsCorrectly() {
        // Given
        let text = "this test"
        let query = "test"
        
        // When
        let segments = SearchHighlighting.highlight(text, query: query)
        
        // Then
        let highlightedSegments = segments.filter { $0.isHighlighted }
        XCTAssertEqual(highlightedSegments.count, 1, "Should have one highlighted segment")
        XCTAssertEqual(highlightedSegments.first?.text, "test", "Should highlight the end match")
    }
    
    // MARK: - HighlightedTextSegment Tests
    
    func testHighlightedTextSegment_Properties_AreSet() {
        // Given
        let segment = HighlightedTextSegment(text: "test", isHighlighted: true)
        
        // Then
        XCTAssertEqual(segment.text, "test", "Text should match")
        XCTAssertTrue(segment.isHighlighted, "Should be highlighted")
    }
}
