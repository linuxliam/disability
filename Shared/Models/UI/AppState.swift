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
}
