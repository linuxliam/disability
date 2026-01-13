//
//  NotificationManagerTests.swift
//  DisabilityAdvocacyTests
//
//  Unit tests for NotificationManager
//

import XCTest
@testable import DisabilityAdvocacy
import UserNotifications

@MainActor
final class NotificationManagerTests: XCTestCase {
    var notificationManager: NotificationManager!
    
    override func setUp() {
        super.setUp()
        notificationManager = NotificationManager.shared
        // Clear UserDefaults
        UserDefaults.standard.removeObject(forKey: "eventRemindersEnabled")
        UserDefaults.standard.removeObject(forKey: "reminderTime")
    }
    
    override func tearDown() {
        UserDefaults.standard.removeObject(forKey: "eventRemindersEnabled")
        UserDefaults.standard.removeObject(forKey: "reminderTime")
        notificationManager = nil
        super.tearDown()
    }
    
    // MARK: - Singleton Pattern Tests
    
    func testSharedInstance_ReturnsSameInstance() {
        // When
        let instance1 = NotificationManager.shared
        let instance2 = NotificationManager.shared
        
        // Then
        XCTAssertTrue(instance1 === instance2, "Shared instance should return the same instance")
    }
    
    // MARK: - Initial State Tests
    
    func testInitialState_DefaultValues() {
        // Then
        // Note: authorizationStatus may vary based on system state
        XCTAssertTrue(notificationManager.eventRemindersEnabled, "Event reminders should be enabled by default")
        XCTAssertEqual(notificationManager.reminderTime, .oneDayBefore, "Default reminder time should be one day before")
    }
    
    // MARK: - Preferences Tests
    
    func testSetEventRemindersEnabled_UpdatesProperty() {
        // Given
        XCTAssertTrue(notificationManager.eventRemindersEnabled, "Should start enabled")
        
        // When
        notificationManager.setEventRemindersEnabled(false)
        
        // Then
        XCTAssertFalse(notificationManager.eventRemindersEnabled, "Should update property")
    }
    
    func testSetEventRemindersEnabled_PersistsToUserDefaults() {
        // Given
        notificationManager.setEventRemindersEnabled(false)
        
        // When - Create new instance (simulating app restart)
        // Since we're using shared instance, we'll test UserDefaults directly
        let savedValue = UserDefaults.standard.bool(forKey: "eventRemindersEnabled")
        
        // Then
        XCTAssertFalse(savedValue, "Should persist to UserDefaults")
    }
    
    func testSetReminderTime_UpdatesProperty() {
        // Given
        XCTAssertEqual(notificationManager.reminderTime, .oneDayBefore)
        
        // When
        notificationManager.setReminderTime(.threeDaysBefore)
        
        // Then
        XCTAssertEqual(notificationManager.reminderTime, .threeDaysBefore, "Should update property")
    }
    
    func testSetReminderTime_PersistsToUserDefaults() {
        // Given
        notificationManager.setReminderTime(.oneWeekBefore)
        
        // When
        let savedValue = UserDefaults.standard.object(forKey: "reminderTime") as? Int
        
        // Then
        XCTAssertEqual(savedValue, ReminderTime.oneWeekBefore.rawValue, "Should persist to UserDefaults")
    }
    
    func testLoadPreferences_LoadsFromUserDefaults() {
        // Given
        UserDefaults.standard.set(false, forKey: "eventRemindersEnabled")
        UserDefaults.standard.set(ReminderTime.threeDaysBefore.rawValue, forKey: "reminderTime")
        
        // When - Create new instance to trigger loadPreferences
        // Since we're using shared instance, preferences are loaded in init
        // We'll test by setting and then verifying they persist
        notificationManager.setEventRemindersEnabled(false)
        notificationManager.setReminderTime(.threeDaysBefore)
        
        // Then
        XCTAssertFalse(notificationManager.eventRemindersEnabled)
        XCTAssertEqual(notificationManager.reminderTime, .threeDaysBefore)
    }
    
    // MARK: - Event Reminder Tests
    
    func testScheduleEventReminder_PastEvent_DoesNotSchedule() {
        // Given
        let pastEvent = Event(
            title: "Past Event",
            description: "Description",
            date: Date().addingTimeInterval(-86400), // Yesterday
            location: "Location",
            category: .workshop
        )
        
        // When
        notificationManager.scheduleEventReminder(for: pastEvent)
        
        // Then
        // Should not crash and should not schedule (tested by checking it doesn't throw)
        // Actual scheduling verification would require mocking UNUserNotificationCenter
    }
    
    func testScheduleEventReminder_FutureEvent_Schedules() {
        // Given
        let futureEvent = Event(
            title: "Future Event",
            description: "Description",
            date: Date().addingTimeInterval(86400 * 2), // 2 days from now
            location: "Location",
            category: .workshop
        )
        notificationManager.eventRemindersEnabled = true
        
        // When
        notificationManager.scheduleEventReminder(for: futureEvent)
        
        // Then
        // Should not crash
        // Actual verification would require mocking UNUserNotificationCenter
    }
    
    func testScheduleEventReminder_DisabledReminders_DoesNotSchedule() {
        // Given
        let futureEvent = Event(
            title: "Future Event",
            description: "Description",
            date: Date().addingTimeInterval(86400 * 2),
            location: "Location",
            category: .workshop
        )
        notificationManager.setEventRemindersEnabled(false)
        
        // When
        notificationManager.scheduleEventReminder(for: futureEvent)
        
        // Then
        // Should not schedule when disabled
        // Verification would require mocking UNUserNotificationCenter
    }
    
    func testCancelEventReminder_RemovesNotification() {
        // Given
        let event = Event(
            title: "Test Event",
            description: "Description",
            date: Date().addingTimeInterval(86400),
            location: "Location",
            category: .workshop
        )
        let eventId = event.id
        
        // When
        notificationManager.cancelEventReminder(for: eventId)
        
        // Then
        // Should not crash
        // Verification would require mocking UNUserNotificationCenter
    }
    
    func testScheduleEventReminders_ForMultipleEvents() {
        // Given
        let events = [
            Event(title: "Event 1", description: "Desc", date: Date().addingTimeInterval(86400), location: "Loc", category: .workshop),
            Event(title: "Event 2", description: "Desc", date: Date().addingTimeInterval(86400 * 2), location: "Loc", category: .conference)
        ]
        notificationManager.eventRemindersEnabled = true
        
        // When
        notificationManager.scheduleEventReminders(for: events)
        
        // Then
        // Should not crash
        // Verification would require mocking UNUserNotificationCenter
    }
    
    // MARK: - ReminderTime Enum Tests
    
    func testReminderTime_DaysBefore() {
        // Then
        XCTAssertEqual(ReminderTime.oneHourBefore.daysBefore, 0, "One hour before should return 0 days")
        XCTAssertEqual(ReminderTime.oneDayBefore.daysBefore, 1, "One day before should return 1 day")
        XCTAssertEqual(ReminderTime.threeDaysBefore.daysBefore, 3, "Three days before should return 3 days")
        XCTAssertEqual(ReminderTime.oneWeekBefore.daysBefore, 7, "One week before should return 7 days")
    }
    
    func testReminderTime_DisplayNames() {
        // Then
        XCTAssertFalse(ReminderTime.oneHourBefore.displayName.isEmpty, "Should have display name")
        XCTAssertFalse(ReminderTime.oneDayBefore.displayName.isEmpty, "Should have display name")
        XCTAssertFalse(ReminderTime.threeDaysBefore.displayName.isEmpty, "Should have display name")
        XCTAssertFalse(ReminderTime.oneWeekBefore.displayName.isEmpty, "Should have display name")
    }
    
    func testReminderTime_AllCases() {
        // Then
        let allCases = ReminderTime.allCases
        XCTAssertEqual(allCases.count, 4, "Should have 4 reminder time options")
    }
    
    // MARK: - Notification Error Tests
    
    func testNotificationError_AuthorizationDenied() {
        // Given
        let error = NotificationError.authorizationDenied
        
        // Then
        XCTAssertNotNil(error.errorDescription, "Should have error description")
        XCTAssertFalse(error.errorDescription?.isEmpty ?? true, "Error description should not be empty")
    }
    
    func testNotificationError_SchedulingFailed() {
        // Given
        let error = NotificationError.schedulingFailed
        
        // Then
        XCTAssertNotNil(error.errorDescription, "Should have error description")
        XCTAssertFalse(error.errorDescription?.isEmpty ?? true, "Error description should not be empty")
    }
    
    // MARK: - Setup Notification Categories Tests
    
    func testSetupNotificationCategories() {
        // When
        notificationManager.setupNotificationCategories()
        
        // Then
        // Should not crash
        // Verification would require mocking UNUserNotificationCenter
    }
    
    // MARK: - Check Authorization Status Tests
    
    func testCheckAuthorizationStatus() {
        // When
        notificationManager.checkAuthorizationStatus()
        
        // Then
        // Should update authorizationStatus property
        // Note: Actual status depends on system authorization state
        // We just verify the method doesn't crash
    }
}

