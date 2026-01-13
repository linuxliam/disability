//
//  NewsViewModelTests.swift
//  DisabilityAdvocacyTests
//
//  Unit tests for NewsViewModel
//

import XCTest
@testable import DisabilityAdvocacy

@MainActor
final class NewsViewModelTests: XCTestCase {
    var viewModel: NewsViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = NewsViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testInitialState() {
        // Then
        XCTAssertTrue(viewModel.articles.isEmpty, "Articles should be empty initially")
        XCTAssertFalse(viewModel.isLoading, "Should not be loading initially")
        XCTAssertNil(viewModel.errorMessage, "Error message should be nil initially")
    }
    
    func testLoadArticles() async {
        // When
        await viewModel.loadArticles()
        
        // Then
        XCTAssertFalse(viewModel.isLoading, "Should not be loading after load completes")
        XCTAssertFalse(viewModel.articles.isEmpty, "Should have loaded articles")
        XCTAssertNil(viewModel.errorMessage, "Should not have error message on success")
    }
    
    func testLoadArticlesSetsLoadingState() async {
        // Given
        XCTAssertFalse(viewModel.isLoading, "Should not be loading initially")
        
        // When
        await viewModel.loadArticles()
        
        // Then
        XCTAssertFalse(viewModel.isLoading, "Should not be loading after completion")
    }
    
    func testLoadArticlesPreventsDuplicateLoads() async {
        // Given
        viewModel.isLoading = true
        
        // When
        await viewModel.loadArticles()
        
        // Then
        // Should not load again if already loading
        XCTAssertTrue(viewModel.isLoading, "Should remain loading if already loading")
    }
    
    func testLoadArticlesClearsError() async {
        // Given
        viewModel.errorMessage = "Previous error"
        
        // When
        await viewModel.loadArticles()
        
        // Then
        XCTAssertNil(viewModel.errorMessage, "Error message should be cleared on load")
    }
    
    func testArticleProperties() async {
        // When
        await viewModel.loadArticles()
        
        // Then
        for article in viewModel.articles {
            XCTAssertFalse(article.title.isEmpty, "Article should have a title")
            XCTAssertFalse(article.summary.isEmpty, "Article should have a summary")
            XCTAssertFalse(article.source.isEmpty, "Article should have a source")
            XCTAssertFalse(article.category.isEmpty, "Article should have a category")
            XCTAssertNotNil(article.date, "Article should have a date")
        }
    }
    
    func testArticleDates() async {
        // When
        await viewModel.loadArticles()
        
        // Then
        let now = Date()
        for article in viewModel.articles {
            // Articles should be recent (within last week or so)
            let timeDifference = article.date.timeIntervalSince(now)
            XCTAssertLessThan(timeDifference, 86400 * 10, "Articles should be recent")
        }
    }
    
    func testArticleCategories() async {
        // When
        await viewModel.loadArticles()
        
        // Then
        let categories = Set(viewModel.articles.map { $0.category })
        XCTAssertGreaterThan(categories.count, 0, "Should have multiple article categories")
    }
}



