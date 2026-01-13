//
//  User.swift
//  Disability Advocacy
//
//  User profile model
//

import Foundation

struct User: Codable {
    var id: UUID
    var name: String
    var email: String
    var phoneNumber: String?
    var bio: String?
    var location: String?
    var interests: [String]
    var accessibilityNeeds: [String]
    var notificationPreferences: NotificationPreferences
    
    init(
        id: UUID = UUID(),
        name: String = "",
        email: String = "",
        phoneNumber: String? = nil,
        bio: String? = nil,
        location: String? = nil,
        interests: [String] = [],
        accessibilityNeeds: [String] = [],
        notificationPreferences: NotificationPreferences = NotificationPreferences()
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.phoneNumber = phoneNumber
        self.bio = bio
        self.location = location
        self.interests = interests
        self.accessibilityNeeds = accessibilityNeeds
        self.notificationPreferences = notificationPreferences
    }
}

struct NotificationPreferences: Codable {
    var eventReminders: Bool = true
    var newResources: Bool = true
    var communityUpdates: Bool = true
    var newsUpdates: Bool = false
}

