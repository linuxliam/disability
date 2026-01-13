//
//  PlatformTestHelpers.swift
//  DisabilityAdvocacyTests
//
//  Platform-aware test helpers for cross-platform testing
//

import XCTest
import Foundation

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

/// Platform detection utilities for tests
enum PlatformTestHelpers {
    /// Check if running on iOS
    static var isIOS: Bool {
        #if os(iOS)
        return true
        #else
        return false
        #endif
    }
    
    /// Check if running on macOS
    static var isMacOS: Bool {
        #if os(macOS)
        return true
        #else
        return false
        #endif
    }
    
    /// Get current platform name
    static var platformName: String {
        #if os(iOS)
        return "iOS"
        #elseif os(macOS)
        return "macOS"
        #else
        return "Unknown"
        #endif
    }
    
    /// Skip test if not on specified platform
    static func skipIfNotPlatform(_ platform: String, testCase: XCTestCase) {
        let shouldSkip: Bool
        switch platform.lowercased() {
        case "ios":
            shouldSkip = !isIOS
        case "macos":
            shouldSkip = !isMacOS
        default:
            shouldSkip = false
        }
        
        if shouldSkip {
            XCTSkip("Test skipped - not running on \(platform)")
        }
    }
}

/// Test data factories that work on both platforms
struct TestDataFactory {
    /// Create a test resource
    static func makeResource(
        id: UUID = UUID(),
        title: String = "Test Resource",
        description: String = "Test Description",
        category: ResourceCategory = .legal
    ) -> Resource {
        Resource(
            id: id,
            title: title,
            description: description,
            category: category,
            url: "https://example.com",
            tags: ["test"],
            dateAdded: Date()
        )
    }
    
    /// Create a test event
    static func makeEvent(
        id: UUID = UUID(),
        title: String = "Test Event",
        description: String = "Test Description",
        category: EventCategory = .workshop
    ) -> Event {
        Event(
            id: id,
            title: title,
            description: description,
            date: Date(),
            location: "Test Location",
            category: category,
            accessibilityNotes: nil
        )
    }
    
    /// Create a test community post
    static func makeCommunityPost(
        id: UUID = UUID(),
        title: String = "Test Post",
        content: String = "Test Content",
        category: PostCategory = .discussion
    ) -> CommunityPost {
        CommunityPost(
            id: id,
            author: "Test User",
            title: title,
            content: content,
            category: category,
            datePosted: Date(),
            replies: [],
            likes: 0
        )
    }
}

/// Conditional test execution helpers
extension XCTestCase {
    /// Run test only on iOS
    func runOnIOS(_ block: () throws -> Void) rethrows {
        #if os(iOS)
        try block()
        #else
        throw XCTSkip("Test only runs on iOS")
        #endif
    }
    
    /// Run test only on macOS
    func runOnMacOS(_ block: () throws -> Void) rethrows {
        #if os(macOS)
        try block()
        #else
        throw XCTSkip("Test only runs on macOS")
        #endif
    }
    
    /// Run test on both platforms
    func runOnAllPlatforms(_ block: () throws -> Void) rethrows {
        try block()
    }
}
