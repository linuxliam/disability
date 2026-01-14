import Foundation
import Observation
import SwiftUI

@MainActor
@Observable
class AppState {
    var selectedTab: AppTab = .home
    var favoriteResources: Set<UUID> = AppState.loadFavorites()
    var feedback = FeedbackViewModel()
    var themeManager = ThemeManager()
    
    // Navigation paths
    var homePath = NavigationPath()
    var libraryPath = NavigationPath()
    var connectPath = NavigationPath()
    var settingsPath = NavigationPath()
    var newsPath = NavigationPath()
    var adminPath = NavigationPath()
    
    // Sheet presentation
    var showProfile = false
    var showAccessibilitySettings = false
    var showSearch = false
    var showKeyboardShortcuts = false
    
    // File operations
    private let fileOperationsManager = FileOperationsManager.shared
    
    static private let favoritesKey = "favoriteResourceIds"
    
    static private func loadFavorites() -> Set<UUID> {
        if let data = UserDefaults.standard.array(forKey: favoritesKey) as? [String] {
            return Set(data.compactMap { UUID(uuidString: $0) })
        }
        return []
    }
    
    private func persistFavorites() {
        let ids = favoriteResources.map { $0.uuidString }
        UserDefaults.standard.set(ids, forKey: AppState.favoritesKey)
    }
    
    func isFavorite(_ id: UUID) -> Bool {
        favoriteResources.contains(id)
    }
    
    func toggleFavorite(_ id: UUID) async {
        if favoriteResources.contains(id) {
            favoriteResources.remove(id)
            feedback.info(String(localized: "Removed from favorites"))
        } else {
            favoriteResources.insert(id)
            feedback.success(String(localized: "Added to favorites"))
        }
        persistFavorites()
    }
    
    // MARK: - File Operations
    
    /// Import resources from a JSON file
    func importResources() async {
        guard let importedResources = await fileOperationsManager.importResources() else {
            feedback.error(String(localized: "Failed to import resources. Please check the file format."))
            return
        }
        
        // Add imported resources to ResourcesManager
        for resource in importedResources {
            ResourcesManager.shared.addResource(resource)
        }
        
        feedback.success(String(localized: "Successfully imported \(importedResources.count) resource(s)."))
    }
    
    /// Import events from a JSON file
    func importEvents() async {
        guard let importedEvents = await fileOperationsManager.importEvents() else {
            feedback.error(String(localized: "Failed to import events. Please check the file format."))
            return
        }
        
        // Add imported events to EventsManager
        for event in importedEvents {
            EventsManager.shared.addEvent(event)
        }
        
        feedback.success(String(localized: "Successfully imported \(importedEvents.count) event(s)."))
    }
    
    /// Export resources to a JSON file
    func exportResources() async {
        let allResources = ResourcesManager.shared.getAllResources()
        
        guard !allResources.isEmpty else {
            feedback.warning(String(localized: "No resources to export."))
            return
        }
        
        let success = await fileOperationsManager.exportResources(allResources)
        
        if success {
            feedback.success(String(localized: "Successfully exported \(allResources.count) resource(s)."))
        } else {
            feedback.error(String(localized: "Failed to export resources."))
        }
    }
    
    /// Export events to a JSON file
    func exportEvents() async {
        let allEvents = EventsManager.shared.getAllEvents()
        
        guard !allEvents.isEmpty else {
            feedback.warning(String(localized: "No events to export."))
            return
        }
        
        let success = await fileOperationsManager.exportEvents(allEvents)
        
        if success {
            feedback.success(String(localized: "Successfully exported \(allEvents.count) event(s)."))
        } else {
            feedback.error(String(localized: "Failed to export events."))
        }
    }
}
