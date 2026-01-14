//
//  ResourcesViewModel.swift
//  Disability Advocacy
//
//  View model for resources view
//

import Foundation
import Observation

@MainActor
@Observable
class ResourcesViewModel: BaseViewModelProtocol {
    var resources: [Resource] = []
    var isLoading: Bool = false
    var errorMessage: String?
    var showError: Bool = false
    
    // Filtering
    var searchText: String = ""
    var selectedCategory: ResourceCategory?
    var selectedTag: String?
    
    var filteredResources: [Resource] {
        resources.filtered(searchText: searchText, category: selectedCategory, tag: selectedTag)
    }
    
    // Cached tags to avoid recalculating on every access
    private var _cachedTags: [String]?
    private var _tagsCacheVersion: Int = 0
    
    var availableTags: [String] {
        // Invalidate cache if resources changed
        let currentVersion = resources.count
        if _cachedTags == nil || _tagsCacheVersion != currentVersion {
            let allTags = resources.flatMap { $0.tags }
            _cachedTags = Array(Set(allTags)).sorted()
            _tagsCacheVersion = currentVersion
        }
        return _cachedTags ?? []
    }
    
    private let resourcesManager: ResourcesManager
    private var loadTask: Task<Void, Never>?
    
    nonisolated init(resourcesManager: ResourcesManager = MainActor.assumeIsolated { ResourcesManager.shared }) {
        self.resourcesManager = resourcesManager
    }
    
    func clearFilters() {
        searchText = ""
        selectedCategory = nil
        selectedTag = nil
    }
    
    func loadResources() {
        loadTask?.cancel()

        guard !isLoading else {
            return
        }

        isLoading = true
        clearError()

        loadTask = Task {
            await performLoad()
        }
    }
    
    private func performLoad() async {
        defer { isLoading = false }
        
        // Check for cancellation
        guard !Task.isCancelled else { return }
        
        // Load from bundle (instant, no network delay needed)
        let loadedResources = resourcesManager.getAllResources()
        
        // Check cancellation again before updating UI
        guard !Task.isCancelled else { return }
        
        resources = loadedResources
        // Invalidate tags cache when resources change
        _cachedTags = nil
        _tagsCacheVersion = 0
    }
    
}


