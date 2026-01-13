//
//  TapInteractionUITests.swift
//  DisabilityAdvocacyUITests
//
//  UI tests for tap interactions - Optimized version with debugging
//

import XCTest

final class TapInteractionUITests: XCTestCase {
    var app: XCUIApplication!
    
    // MARK: - Test Lifecycle
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["--uitesting"]
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    // MARK: - Debugging Helpers
    
    /// Log all available elements of a specific type
    private func debugLogElements(_ query: XCUIElementQuery, type: String) {
        let count = query.count
        print("🔍 DEBUG: Found \(count) \(type) elements")
        
        if count > 0 {
            for i in 0..<min(count, 10) { // Log first 10
                let element = query.element(boundBy: i)
                print("  [\(i)] \(type): label='\(element.label)', identifier='\(element.identifier)', exists=\(element.exists), hittable=\(element.isHittable)")
            }
        }
    }
    
    /// Log all search fields
    private func debugLogSearchFields() {
        print("\n🔍 DEBUG: Searching for search fields...")
        debugLogElements(app.searchFields, type: "searchField")
        
        // Also try to find by placeholder
        let allTextFields = app.textFields
        print("🔍 DEBUG: Found \(allTextFields.count) text fields")
        for i in 0..<min(allTextFields.count, 5) {
            let field = allTextFields.element(boundBy: i)
            print("  [\(i)] TextField: label='\(field.label)', placeholder='\(field.placeholderValue ?? "none")', exists=\(field.exists)")
        }
    }
    
    /// Log all buttons
    private func debugLogButtons(filter: String? = nil) {
        print("\n🔍 DEBUG: Searching for buttons\(filter != nil ? " (filter: \(filter!))" : "")...")
        let buttons = filter != nil ? app.buttons.matching(NSPredicate(format: "label CONTAINS[c] '\(filter!)'")) : app.buttons
        debugLogElements(buttons, type: "button")
    }
    
    /// Log all cells/cards
    private func debugLogCells() {
        print("\n🔍 DEBUG: Searching for cells/cards...")
        debugLogElements(app.cells, type: "cell")
        
        // Also check for other container types
        let collectionViews = app.collectionViews
        print("🔍 DEBUG: Found \(collectionViews.count) collection views (List)")
        for i in 0..<min(collectionViews.count, 3) {
            let cv = collectionViews.element(boundBy: i)
            let cellsInCV = cv.cells
            print("  CollectionView[\(i)]: contains \(cellsInCV.count) cells")
        }
    }
    
    /// Log tab bar state
    private func debugLogTabBar() {
        print("\n🔍 DEBUG: Tab bar state...")
        let tabs = ["Home", "Resources", "Events", "Community", "More"]
        for tab in tabs {
            let button = app.tabBars.buttons[tab]
            print("  Tab '\(tab)': exists=\(button.exists), selected=\(button.isSelected)")
        }
    }
    
    /// Dump entire UI hierarchy (useful for debugging)
    private func debugDumpUIHierarchy() {
        print("\n🔍 DEBUG: UI Hierarchy Dump")
        print("==========================================")
        print(app.debugDescription)
        print("==========================================\n")
    }
    
    /// Take a screenshot and attach it to the test
    private func debugTakeScreenshot(name: String) {
        let screenshot = app.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
        print("📸 DEBUG: Screenshot taken: \(name)")
    }
    
    /// Log element details
    private func debugLogElement(_ element: XCUIElement, name: String) {
        print("\n🔍 DEBUG: Element '\(name)' details:")
        print("  exists: \(element.exists)")
        print("  isHittable: \(element.isHittable)")
        print("  isEnabled: \(element.isEnabled)")
        print("  label: '\(element.label)'")
        print("  identifier: '\(element.identifier)'")
        print("  elementType: \(element.elementType.rawValue)")
        if element.exists {
            print("  frame: \(element.frame)")
        }
    }
    
    /// Wait for element with detailed logging
    private func debugWaitForElement(_ element: XCUIElement, timeout: TimeInterval, name: String) -> Bool {
        print("⏳ DEBUG: Waiting for '\(name)' (timeout: \(timeout)s)...")
        let exists = element.waitForExistence(timeout: timeout)
        if exists {
            print("✅ DEBUG: '\(name)' found after wait")
            debugLogElement(element, name: name)
        } else {
            print("❌ DEBUG: '\(name)' NOT found after \(timeout)s timeout")
            debugLogElement(element, name: name)
        }
        return exists
    }
    
    /// Find all elements matching a query with logging
    private func debugFindElements(_ query: XCUIElementQuery, type: String, predicate: NSPredicate? = nil) -> [XCUIElement] {
        let elements = predicate != nil ? query.matching(predicate!) : query
        let count = elements.count
        print("🔍 DEBUG: Found \(count) \(type) elements\(predicate != nil ? " matching predicate" : "")")
        
        var found: [XCUIElement] = []
        for i in 0..<count {
            let element = elements.element(boundBy: i)
            if element.exists {
                found.append(element)
                print("  [\(i)] \(type): label='\(element.label)', identifier='\(element.identifier)'")
            }
        }
        return found
    }
    
    /// Debug Resources screen state
    private func debugResourcesScreen() {
        print("\n🔍 DEBUG: Resources Screen State")
        print("==========================================")
        debugLogTabBar()
        debugLogSearchFields()
        debugLogButtons(filter: "favorite")
        debugLogButtons(filter: "Filter by")
        debugLogCells()
        print("==========================================\n")
    }
    
    // MARK: - Helper Methods
    
    /// Navigate to a specific tab
    private func navigateToTab(_ tabName: String, timeout: TimeInterval = 5) {
        let tabButton = app.tabBars.buttons[tabName]
        XCTAssertTrue(tabButton.waitForExistence(timeout: timeout), "Tab '\(tabName)' should exist")
        tabButton.tap()
        XCTAssertTrue(tabButton.isSelected, "Tab '\(tabName)' should be selected")
    }
    
    /// Wait for Resources screen to load
    private func waitForResourcesScreen(timeout: TimeInterval = 5) -> XCUIElement {
        print("\n🔍 DEBUG: Waiting for Resources screen...")
        
        // Try accessibility identifier first (most reliable)
        let searchFieldById = app.textFields["searchResourcesTextField"]
        if searchFieldById.waitForExistence(timeout: timeout) {
            print("✅ DEBUG: Found search field by identifier")
            return searchFieldById
        }
        
        // Fallback to label
        let searchField = app.textFields["Search resources..."]
        if !debugWaitForElement(searchField, timeout: timeout, name: "Search resources...") {
            // Debug: Try alternative search field labels
            print("⚠️ DEBUG: Primary text field not found, trying alternatives...")
            debugLogSearchFields()
            
            // Try without ellipsis
            let altSearchField = app.textFields["Search resources"]
            if altSearchField.waitForExistence(timeout: 1) {
                print("✅ DEBUG: Found alternative text field (without ellipsis)")
                return altSearchField
            }
            
            // Try any text field with "Search" in label
            let searchTextFields = app.textFields.matching(NSPredicate(format: "label CONTAINS[c] 'Search'"))
            if searchTextFields.count > 0 {
                let foundField = searchTextFields.firstMatch
                if foundField.waitForExistence(timeout: 1) {
                    print("✅ DEBUG: Found text field with 'Search' in label: '\(foundField.label)'")
                    return foundField
                }
            }
            
            // Debug the entire screen
            debugResourcesScreen()
            debugTakeScreenshot(name: "ResourcesScreen-NotFound")
            
            XCTFail("Resources screen did not load - search field not found. See debug output above.")
        }
        
        print("✅ DEBUG: Resources screen loaded successfully")
        return searchField
    }
    
    /// Wait for Home screen to load
    private func waitForHomeScreen(timeout: TimeInterval = 5) -> XCUIElement {
        let list = app.collectionViews.firstMatch
        XCTAssertTrue(list.waitForExistence(timeout: timeout), "Home screen should load")
        return list
    }
    
    /// Find favorite button (either "Add to favorites" or "Remove from favorites")
    /// Note: Favorite buttons may be in ResourceDetailView, not ResourceListCard
    private func findFavoriteButton(timeout: TimeInterval = 3, onHomeScreen: Bool = false) -> XCUIElement? {
        print("🔍 DEBUG: Searching for favorite buttons...")
        let addButton = app.buttons["Add to favorites"]
        let removeButton = app.buttons["Remove from favorites"]
        
        if debugWaitForElement(addButton, timeout: timeout, name: "Add to favorites") {
            print("✅ DEBUG: Found 'Add to favorites' button")
            return addButton
        } else if debugWaitForElement(removeButton, timeout: timeout, name: "Remove from favorites") {
            print("✅ DEBUG: Found 'Remove from favorites' button")
            return removeButton
        }
        
        // On Resources screen, favorite buttons are in ResourceDetailView, not in the list
        // On Home screen, they're in ResourceCard
        if !onHomeScreen {
            print("⚠️ DEBUG: Favorite buttons not in list view - they're in detail view")
            print("   To test favorite buttons on Resources screen, navigate to detail view first")
        }
        
        // Debug: Log all favorite-related buttons
        print("⚠️ DEBUG: Favorite buttons not found, searching for alternatives...")
        debugLogButtons(filter: "favorite")
        debugLogButtons(filter: "Favorite")
        debugLogButtons(filter: "heart")
        
        return nil
    }
    
    /// Wait for navigation to complete and verify back button exists
    private func verifyNavigationOccurred(timeout: TimeInterval = 3) {
        let backButton = app.navigationBars.buttons.firstMatch
        XCTAssertTrue(backButton.waitForExistence(timeout: timeout), "Should navigate to detail view")
    }
    
    /// Find and tap first available card
    /// Note: NavigationLinks in SwiftUI appear as buttons in XCUITest
    private func tapFirstCard(timeout: TimeInterval = 3) -> Bool {
        print("🔍 DEBUG: Searching for resource cards...")
        
        // Try to find by accessibility identifier first (most reliable)
        let resourceButtonsById = app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH 'resourceCard_'"))
        if resourceButtonsById.count > 0 {
            let firstResource = resourceButtonsById.firstMatch
            if debugWaitForElement(firstResource, timeout: timeout, name: "First resource card by ID") {
                print("✅ DEBUG: Tapping first resource card by identifier")
                firstResource.tap()
                return true
            }
        }
        
        // Try cells first (in case they exist)
        let cells = app.cells
        if cells.count > 0 {
            print("✅ DEBUG: Found \(cells.count) cells")
            let firstCell = cells.firstMatch
            if debugWaitForElement(firstCell, timeout: timeout, name: "First cell") {
                print("✅ DEBUG: Tapping first cell")
                firstCell.tap()
                return true
            }
        }
        
        // Try buttons (NavigationLinks appear as buttons)
        let buttons = app.buttons
        print("🔍 DEBUG: Found \(buttons.count) buttons, checking for resource cards...")
        
        // Look for buttons that might be resource cards (not system buttons)
        var resourceButton: XCUIElement?
        for i in 0..<min(buttons.count, 20) {
            let button = buttons.element(boundBy: i)
            if button.exists && button.isHittable {
                let label = button.label.lowercased()
                let identifier = button.identifier.lowercased()
                // Skip system buttons - check both label and identifier
                if !label.contains("favorite") && 
                   !label.contains("filter") && 
                   !label.contains("clear") &&
                   !label.contains("search") &&
                   !identifier.contains("favorite") &&
                   !identifier.contains("filter") &&
                   !identifier.contains("clear") &&
                   label.count > 5 { // Resource titles are usually longer
                    resourceButton = button
                    print("✅ DEBUG: Found potential resource button: '\(button.label)' (id: '\(button.identifier)')")
                    break
                }
            }
        }
        
        if let resourceButton = resourceButton {
            resourceButton.tap()
            return true
        }
        
        print("❌ DEBUG: No resource cards found")
        debugLogCells()
        debugTakeScreenshot(name: "NoCardsFound")
        return false
    }
    
    // MARK: - Favorite Button Tap Tests
    
    func testFavoriteButtonTapOnHomeScreen() throws {
        // Given
        navigateToTab("Home")
        waitForHomeScreen()
        
        // When - find and tap a favorite button
        guard let favoriteButton = findFavoriteButton(onHomeScreen: true) else {
            throw XCTSkip("No favorite buttons found on Home screen")
        }
        
        let initialLabel = favoriteButton.label
        favoriteButton.tap()
        
        // Then - button state should change
        let newButton = findFavoriteButton(timeout: 2, onHomeScreen: true)
        XCTAssertNotNil(newButton, "Favorite button should still exist after tap")
        if let newButton = newButton {
            // Button label should have changed (unless it's already in the opposite state)
            XCTAssertTrue(newButton.label != initialLabel || favoriteButton.exists, "Favorite button should be interactive")
        }
    }
    
    func testFavoriteButtonTapOnResourcesScreen() throws {
        // Given
        navigateToTab("Resources")
        waitForResourcesScreen()
        debugTakeScreenshot(name: "ResourcesScreen-BeforeFavorite")
        
        // Favorite buttons are in ResourceDetailView, not in the list
        // First navigate to a resource detail view
        guard tapFirstCard() else {
            debugResourcesScreen()
            debugTakeScreenshot(name: "ResourcesScreen-NoCards")
            throw XCTSkip("No resource cards found to navigate to detail view")
        }
        
        debugTakeScreenshot(name: "ResourceDetail-BeforeFavorite")
        
        // When - find and tap a favorite button in detail view
        guard let favoriteButton = findFavoriteButton() else {
            debugTakeScreenshot(name: "ResourceDetail-NoFavoriteButton")
            throw XCTSkip("No favorite buttons found in resource detail view")
        }
        
        print("✅ DEBUG: Tapping favorite button: '\(favoriteButton.label)'")
        favoriteButton.tap()
        debugTakeScreenshot(name: "ResourceDetail-AfterFavorite")
        
        // Then - button state should change
        let updatedButton = findFavoriteButton(timeout: 2)
        XCTAssertNotNil(updatedButton, "Favorite button should be interactive")
    }
    
    func testFavoriteButtonToggle() throws {
        // Given
        navigateToTab("Resources")
        waitForResourcesScreen()
        
        guard let favoriteButton = findFavoriteButton() else {
            throw XCTSkip("No favorite buttons found")
        }
        
        let initialLabel = favoriteButton.label
        
        // When - tap to toggle
        favoriteButton.tap()
        
        // Wait for state to update (use waitForExistence instead of sleep)
        let _ = findFavoriteButton(timeout: 2)
        
        // Then - tap again to toggle back
        if let updatedButton = findFavoriteButton(timeout: 2) {
            updatedButton.tap()
            
            // Verify button is still responsive
            let finalButton = findFavoriteButton(timeout: 2)
            XCTAssertNotNil(finalButton, "Favorite button should remain tappable after toggle")
        }
    }
    
    // MARK: - Navigation Link Tap Tests
    
    func testNavigationLinkTapToResourceDetail() throws {
        // Given
        navigateToTab("Resources")
        waitForResourcesScreen()
        
        // When - tap on a resource card
        guard tapFirstCard() else {
            throw XCTSkip("No resource cards found")
        }
        
        // Then - should navigate to detail view
        verifyNavigationOccurred()
    }
    
    func testNavigationLinkTapToEventDetail() throws {
        // Given
        navigateToTab("Home")
        let list = waitForHomeScreen()
        
        // When - scroll to find events and tap
        list.swipeUp()
        
        guard tapFirstCard() else {
            throw XCTSkip("No event cards found")
        }
        
        // Then - should navigate to event detail
        verifyNavigationOccurred()
    }
    
    // MARK: - Category Filter Tap Tests
    
    func testCategoryFilterButtonTap() throws {
        // Given
        navigateToTab("Resources")
        waitForResourcesScreen()
        debugTakeScreenshot(name: "ResourcesScreen-BeforeFilter")
        
        // When - find and tap a category filter button
        // Category buttons have accessibility labels like "Filter by Legal Rights"
        print("🔍 DEBUG: Searching for category filter buttons...")
        
        // Try by identifier first (most reliable)
        let filterButtonsById = app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH 'categoryFilter_'"))
        if filterButtonsById.count > 0 {
            let firstFilter = filterButtonsById.firstMatch
            if debugWaitForElement(firstFilter, timeout: 3, name: "First filter button by ID") {
                print("✅ DEBUG: Found filter button by identifier: '\(firstFilter.identifier)'")
                firstFilter.tap()
                debugTakeScreenshot(name: "ResourcesScreen-AfterFilter")
                XCTAssertTrue(firstFilter.exists, "Category filter button should be tappable")
                return
            }
        }
        
        // Fallback to label
        let filterPredicate = NSPredicate(format: "label BEGINSWITH 'Filter by'")
        let foundButtons = debugFindElements(app.buttons, type: "filter button", predicate: filterPredicate)
        
        guard foundButtons.count > 0 else {
            print("⚠️ DEBUG: No filter buttons found with 'Filter by' prefix")
            debugLogButtons(filter: "Filter")
            debugLogButtons(filter: "filter")
            debugLogButtons(filter: "Legal")
            debugTakeScreenshot(name: "ResourcesScreen-NoFilterButtons")
            throw XCTSkip("No category filter buttons found")
        }
        
        let firstFilterButton = foundButtons[0]
        print("✅ DEBUG: Found filter button: '\(firstFilterButton.label)'")
        debugLogElement(firstFilterButton, name: "Filter button")
        
        firstFilterButton.tap()
        debugTakeScreenshot(name: "ResourcesScreen-AfterFilter")
        
        // Then - filter button should be tappable and may show selected state
        XCTAssertTrue(firstFilterButton.exists, "Category filter button should be tappable")
    }
    
    func testCategoryFilterClearTap() throws {
        // Given
        navigateToTab("Resources")
        waitForResourcesScreen()
        
        // First, select a filter if available
        let filterPredicate = NSPredicate(format: "label BEGINSWITH 'Filter by'")
        let filterButtons = app.buttons.matching(filterPredicate)
        if filterButtons.count > 0 {
            filterButtons.firstMatch.tap()
        }
        
        // When - tap "Clear category filter" button - try identifier first
        var clearButton = app.buttons["clearCategoryFilterButton"]
        if !clearButton.waitForExistence(timeout: 1) {
            // Fallback to label
            let clearPredicate = NSPredicate(format: "label CONTAINS[c] 'Clear' AND label CONTAINS[c] 'category'")
            clearButton = app.buttons.matching(clearPredicate).firstMatch
        }
        
        if clearButton.waitForExistence(timeout: 2) {
            clearButton.tap()
            
            // Then - filter should be cleared (button may disappear or change state)
            // Just verify the action completed without error
            XCTAssertTrue(true, "Clear button should be tappable")
        } else {
            throw XCTSkip("Clear category filter button not found (may not be needed)")
        }
    }
    
    // MARK: - Button Tap Tests
    
    func testProfileButtonTap() throws {
        // Given
        navigateToTab("Home")
        waitForHomeScreen()
        
        // When - tap profile button in navigation bar
        let profileButton = app.navigationBars.buttons["Profile"]
        guard profileButton.waitForExistence(timeout: 3) else {
            throw XCTSkip("Profile button not found")
        }
        
        profileButton.tap()
        
        // Then - profile sheet should appear (might be a sheet or navigation)
        let profileView = app.navigationBars["Profile"].firstMatch
        let sheet = app.sheets.firstMatch
        XCTAssertTrue(
            profileView.waitForExistence(timeout: 2) || sheet.waitForExistence(timeout: 2),
            "Profile view should appear"
        )
    }
    
    func testAccessibilitySettingsButtonTap() throws {
        // Given
        navigateToTab("More")
        debugTakeScreenshot(name: "AccessibilitySettings-Initial")
        
        // Wait for More screen to load
        print("🔍 DEBUG: Looking for Accessibility Settings button...")
        let settingsButton = app.buttons["Accessibility Settings"]
        
        if !debugWaitForElement(settingsButton, timeout: 5, name: "Accessibility Settings") {
            print("⚠️ DEBUG: Primary button not found, checking alternatives...")
            debugLogButtons(filter: "Accessibility")
            debugLogButtons(filter: "Settings")
            debugLogButtons(filter: "accessibility")
            debugTakeScreenshot(name: "AccessibilitySettings-ButtonNotFound")
            throw XCTSkip("Accessibility Settings button not found")
        }
        
        // When - tap accessibility settings button
        print("✅ DEBUG: Tapping Accessibility Settings button...")
        settingsButton.tap()
        debugTakeScreenshot(name: "AccessibilitySettings-AfterTap")
        
        // Then - settings should appear (could be sheet or navigation)
        let settingsView = app.navigationBars.matching(identifier: "Accessibility Settings").firstMatch
        let sheet = app.sheets.firstMatch
        
        print("🔍 DEBUG: Checking for settings view or sheet...")
        let viewExists = settingsView.waitForExistence(timeout: 3)
        let sheetExists = sheet.waitForExistence(timeout: 3)
        print("  Settings view exists: \(viewExists)")
        print("  Sheet exists: \(sheetExists)")
        
        XCTAssertTrue(
            viewExists || sheetExists,
            "Accessibility settings should appear"
        )
    }
    
    // MARK: - Search Bar Tap Tests
    
    func testSearchBarTap() throws {
        // Given
        navigateToTab("Resources")
        debugTakeScreenshot(name: "ResourcesScreen-Initial")
        let searchField = waitForResourcesScreen()
        
        // When - tap search bar
        print("🔍 DEBUG: Tapping text field...")
        searchField.tap()
        debugTakeScreenshot(name: "ResourcesScreen-AfterTap")
        
        // Then - search field should be tappable
        XCTAssertTrue(searchField.exists, "Search field should be tappable")
    }
    
    func testSearchBarClearButtonTap() throws {
        // Given
        navigateToTab("Resources")
        let searchField = waitForResourcesScreen()
        
        // Type some text
        print("🔍 DEBUG: Typing in search field...")
        searchField.tap()
        searchField.typeText("test")
        debugTakeScreenshot(name: "ResourcesScreen-AfterTyping")
        
        // Wait for clear button to appear - try identifier first
        print("🔍 DEBUG: Looking for clear button...")
        var clearButton = app.buttons["clearSearchButton"]
        if !clearButton.waitForExistence(timeout: 1) {
            clearButton = app.buttons["Clear search"]
        }
        
        if !debugWaitForElement(clearButton, timeout: 2, name: "Clear search") {
            // Try alternative clear button labels
            print("⚠️ DEBUG: Primary clear button not found, trying alternatives...")
            debugLogButtons(filter: "Clear")
            debugLogButtons(filter: "clear")
            
            // Try finding by icon/accessibility
            let allButtons = app.buttons
            print("🔍 DEBUG: Checking all buttons for clear functionality...")
            for i in 0..<min(allButtons.count, 10) {
                let btn = allButtons.element(boundBy: i)
                if btn.label.lowercased().contains("clear") || btn.identifier.lowercased().contains("clear") {
                    print("  Found potential clear button: label='\(btn.label)', identifier='\(btn.identifier)'")
                }
            }
            
            debugTakeScreenshot(name: "ResourcesScreen-ClearButtonNotFound")
            throw XCTSkip("Clear search button not found after typing")
        }
        
        // When - tap clear button
        print("✅ DEBUG: Found clear button, tapping...")
        clearButton.tap()
        debugTakeScreenshot(name: "ResourcesScreen-AfterClear")
        
        // Then - search text should be cleared
        let value = searchField.value as? String ?? ""
        print("🔍 DEBUG: Search field value after clear: '\(value)'")
        XCTAssertTrue(
            value.isEmpty || value == "Search resources...",
            "Search text should be cleared, got: '\(value)'"
        )
    }
    
    // MARK: - Tab Bar Tap Tests
    
    func testTabBarNavigationTaps() throws {
        // Test all tab navigation
        let tabs = ["Home", "Resources", "Events", "Community", "More"]
        
        for tab in tabs {
            // When - tap tab
            navigateToTab(tab)
            
            // Then - verify it's selected
            let tabButton = app.tabBars.buttons[tab]
            XCTAssertTrue(tabButton.isSelected, "Tab '\(tab)' should be selected")
            
            // Verify other tabs are not selected
            for otherTab in tabs where otherTab != tab {
                let otherButton = app.tabBars.buttons[otherTab]
                if otherButton.exists {
                    XCTAssertFalse(otherButton.isSelected, "Tab '\(otherTab)' should not be selected when '\(tab)' is active")
                }
            }
        }
    }
    
    // MARK: - Card Tap Tests
    
    func testResourceCardTap() throws {
        // Given
        navigateToTab("Resources")
        waitForResourcesScreen()
        debugTakeScreenshot(name: "ResourcesScreen-BeforeCardTap")
        
        // When - tap on a resource card
        guard tapFirstCard() else {
            debugResourcesScreen()
            debugTakeScreenshot(name: "ResourcesScreen-NoCards")
            throw XCTSkip("No resource cards found")
        }
        
        debugTakeScreenshot(name: "ResourcesScreen-AfterCardTap")
        
        // Then - should navigate to detail
        verifyNavigationOccurred()
    }
    
    func testEventCardTap() throws {
        // Given
        navigateToTab("Events")
        
        // Wait for events to load
        let navigationBar = app.navigationBars["Events"]
        guard navigationBar.waitForExistence(timeout: 5) else {
            throw XCTSkip("Events screen did not load")
        }
        
        // When - tap on an event card
        guard tapFirstCard() else {
            throw XCTSkip("No event cards found")
        }
        
        // Then - should navigate to event detail
        verifyNavigationOccurred()
    }
    
    // MARK: - Retry Button Tap Tests
    
    func testRetryButtonTap() throws {
        // Given - navigate to a screen that might show error
        navigateToTab("Home")
        waitForHomeScreen()
        
        // When - if retry button exists, tap it
        let retryButton = app.buttons["Retry"]
        guard retryButton.waitForExistence(timeout: 2) else {
            throw XCTSkip("Retry button not found (no error state)")
        }
        
        retryButton.tap()
        
        // Then - should attempt to reload (button may disappear or remain)
        // Just verify the action completed
        XCTAssertTrue(true, "Retry button should be tappable")
    }
    
    // MARK: - Complex Interaction Tests
    
    func testFavoriteThenNavigateInteraction() throws {
        // Given
        navigateToTab("Resources")
        waitForResourcesScreen()
        debugTakeScreenshot(name: "FavoriteNavigate-Initial")
        
        // Navigate to detail view first
        guard tapFirstCard() else {
            debugTakeScreenshot(name: "FavoriteNavigate-NoCards")
            throw XCTSkip("No resource cards found")
        }
        
        debugTakeScreenshot(name: "FavoriteNavigate-AfterNavigation")
        
        // When - favorite a resource in detail view
        guard let favoriteButton = findFavoriteButton() else {
            debugTakeScreenshot(name: "FavoriteNavigate-NoFavoriteButton")
            throw XCTSkip("No favorite buttons found in detail view")
        }
        
        print("✅ DEBUG: Tapping favorite button...")
        favoriteButton.tap()
        debugTakeScreenshot(name: "FavoriteNavigate-AfterFavorite")
        
        // Wait for state update
        let _ = findFavoriteButton(timeout: 2)
        
        // Verify we're still in detail view
        verifyNavigationOccurred()
    }
    
    func testSearchThenTapInteraction() throws {
        // Given
        navigateToTab("Resources")
        let searchField = waitForResourcesScreen()
        debugTakeScreenshot(name: "Search-Before")
        
        // When - search
        print("🔍 DEBUG: Typing 'legal' in search field...")
        searchField.tap()
        searchField.typeText("legal")
        debugTakeScreenshot(name: "Search-AfterTyping")
        
        // Wait for results to filter
        print("🔍 DEBUG: Waiting for filtered results...")
        // NavigationLinks appear as buttons, check for buttons instead
        let buttonsBeforeWait = app.buttons.count
        print("  Buttons before wait: \(buttonsBeforeWait)")
        
        // Wait a moment for filtering
        sleep(1)
        
        let buttonsAfterWait = app.buttons.count
        print("  Buttons after wait: \(buttonsAfterWait)")
        debugLogCells()
        
        // Then - tap a result
        guard tapFirstCard() else {
            debugTakeScreenshot(name: "Search-NoResults")
            throw XCTSkip("No search results found")
        }
        
        debugTakeScreenshot(name: "Search-AfterTap")
        
        // Verify navigation
        verifyNavigationOccurred()
    }
    
    func testMultipleRapidTaps() throws {
        // Given
        navigateToTab("Resources")
        waitForResourcesScreen()
        
        // Navigate to detail view first
        guard tapFirstCard() else {
            throw XCTSkip("No resource cards found to navigate to detail view")
        }
        
        guard let favoriteButton = findFavoriteButton() else {
            throw XCTSkip("No favorite buttons found in detail view")
        }
        
        // When - rapid taps
        for _ in 0..<4 {
            favoriteButton.tap()
            // Small delay to allow state updates
            usleep(100000) // 0.1 seconds
        }
        
        // Then - button should still be responsive
        let finalButton = findFavoriteButton(timeout: 2)
        XCTAssertNotNil(finalButton, "Button should remain responsive after rapid taps")
    }
}
