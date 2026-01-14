//
//  EventsViewModel.swift
//  Disability Advocacy
//
//  View model for events view
//

import Foundation
import Observation

@MainActor
@Observable
class EventsViewModel: BaseViewModelProtocol {
    var events: [Event] = []
    var isLoading: Bool = false
    var errorMessage: String?
    var showError: Bool = false
    
    // Filtering
    var selectedCategory: EventCategory?
    var dateFilter: EventDateFilter = .upcoming
    
    var filteredEvents: [Event] {
        // Cache current date to ensure consistent filtering within a single view update
        let now = Date()
        return events.filtered(category: selectedCategory, dateFilter: dateFilter, currentDate: now)
    }
    
    private let eventsManager: EventsManager
    private var loadTask: Task<Void, Never>?
    
    nonisolated init(eventsManager: EventsManager = MainActor.assumeIsolated { EventsManager.shared }) {
        self.eventsManager = eventsManager
    }
    
    func clearFilters() {
        selectedCategory = nil
        dateFilter = .upcoming
    }
    
    func loadEvents() {
        loadTask?.cancel()
        
        guard !isLoading else { return }
        
        isLoading = true
        clearError()
        
        loadTask = Task {
            await performLoad()
        }
    }
    
    private func performLoad() async {
        defer { isLoading = false }
        
        guard !Task.isCancelled else { return }
        
        do {
            // Simulate async loading
            try await Task.sleep(nanoseconds: AppConstants.Timing.simulatedLoadDelay)
            
            guard !Task.isCancelled else { return }
            
            events = eventsManager.getAllEvents()
        } catch {
            handleError(error)
        }
    }
    
}


