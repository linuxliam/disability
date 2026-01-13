//
//  SearchResult.swift
//  Disability Advocacy iOS
//
//  Search result model for unified search
//

import Foundation

enum SearchResultType: String, CaseIterable {
    case resource
    case event
    case post
    case article
    
    var icon: String {
        switch self {
        case .resource: return "book.fill"
        case .event: return "calendar"
        case .post: return "bubble.left.and.bubble.right.fill"
        case .article: return "newspaper.fill"
        }
    }
}

struct SearchResult: Identifiable, Hashable {
    let id: UUID
    let type: SearchResultType
    let title: String
    let subtitle: String
    let summary: String
    let category: String
    let date: Date?
    
    // Associated data (optional, for navigation)
    var resourceId: UUID?
    var eventId: UUID?
    var postId: UUID?
    var articleId: UUID?
    
    init(
        id: UUID = UUID(),
        type: SearchResultType,
        title: String,
        subtitle: String,
        summary: String,
        category: String,
        date: Date? = nil,
        resourceId: UUID? = nil,
        eventId: UUID? = nil,
        postId: UUID? = nil,
        articleId: UUID? = nil
    ) {
        self.id = id
        self.type = type
        self.title = title
        self.subtitle = subtitle
        self.summary = summary
        self.category = category
        self.date = date
        self.resourceId = resourceId
        self.eventId = eventId
        self.postId = postId
        self.articleId = articleId
    }
}

extension SearchResult {
    var icon: String {
        switch type {
        case .resource: return "book.fill"
        case .event: return "calendar"
        case .post: return "bubble.left.and.bubble.right.fill"
        case .article: return "newspaper.fill"
        }
    }
    
    var typeLabel: String {
        switch type {
        case .resource: return String(localized: "Resource")
        case .event: return String(localized: "Event")
        case .post: return String(localized: "Post")
        case .article: return String(localized: "Article")
        }
    }
}



