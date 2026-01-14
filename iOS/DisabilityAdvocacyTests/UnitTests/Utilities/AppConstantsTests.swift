//
//  AppConstantsTests.swift
//  DisabilityAdvocacyTests
//
//  Unit tests for AppConstants
//

import XCTest
@testable import DisabilityAdvocacy_iOS

final class AppConstantsTests: XCTestCase {
    
    // MARK: - Timing Constants Tests
    
    func testTiming_DefaultAnimationDuration_IsSet() {
        // Then
        XCTAssertEqual(AppConstants.Timing.defaultAnimationDuration, 0.3, "Default animation duration should be 0.3")
    }
    
    func testTiming_SimulatedLoadDelay_IsSet() {
        // Then
        XCTAssertEqual(AppConstants.Timing.simulatedLoadDelay, 500_000_000, "Simulated load delay should be 0.5 seconds")
    }
    
    func testTiming_DebounceDelay_IsSet() {
        // Then
        XCTAssertEqual(AppConstants.Timing.debounceDelay, 0.3, "Debounce delay should be 0.3")
    }
    
    func testTiming_SearchDebounceDelay_IsSet() {
        // Then
        XCTAssertEqual(AppConstants.Timing.searchDebounceDelay, 0.5, "Search debounce delay should be 0.5")
    }
    
    // MARK: - Layout Constants Tests
    
    func testLayout_CardCornerRadius_IsSet() {
        // Then
        XCTAssertEqual(AppConstants.Layout.cardCornerRadius, 16, "Card corner radius should be 16")
    }
    
    func testLayout_CompactCardCornerRadius_IsSet() {
        // Then
        XCTAssertEqual(AppConstants.Layout.compactCardCornerRadius, 12, "Compact card corner radius should be 12")
    }
    
    func testLayout_DefaultPadding_IsSet() {
        // Then
        XCTAssertEqual(AppConstants.Layout.defaultPadding, 20, "Default padding should be 20")
    }
    
    func testLayout_CompactPadding_IsSet() {
        // Then
        XCTAssertEqual(AppConstants.Layout.compactPadding, 16, "Compact padding should be 16")
    }
    
    func testLayout_GridItemMinimumWidth_IsSet() {
        // Then
        XCTAssertEqual(AppConstants.Layout.gridItemMinimumWidth, 280, "Grid item minimum width should be 280")
    }
    
    func testLayout_EventCardMinimumWidth_IsSet() {
        // Then
        XCTAssertEqual(AppConstants.Layout.eventCardMinimumWidth, 300, "Event card minimum width should be 300")
    }
    
    func testLayout_SidebarWidths_AreSet() {
        // Then
        XCTAssertEqual(AppConstants.Layout.sidebarMinWidth, 200, "Sidebar min width should be 200")
        XCTAssertEqual(AppConstants.Layout.sidebarIdealWidth, 240, "Sidebar ideal width should be 240")
        XCTAssertEqual(AppConstants.Layout.sidebarMaxWidth, 300, "Sidebar max width should be 300")
    }
    
    // MARK: - Data Constants Tests
    
    func testData_PageSize_IsSet() {
        // Then
        XCTAssertEqual(AppConstants.Data.pageSize, 20, "Page size should be 20")
    }
    
    func testData_MaxFeaturedItems_IsSet() {
        // Then
        XCTAssertEqual(AppConstants.Data.maxFeaturedItems, 5, "Max featured items should be 5")
    }
    
    func testData_MaxUpcomingEvents_IsSet() {
        // Then
        XCTAssertEqual(AppConstants.Data.maxUpcomingEvents, 4, "Max upcoming events should be 4")
    }
    
    func testData_MaxResourceTags_IsSet() {
        // Then
        XCTAssertEqual(AppConstants.Data.maxResourceTags, 3, "Max resource tags should be 3")
    }
    
    // MARK: - UserDefaults Keys Tests
    
    func testUserDefaultsKeys_AllKeysAreSet() {
        // Then
        XCTAssertEqual(AppConstants.UserDefaultsKeys.savedResources, "savedResources")
        XCTAssertEqual(AppConstants.UserDefaultsKeys.favoriteResourceIds, "favoriteResourceIds")
        XCTAssertEqual(AppConstants.UserDefaultsKeys.savedUserProfile, "savedUserProfile")
        XCTAssertEqual(AppConstants.UserDefaultsKeys.accessibilitySettings, "accessibilitySettings")
    }
    
    func testUserDefaultsKeys_KeysAreUnique() {
        // Given
        let keys = [
            AppConstants.UserDefaultsKeys.savedResources,
            AppConstants.UserDefaultsKeys.favoriteResourceIds,
            AppConstants.UserDefaultsKeys.savedUserProfile,
            AppConstants.UserDefaultsKeys.accessibilitySettings
        ]
        
        // Then
        let uniqueKeys = Set(keys)
        XCTAssertEqual(keys.count, uniqueKeys.count, "All keys should be unique")
    }
    
    // MARK: - Bundle Resources Tests
    
    func testBundleResources_ResourcesJSON_IsSet() {
        // Then
        XCTAssertEqual(AppConstants.BundleResources.resourcesJSON, "Resources", "Resources JSON should be 'Resources'")
    }
    
    // MARK: - Skeleton Constants Tests
    
    func testSkeleton_Widths_AreSet() {
        // Then
        XCTAssertEqual(AppConstants.Skeleton.titleWidth, 200)
        XCTAssertEqual(AppConstants.Skeleton.subtitleWidth, 150)
        XCTAssertEqual(AppConstants.Skeleton.shortTextWidth, 100)
        XCTAssertEqual(AppConstants.Skeleton.locationWidth, 120)
        XCTAssertEqual(AppConstants.Skeleton.categoryWidth, 80)
        XCTAssertEqual(AppConstants.Skeleton.accessibilityInfoWidth, 140)
    }
    
    func testSkeleton_Heights_AreSet() {
        // Then
        XCTAssertEqual(AppConstants.Skeleton.titleHeight, 18)
        XCTAssertEqual(AppConstants.Skeleton.subtitleHeight, 14)
        XCTAssertEqual(AppConstants.Skeleton.largeTitleHeight, 22)
        XCTAssertEqual(AppConstants.Skeleton.iconSize, 14)
        XCTAssertEqual(AppConstants.Skeleton.smallTextHeight, 12)
    }
    
    func testSkeleton_IconSizes_AreSet() {
        // Then
        XCTAssertEqual(AppConstants.Skeleton.avatarSize, 50)
        XCTAssertEqual(AppConstants.Skeleton.dateBadgeWidth, 50)
        XCTAssertEqual(AppConstants.Skeleton.dateBadgeHeight, 60)
        XCTAssertEqual(AppConstants.Skeleton.smallIconSize, 14)
    }
    
    func testSkeleton_Spacing_IsSet() {
        // Then
        XCTAssertEqual(AppConstants.Skeleton.rowSpacing, 12)
        XCTAssertEqual(AppConstants.Skeleton.verticalPadding, 8)
        XCTAssertEqual(AppConstants.Skeleton.cornerRadius, 10)
    }
    
    func testSkeleton_Animation_IsSet() {
        // Then
        XCTAssertEqual(AppConstants.Skeleton.shimmerDuration, 1.5, "Shimmer duration should be 1.5")
    }
    
    // MARK: - Constants Validation Tests
    
    func testAllConstants_ArePositiveValues() {
        // Timing
        XCTAssertGreaterThan(AppConstants.Timing.defaultAnimationDuration, 0)
        XCTAssertGreaterThan(AppConstants.Timing.simulatedLoadDelay, 0)
        XCTAssertGreaterThan(AppConstants.Timing.debounceDelay, 0)
        XCTAssertGreaterThan(AppConstants.Timing.searchDebounceDelay, 0)
        
        // Layout
        XCTAssertGreaterThan(AppConstants.Layout.cardCornerRadius, 0)
        XCTAssertGreaterThan(AppConstants.Layout.defaultPadding, 0)
        XCTAssertGreaterThan(AppConstants.Layout.gridItemMinimumWidth, 0)
        
        // Data
        XCTAssertGreaterThan(AppConstants.Data.pageSize, 0)
        XCTAssertGreaterThan(AppConstants.Data.maxFeaturedItems, 0)
        
        // Skeleton
        XCTAssertGreaterThan(AppConstants.Skeleton.titleWidth, 0)
        XCTAssertGreaterThan(AppConstants.Skeleton.titleHeight, 0)
        XCTAssertGreaterThan(AppConstants.Skeleton.shimmerDuration, 0)
    }
}
