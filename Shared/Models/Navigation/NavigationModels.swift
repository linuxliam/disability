//
//  NavigationModels.swift
//  Disability Advocacy
//
//  Navigation-related enums and types.
//

import SwiftUI

/// App tabs for navigation
enum AppTab: String, CaseIterable, Codable, Identifiable, Hashable {
    case home
    case news
    case resources
    case advocacy
    case community
    case events
    case library
    case connect
    case settings
    case dataManagement
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .home: return String(localized: "Home")
        case .news: return String(localized: "News & Updates")
        case .resources: return String(localized: "Resources")
        case .advocacy: return String(localized: "Advocacy Tools")
        case .community: return String(localized: "Community")
        case .events: return String(localized: "Events")
        case .library: return String(localized: "Library")
        case .connect: return String(localized: "Connect")
        case .settings: return String(localized: "Settings")
        case .dataManagement: return String(localized: "Data Management")
        }
    }
    
    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .news: return "newspaper.fill"
        case .resources: return "book.fill"
        case .advocacy: return "megaphone.fill"
        case .community: return "person.3.fill"
        case .events: return "calendar"
        case .library: return "books.vertical.fill"
        case .connect: return "person.2.fill"
        case .settings: return "gearshape.fill"
        case .dataManagement: return "database.fill"
        }
    }
    
    /// Returns tabs that should appear in iOS TabView
    static var iOSVisibleTabs: [AppTab] {
        [.home, .library, .connect, .settings]
    }
}

/// Specialized navigation destinations for the app
enum AppDestination: Hashable {
    case search
    case profile
    case accessibility
    case letterGenerator
    case rightsKnowledgeBase
}
