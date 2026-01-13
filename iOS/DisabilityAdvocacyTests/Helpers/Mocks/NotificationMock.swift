//
//  NotificationMock.swift
//  DisabilityAdvocacyTests
//
//  Mock NotificationManager for testing
//

import Foundation
import UserNotifications

/// Mock notification for testing
struct MockNotification {
    let identifier: String
    let title: String
    let body: String
    let triggerDate: Date?
    let userInfo: [AnyHashable: Any]?
    let categoryIdentifier: String?
}

/// Mock NotificationManager for testing notification functionality
class NotificationMock {
    /// Scheduled notifications
    private(set) var scheduledNotifications: [MockNotification] = []
    
    /// Authorization status
    var authorizationStatus: UNAuthorizationStatus = .notDetermined
    
    /// Request authorization result
    var requestAuthorizationGranted: Bool = false
    
    /// Event reminders enabled
    var eventRemindersEnabled: Bool = true
    
    /// Reminder time preference (stored as TimeInterval in minutes)
    var reminderTimeMinutes: Int = 15
    
    /// Schedule a notification
    func scheduleNotification(
        identifier: String,
        title: String,
        body: String,
        triggerDate: Date?,
        userInfo: [AnyHashable: Any]? = nil,
        categoryIdentifier: String? = nil
    ) {
        let notification = MockNotification(
            identifier: identifier,
            title: title,
            body: body,
            triggerDate: triggerDate,
            userInfo: userInfo,
            categoryIdentifier: categoryIdentifier
        )
        scheduledNotifications.append(notification)
    }
    
    /// Cancel a notification
    func cancelNotification(identifier: String) {
        scheduledNotifications.removeAll { $0.identifier == identifier }
    }
    
    /// Cancel all notifications
    func cancelAllNotifications() {
        scheduledNotifications.removeAll()
    }
    
    /// Get notification by identifier
    func getNotification(identifier: String) -> MockNotification? {
        scheduledNotifications.first { $0.identifier == identifier }
    }
    
    /// Check if notification is scheduled
    func isScheduled(identifier: String) -> Bool {
        scheduledNotifications.contains { $0.identifier == identifier }
    }
    
    /// Get all scheduled notification identifiers
    var scheduledIdentifiers: [String] {
        scheduledNotifications.map { $0.identifier }
    }
    
    /// Reset mock state
    func reset() {
        scheduledNotifications.removeAll()
        authorizationStatus = .notDetermined
        requestAuthorizationGranted = false
        eventRemindersEnabled = true
        reminderTimeMinutes = 15
    }
    
    /// Request authorization
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        requestAuthorizationGranted = true
        authorizationStatus = .authorized
        completion(true)
    }
    
    /// Check authorization status
    func checkAuthorizationStatus() -> UNAuthorizationStatus {
        return authorizationStatus
    }
}

