import Foundation
import os

enum AppLogger {
    static let general = Logger(subsystem: Bundle.main.bundleIdentifier ?? "App", category: "general")
    static let resources = Logger(subsystem: Bundle.main.bundleIdentifier ?? "App", category: "resources")
    static let events = Logger(subsystem: Bundle.main.bundleIdentifier ?? "App", category: "events")
    static let user = Logger(subsystem: Bundle.main.bundleIdentifier ?? "App", category: "user")
    
    static func debug(_ message: String, log: Logger = general) {
        log.debug("\(message, privacy: .public)")
    }
    static func info(_ message: String, log: Logger = general) {
        log.info("\(message, privacy: .public)")
    }
    static func error(_ message: String, log: Logger = general, error: Error? = nil) {
        if let error {
            log.error("\(message, privacy: .public) | error: \(error.localizedDescription, privacy: .public)")
        } else {
            log.error("\(message, privacy: .public)")
        }
    }
}

