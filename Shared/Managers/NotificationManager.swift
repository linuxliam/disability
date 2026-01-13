import Foundation
import Observation

@MainActor
@Observable
class NotificationManager {
    static let shared = NotificationManager()
    
    func initialize() {
        // Initialize notification channels/settings if needed
    }
    
    func requestAuthorization() async throws -> Bool {
        #if os(iOS)
        // Keep it simple: return true for now
        return true
        #else
        return true
        #endif
    }
}

