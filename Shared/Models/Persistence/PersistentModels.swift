//
//  PersistentModels.swift
//  Disability Advocacy
//
//  SwiftData models for persistent storage
//

import Foundation
import SwiftData

@Model
final class PersistentResource {
    @Attribute(.unique) var id: UUID
    var title: String
    var resourceDescription: String
    var category: String
    var url: String?
    var tags: [String]
    var dateAdded: Date
    var isFavorite: Bool
    
    init(from resource: Resource) {
        self.id = resource.id
        self.title = resource.title
        self.resourceDescription = resource.description
        self.category = resource.category.rawValue
        self.url = resource.url
        self.tags = resource.tags
        self.dateAdded = resource.dateAdded
        self.isFavorite = false
    }
    
    func toResource() -> Resource {
        Resource(
            id: id,
            title: title,
            description: resourceDescription,
            category: ResourceCategory(rawValue: category) ?? .legal,
            url: url,
            tags: tags,
            dateAdded: dateAdded
        )
    }
}

@Model
final class PersistentEvent {
    @Attribute(.unique) var id: UUID
    var title: String
    var eventDescription: String
    var date: Date
    var location: String
    var isVirtual: Bool
    var registrationURL: String?
    var eventURL: String?
    var category: String
    var accessibilityNotes: String?
    
    init(from event: Event) {
        self.id = event.id
        self.title = event.title
        self.eventDescription = event.description
        self.date = event.date
        self.location = event.location
        self.isVirtual = event.isVirtual
        self.registrationURL = event.registrationURL
        self.eventURL = event.eventURL
        self.category = event.category.rawValue
        self.accessibilityNotes = event.accessibilityNotes
    }
    
    func toEvent() -> Event {
        Event(
            id: id,
            title: title,
            description: eventDescription,
            date: date,
            location: location,
            isVirtual: isVirtual,
            registrationURL: registrationURL,
            eventURL: eventURL,
            category: EventCategory(rawValue: category) ?? .workshop,
            accessibilityNotes: accessibilityNotes
        )
    }
}

@Model
final class PersistentUser {
    @Attribute(.unique) var id: UUID
    var name: String
    var email: String
    var phoneNumber: String?
    var bio: String?
    var location: String?
    var interests: [String]
    var accessibilityNeeds: [String]
    var eventReminders: Bool
    var newResources: Bool
    var communityUpdates: Bool
    var newsUpdates: Bool
    
    init(from user: User) {
        self.id = user.id
        self.name = user.name
        self.email = user.email
        self.phoneNumber = user.phoneNumber
        self.bio = user.bio
        self.location = user.location
        self.interests = user.interests
        self.accessibilityNeeds = user.accessibilityNeeds
        self.eventReminders = user.notificationPreferences.eventReminders
        self.newResources = user.notificationPreferences.newResources
        self.communityUpdates = user.notificationPreferences.communityUpdates
        self.newsUpdates = user.notificationPreferences.newsUpdates
    }
    
    func toUser() -> User {
        var user = User(
            id: id,
            name: name,
            email: email,
            phoneNumber: phoneNumber,
            bio: bio,
            location: location,
            interests: interests,
            accessibilityNeeds: accessibilityNeeds
        )
        user.notificationPreferences = NotificationPreferences(
            eventReminders: eventReminders,
            newResources: newResources,
            communityUpdates: communityUpdates,
            newsUpdates: newsUpdates
        )
        return user
    }
}

