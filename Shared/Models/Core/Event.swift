//
//  Event.swift
//  Disability Advocacy
//
//  Event data model
//

import Foundation

struct Event: Identifiable, Codable, Hashable {
    let id: UUID
    var title: String
    var description: String
    var date: Date
    var location: String
    var isVirtual: Bool
    var registrationURL: String?
    var eventURL: String?
    var category: EventCategory
    var accessibilityNotes: String?
    
    init(id: UUID = UUID(), title: String, description: String, date: Date, location: String, isVirtual: Bool = false, registrationURL: String? = nil, eventURL: String? = nil, category: EventCategory, accessibilityNotes: String? = nil) {
        self.id = id
        self.title = title
        self.description = description
        self.date = date
        self.location = location
        self.isVirtual = isVirtual
        self.registrationURL = registrationURL
        self.eventURL = eventURL
        self.category = category
        self.accessibilityNotes = accessibilityNotes
    }
}

enum EventCategory: String, Codable, CaseIterable {
    case workshop = "Workshop"
    case conference = "Conference"
    case webinar = "Webinar"
    case rally = "Rally"
    case meeting = "Community Meeting"
    case training = "Training"
    
    var icon: String {
        switch self {
        case .workshop: return "wrench.and.screwdriver.fill"
        case .conference: return "person.3.fill"
        case .webinar: return "video.fill"
        case .rally: return "megaphone.fill"
        case .meeting: return "person.2.fill"
        case .training: return "book.fill"
        }
    }
}

// MARK: - Event Filtering Extension
extension Array where Element == Event {
    /// Filters events by category and sorts by date
    func filtered(category: EventCategory?) -> [Event] {
        var filtered = self
        
        if let category = category {
            filtered = filtered.filter { $0.category == category }
        }
        
        return filtered.sorted { $0.date < $1.date }
    }
}


