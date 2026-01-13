//
//  TestDataFactories.swift
//  DisabilityAdvocacyTests
//
//  Test data factories for generating test data
//

import Foundation
@testable import DisabilityAdvocacy_iOS

/// Factory for creating test Resource objects
struct ResourceFactory {
    static func create(
        id: UUID = UUID(),
        title: String = "Test Resource",
        description: String = "Test Description",
        category: ResourceCategory = .legal,
        url: String? = "https://example.com",
        tags: [String] = ["test"],
        dateAdded: Date = Date()
    ) -> Resource {
        Resource(
            id: id,
            title: title,
            description: description,
            category: category,
            url: url,
            tags: tags,
            dateAdded: dateAdded
        )
    }
    
    static func createMultiple(count: Int, category: ResourceCategory = .legal) -> [Resource] {
        (0..<count).map { index in
            create(
                title: "Test Resource \(index + 1)",
                category: category,
                tags: ["test", "resource\(index)"]
            )
        }
    }
}

/// Factory for creating test Event objects
struct EventFactory {
    static func create(
        id: UUID = UUID(),
        title: String = "Test Event",
        description: String = "Test Event Description",
        category: EventCategory = .workshop,
        date: Date = Date().addingTimeInterval(86400), // Tomorrow
        location: String = "Test Location",
        isVirtual: Bool = false,
        eventURL: String? = nil
    ) -> Event {
        Event(
            id: id,
            title: title,
            description: description,
            date: date,
            location: location,
            isVirtual: isVirtual,
            eventURL: eventURL,
            category: category
        )
    }
    
    static func createMultiple(count: Int, category: EventCategory = .workshop) -> [Event] {
        (0..<count).map { index in
            let daysFromNow = Double(index + 1)
            return create(
                title: "Test Event \(index + 1)",
                category: category,
                date: Date().addingTimeInterval(86400 * daysFromNow) // Future dates
            )
        }
    }
}

/// Factory for creating test CommunityPost objects
struct CommunityPostFactory {
    static func create(
        id: UUID = UUID(),
        author: String = "Test Author",
        title: String = "Test Post",
        content: String = "Test Content",
        datePosted: Date = Date(),
        category: PostCategory = .discussion,
        replies: [Reply] = [],
        likes: Int = 0
    ) -> CommunityPost {
        CommunityPost(
            id: id,
            author: author,
            title: title,
            content: content,
            datePosted: datePosted,
            category: category,
            replies: replies,
            likes: likes
        )
    }
    
    static func createMultiple(count: Int, category: PostCategory = .discussion) -> [CommunityPost] {
        (0..<count).map { index in
            create(
                title: "Test Post \(index + 1)",
                category: category
            )
        }
    }
}

/// Factory for creating test LetterTemplate objects
struct LetterTemplateFactory {
    static func create(
        id: UUID = UUID(),
        title: String = "Test Template",
        description: String = "Test Template Description",
        category: LetterCategory = .employer,
        templateText: String = "Dear [Name],\n\n[Content]\n\nSincerely,\n[YourName]",
        placeholders: [Placeholder] = [
            Placeholder(key: "Name", label: "Recipient Name", required: true),
            Placeholder(key: "Content", label: "Letter Content", required: true),
            Placeholder(key: "YourName", label: "Your Name", required: true)
        ]
    ) -> LetterTemplate {
        LetterTemplate(
            id: id,
            title: title,
            description: description,
            category: category,
            templateText: templateText,
            placeholders: placeholders
        )
    }
}

/// Factory for creating test SearchResult objects
struct SearchResultFactory {
    static func create(
        id: UUID = UUID(),
        title: String = "Test Result",
        subtitle: String = "Test Subtitle",
        summary: String = "Test Summary",
        category: String = "Test Category",
        type: SearchResultType = .resource,
        date: Date? = nil
    ) -> SearchResult {
        SearchResult(
            id: id,
            type: type,
            title: title,
            subtitle: subtitle,
            summary: summary,
            category: category,
            date: date
        )
    }
    
    static func createMultiple(count: Int, type: SearchResultType = .resource) -> [SearchResult] {
        (0..<count).map { index in
            create(
                title: "Test Result \(index + 1)",
                type: type
            )
        }
    }
}

/// Factory for creating test User objects
struct UserFactory {
    static func create(
        id: UUID = UUID(),
        name: String = "Test User",
        email: String = "test@example.com"
    ) -> User {
        User(
            id: id,
            name: name,
            email: email
        )
    }
}

