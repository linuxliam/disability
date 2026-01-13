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

        // Update properties
        self.totalResources = allResources.count
        self.upcomingEventsList = allEvents.sorted { $0.date < $1.date }
        self.upcomingEvents = self.upcomingEventsList.filter { $0.date > Date() }.count
        self.recentPosts = 12 // Placeholder

        self.featuredResources = Array(allResources.prefix(3))
        self.recentlyAddedResources = Array(allResources.sorted { $0.dateAdded > $1.dateAdded }.prefix(5))

        // Recommended resources based on favorites
        if !favoriteResourceIds.isEmpty {
            let favoriteCategories = Set(allResources.filter { favoriteResourceIds.contains($0.id) }.map { $0.category })
            self.recommendedResources = allResources.filter {
                !favoriteResourceIds.contains($0.id) && favoriteCategories.contains($0.category)
            }.shuffled().prefix(5).map { $0 }
        } else {
            self.recommendedResources = allResources.shuffled().prefix(5).map { $0 }
        }
    }
    
}
