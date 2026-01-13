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
    
    var filteredResources: [Resource] {
        resources.filtered(searchText: searchText, category: selectedCategory)
    }
    
    private let resourcesManager: ResourcesManager
    private var loadTask: Task<Void, Never>?
    
    init(resourcesManager: ResourcesManager = ResourcesManager.shared) {
        self.resourcesManager = resourcesManager
    }
    
    func clearFilters() {
        searchText = ""
        selectedCategory = nil
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
    }
    
}


