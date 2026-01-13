//
//  CalendarManager.swift
//  Disability Advocacy
//
//  Unified Calendar Manager for iOS and macOS
//

import Foundation
import EventKit
import SwiftUI

import Observation

@MainActor
@Observable
class CalendarManager {
    static let shared = CalendarManager()
    
    var hasCalendarAccess = false
    var showAlert = false
    var showSettingsAlert = false
    var alertMessage = ""
    
    private let eventStore = EKEventStore()
    static let defaultEventDuration: TimeInterval = 3600
    
    private init() {
        checkAuthorizationStatus()
    }
    
    func checkAuthorizationStatus() {
        let status = EKEventStore.authorizationStatus(for: .event)
        #if os(iOS)
        hasCalendarAccess = (status == .fullAccess || status == .writeOnly)
        #else
        // On macOS, check for full access or write-only access (authorized deprecated in macOS 14.0)
        hasCalendarAccess = (status == .fullAccess || status == .writeOnly)
        #endif
    }
    
    func requestAccess() async -> Bool {
        let status = EKEventStore.authorizationStatus(for: .event)
        
        #if os(iOS)
        if status == .fullAccess || status == .writeOnly {
            hasCalendarAccess = true
            return true
        }
        
        if status == .denied || status == .restricted {
            showSettingsAlert = true
            return false
        }
        
        do {
            let granted = try await eventStore.requestFullAccessToEvents()
            hasCalendarAccess = granted
            if !granted {
                showSettingsAlert = true
            }
            return granted
        } catch {
            alertMessage = "Failed to request calendar access: \(error.localizedDescription)"
            showAlert = true
            hasCalendarAccess = false
            return false
        }
        #else
        // Check for full access or write-only access (authorized deprecated in macOS 14.0)
        if status == .fullAccess || status == .writeOnly {
            hasCalendarAccess = true
            return true
        }
        
        if status == .denied || status == .restricted {
            showSettingsAlert = true
            return false
        }

        // macOS logic: try write-only first, then full
        do {
            let granted = try await eventStore.requestWriteOnlyAccessToEvents()
            hasCalendarAccess = granted
            return granted
        } catch {
            do {
                let granted = try await eventStore.requestFullAccessToEvents()
                hasCalendarAccess = granted
                return granted
            } catch {
                alertMessage = "Failed to request calendar access: \(error.localizedDescription)"
                showAlert = true
                hasCalendarAccess = false
                return false
            }
        }
        #endif
    }
    
    @discardableResult
    func addEventToCalendar(event: Event) async -> Bool {
        if !hasCalendarAccess {
            let granted = await requestAccess()
            if !granted { return false }
        }
        
        let ekEvent = EKEvent(eventStore: eventStore)
        ekEvent.title = event.title
        ekEvent.startDate = event.date
        ekEvent.endDate = event.date.addingTimeInterval(CalendarManager.defaultEventDuration)
        ekEvent.notes = event.description
        ekEvent.location = event.location
        ekEvent.calendar = eventStore.defaultCalendarForNewEvents
        
        do {
            try eventStore.save(ekEvent, span: .thisEvent)
            alertMessage = "Event successfully added to your calendar."
            showAlert = true
            return true
        } catch {
            alertMessage = "Failed to save event: \(error.localizedDescription)"
            showAlert = true
            return false
        }
    }
    
    func openAppSettings() {
        #if os(iOS)
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
        #elseif os(macOS)
        if let settingsUrl = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Calendars") {
            NSWorkspace.shared.open(settingsUrl)
        }
        #endif
    }
}
