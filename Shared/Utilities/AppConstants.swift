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
    
    // MARK: - Skeleton Loading Constants
    enum Skeleton {
        // Widths
        static let titleWidth: CGFloat = 200
        static let subtitleWidth: CGFloat = 150
        static let shortTextWidth: CGFloat = 100
        static let locationWidth: CGFloat = 120
        static let categoryWidth: CGFloat = 80
        static let accessibilityInfoWidth: CGFloat = 140
        
        // Heights
        static let titleHeight: CGFloat = 18
        static let subtitleHeight: CGFloat = 14
        static let largeTitleHeight: CGFloat = 22
        static let iconSize: CGFloat = 14
        static let smallTextHeight: CGFloat = 12
        
        // Icon/Image sizes
        static let avatarSize: CGFloat = 50
        static let dateBadgeWidth: CGFloat = 50
        static let dateBadgeHeight: CGFloat = 60
        static let smallIconSize: CGFloat = 14
        
        // Spacing
        static let rowSpacing: CGFloat = 12
        static let verticalPadding: CGFloat = 8
        static let cornerRadius: CGFloat = 10
        
        // Animation
        static let shimmerDuration: TimeInterval = 1.5
    }
}

