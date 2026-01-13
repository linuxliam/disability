//
//  EventsManager.swift
//  Disability Advocacy
//
//  Manages event data and persistence using JSONStorageManager.
//

import Foundation

@MainActor
class EventsManager {
    static let shared = EventsManager()
    
    private let filename = "Events.json"
    private var cachedEvents: [Event]?
    
    func getAllEvents() -> [Event] {
        if let cached = cachedEvents {
            return cached
        }
        AppLogger.debug("Loading events from disk", log: AppLogger.events)
        let events: [Event] = JSONStorageManager.shared.load(filename: filename)
        cachedEvents = events
        return events
    }
    
    func saveEvents(_ events: [Event]) {
        AppLogger.info("Saving \(events.count) events to disk", log: AppLogger.events)
        cachedEvents = events
        JSONStorageManager.shared.save(events, filename: filename)
    }
    
    func addEvent(_ event: Event) {
        var events = getAllEvents()
        events.append(event)
        saveEvents(events)
    }
    
    func updateEvent(_ event: Event) {
        var events = getAllEvents()
        if let index = events.firstIndex(where: { $0.id == event.id }) {
            events[index] = event
            saveEvents(events)
        }
    }
    
    func deleteEvent(id: UUID) {
        var events = getAllEvents()
        events.removeAll(where: { $0.id == id })
        saveEvents(events)
    }
    
    /// Forces a reload from disk and clears the cache
    func reloadEvents() -> [Event] {
        cachedEvents = nil
        return getAllEvents()
    }
}
