//
//  AppConstants.swift
//  Disability Advocacy
//
//  Application constants and configuration
//

import Foundation
import SwiftUI

enum AppConstants {
    // MARK: - Timing Constants
    enum Timing {
        static let defaultAnimationDuration: TimeInterval = 0.3
        static let simulatedLoadDelay: UInt64 = 500_000_000 // 0.5 seconds
        static let debounceDelay: TimeInterval = 0.3
        static let searchDebounceDelay: TimeInterval = 0.5
    }
    
    // MARK: - Layout Constants
    enum Layout {
        static let cardCornerRadius: CGFloat = 16
        static let compactCardCornerRadius: CGFloat = 12
        static let defaultPadding: CGFloat = 20
        static let compactPadding: CGFloat = 16
        static let gridItemMinimumWidth: CGFloat = 280
        static let eventCardMinimumWidth: CGFloat = 300
        static let sidebarMinWidth: CGFloat = 200
        static let sidebarIdealWidth: CGFloat = 240
        static let sidebarMaxWidth: CGFloat = 300
    }
    
    // MARK: - Data Constants
    enum Data {
        static let pageSize = 20
        static let maxFeaturedItems = 5
        static let maxUpcomingEvents = 4
        static let maxResourceTags = 3
    }
    
    // MARK: - UserDefaults Keys
    enum UserDefaultsKeys {
        static let savedResources = "savedResources"
        static let favoriteResourceIds = "favoriteResourceIds"
        static let savedUserProfile = "savedUserProfile"
        static let accessibilitySettings = "accessibilitySettings"
    }
    
    // MARK: - Bundle Resources
    enum BundleResources {
        static let resourcesJSON = "Resources"
    }
}

