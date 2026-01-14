//
//  HomeViewModel.swift
//  Disability Advocacy
//
//  Unified Home View Model for Multi-platform app
//

import SwiftUI
import Combine
import Observation

@MainActor
@Observable
class HomeViewModel {
    var isLoading = false
    var errorMessage: String?
    var showError = false
    
    // Data properties
    var totalResources = 0
    var upcomingEvents = 0
    var recentPosts = 0
    var upcomingEventsList: [Event] = []
    var featuredResources: [Resource] = []
    
    // iOS Specific data properties
    var recentlyAddedResources: [Resource] = []
    var recommendedResources: [Resource] = []
    
    private let resourcesManager: ResourcesManager
    private let eventsManager: EventsManager
    private var loadTask: Task<Void, Never>?
    
    nonisolated init(
        resourcesManager: ResourcesManager = MainActor.assumeIsolated { ResourcesManager.shared },
        eventsManager: EventsManager = MainActor.assumeIsolated { EventsManager.shared }
    ) {
        self.resourcesManager = resourcesManager
        self.eventsManager = eventsManager
    }
    
    func loadData(favoriteResourceIds: Set<UUID> = []) {
        loadTask?.cancel()

        isLoading = true
        errorMessage = nil
        showError = false

        loadTask = Task {
            await performLoad(favoriteResourceIds: favoriteResourceIds)
        }
    }
    
    private func performLoad(favoriteResourceIds: Set<UUID>) async {
        defer {
            isLoading = false
        }

        if Task.isCancelled {
            return
        }

        // Load data
        let allResources = resourcesManager.getAllResources()
        let allEvents = eventsManager.getAllEvents()

        if Task.isCancelled { return }

        // Cache current date for consistent filtering
        let now = Date()
        
        // Update properties with optimized operations
        self.totalResources = allResources.count
        
        // Sort events once and reuse
        let sortedEvents = allEvents.sorted { $0.date < $1.date }
        self.upcomingEventsList = sortedEvents
        self.upcomingEvents = sortedEvents.filter { $0.date > now }.count
        self.recentPosts = 12 // Placeholder

        // Use prefix directly without Array() conversion
        self.featuredResources = Array(allResources.prefix(3))
        
        // Sort resources by dateAdded once and take prefix
        let sortedByDateAdded = allResources.sorted { $0.dateAdded > $1.dateAdded }
        self.recentlyAddedResources = Array(sortedByDateAdded.prefix(5))

        // Recommended resources based on favorites - optimized
        if !favoriteResourceIds.isEmpty {
            // Single pass to collect favorite categories and filter non-favorites
            var favoriteCategories = Set<ResourceCategory>()
            let nonFavoriteResources = allResources.filter { resource in
                if favoriteResourceIds.contains(resource.id) {
                    favoriteCategories.insert(resource.category)
                    return false
                }
                return true
            }
            
            // Filter by favorite categories and shuffle
            self.recommendedResources = Array(nonFavoriteResources
                .filter { favoriteCategories.contains($0.category) }
                .shuffled()
                .prefix(5))
        } else {
            self.recommendedResources = Array(allResources.shuffled().prefix(5))
        }
    }
    
}
