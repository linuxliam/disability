//
//  DataManager.swift
//  Disability Advocacy
//
//  SwiftData-based data manager replacing UserDefaults
//

import Foundation
import SwiftData

@MainActor
class DataManager {
    static let shared = DataManager()
    
    private var modelContainer: ModelContainer?
    
    private init() {
        // Defer model container setup to avoid issues during initialization
    }
    
    func ensureModelContainer() async {
        guard modelContainer == nil else {
            return
        }
        await setupModelContainer()
    }
    
    private func setupModelContainer() async {
        let schema = Schema([
            PersistentResource.self,
            PersistentEvent.self,
            PersistentUser.self
        ])
        
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )
        
        do {
            modelContainer = try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
        } catch {
            print("Failed to create model container: \(error)")
        }
    }
    
    var context: ModelContext? {
        modelContainer?.mainContext
    }
    
    // MARK: - Resources
    
    func saveResource(_ resource: Resource) async {
        await ensureModelContainer()
        guard let context = context else { return }

        let descriptor = FetchDescriptor<PersistentResource>(
            predicate: #Predicate { $0.id == resource.id }
        )

        do {
            if let existing = try context.fetch(descriptor).first {
                existing.title = resource.title
                existing.resourceDescription = resource.description
                existing.category = resource.category.rawValue
                existing.url = resource.url
                existing.tags = resource.tags
            } else {
                let persistent = PersistentResource(from: resource)
                context.insert(persistent)
            }

            try context.save()
        } catch {
        }
    }

    func loadResources() async -> [Resource] {
        await ensureModelContainer()
        guard let context = context else {
            return []
        }

        let descriptor = FetchDescriptor<PersistentResource>(
            sortBy: [SortDescriptor(\.dateAdded, order: .reverse)]
        )

        do {
            let persistent = try context.fetch(descriptor)
            return persistent.map { $0.toResource() }
        } catch {
            return []
        }
    }
    
    func toggleFavorite(_ resourceId: UUID) async {
        await ensureModelContainer()
        guard let context = context else {
            return
        }

        let descriptor = FetchDescriptor<PersistentResource>(
            predicate: #Predicate { $0.id == resourceId }
        )

        do {
            if let resource = try context.fetch(descriptor).first {
                resource.isFavorite.toggle()
                try context.save()
            } else {
            }
        } catch {
        }
    }
    
    func getFavoriteIds() async -> Set<UUID> {
        await ensureModelContainer()
        guard let context = context else { return [] }

        let descriptor = FetchDescriptor<PersistentResource>(
            predicate: #Predicate { $0.isFavorite == true }
        )

        do {
            let favorites = try context.fetch(descriptor)
            return Set(favorites.map { $0.id })
        } catch {
            return []
        }
    }
    
    // MARK: - Events
    
    func saveEvent(_ event: Event) async {
        await ensureModelContainer()
        guard let context = context else { return }
            
            let descriptor = FetchDescriptor<PersistentEvent>(
                predicate: #Predicate { $0.id == event.id }
            )
            
            do {
                if let existing = try context.fetch(descriptor).first {
                    existing.title = event.title
                    existing.eventDescription = event.description
                    existing.date = event.date
                    existing.location = event.location
                    existing.isVirtual = event.isVirtual
                    existing.registrationURL = event.registrationURL
                    existing.eventURL = event.eventURL
                    existing.category = event.category.rawValue
                    existing.accessibilityNotes = event.accessibilityNotes
                } else {
                    let persistent = PersistentEvent(from: event)
                    context.insert(persistent)
                }

                try context.save()
            } catch {
            }
    }

    func loadEvents() async -> [Event] {
        await ensureModelContainer()
        guard let context = context else { return [] }

        let descriptor = FetchDescriptor<PersistentEvent>(
            sortBy: [SortDescriptor(\.date, order: .forward)]
        )

        do {
            let persistent = try context.fetch(descriptor)
            return persistent.map { $0.toEvent() }
        } catch {
            return []
        }
    }
    
    // MARK: - User
    
    func saveUser(_ user: User) async {
        await ensureModelContainer()
        guard let context = context else { return }
            
            let descriptor = FetchDescriptor<PersistentUser>(
                predicate: #Predicate { $0.id == user.id }
            )
            
            do {
                if let existing = try context.fetch(descriptor).first {
                    existing.name = user.name
                    existing.email = user.email
                    existing.phoneNumber = user.phoneNumber
                    existing.bio = user.bio
                    existing.location = user.location
                    existing.interests = user.interests
                    existing.accessibilityNeeds = user.accessibilityNeeds
                    existing.eventReminders = user.notificationPreferences.eventReminders
                    existing.newResources = user.notificationPreferences.newResources
                    existing.communityUpdates = user.notificationPreferences.communityUpdates
                    existing.newsUpdates = user.notificationPreferences.newsUpdates
                } else {
                    let persistent = PersistentUser(from: user)
                    context.insert(persistent)
                }

                try context.save()
            } catch {
            }
    }

    func loadUser() async -> User? {
        await ensureModelContainer()
        guard let context = context else { return nil }

        let descriptor = FetchDescriptor<PersistentUser>()

        do {
            guard let persistent = try context.fetch(descriptor).first else {
                return nil
            }
            return persistent.toUser()
        } catch {
            return nil
        }
    }
    
    func deleteUser() async {
        await ensureModelContainer()
        guard let context = context else { return }

        let descriptor = FetchDescriptor<PersistentUser>()

        do {
            if let user = try context.fetch(descriptor).first {
                context.delete(user)
                try context.save()
            }
        } catch {
        }
    }
    
    // MARK: - JSON Storage
    
    func getJSONStorageManager() -> JSONStorageManager {
        return JSONStorageManager.shared
    }
}

// MARK: - JSON Storage Manager

@MainActor
class JSONStorageManager {
    static let shared = JSONStorageManager()
    
    private init() {}
    
    private var documentsDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    private func getFileURL(for filename: String) -> URL {
        documentsDirectory.appendingPathComponent(filename)
    }
    
    /// Copies a bundled JSON file to the Documents directory if it doesn't already exist.
    func initializeFileFromBundle(filename: String) {
        // #region agent log
        AppLogger.agentDebugLog(location: "DataManager.swift:271", message: "Initializing file from bundle", data: ["filename": filename], hypothesisId: "3")
        // #endregion
        let fileURL = getFileURL(for: filename)
        
        // Only copy if it doesn't exist to avoid overwriting user changes
        guard !FileManager.default.fileExists(atPath: fileURL.path) else {
            // #region agent log
            AppLogger.agentDebugLog(location: "DataManager.swift:276", message: "File already exists in Documents", data: ["filename": filename, "path": fileURL.path], hypothesisId: "3")
            // #endregion
            return
        }
        
        // Remove extension for bundle lookup
        let name = (filename as NSString).deletingPathExtension
        let ext = (filename as NSString).pathExtension
        
        let bundleURL = Bundle.main.url(forResource: name, withExtension: ext)
        // #region agent log
        AppLogger.agentDebugLog(location: "DataManager.swift:283", message: "Bundle lookup result", data: ["filename": filename, "found": bundleURL != nil, "bundlePath": Bundle.main.bundlePath], hypothesisId: "1")
        // #endregion
        
        guard let bundleURL = bundleURL else {
            print("Warning: Bundled file \(filename) not found.")
            return
        }
        
        do {
            try FileManager.default.copyItem(at: bundleURL, to: fileURL)
            print("Initialized \(filename) in Documents directory.")
            // #region agent log
            AppLogger.agentDebugLog(location: "DataManager.swift:293", message: "File copied from bundle", data: ["filename": filename, "to": fileURL.path], hypothesisId: "1")
            // #endregion
        } catch {
            print("Error initializing \(filename): \(error)")
            // #region agent log
            AppLogger.agentDebugLog(location: "DataManager.swift:297", message: "Error copying file", data: ["filename": filename, "error": error.localizedDescription], hypothesisId: "1")
            // #endregion
        }
    }
    
    /// Loads an array of Codable objects from a JSON file in the Documents directory.
    func load<T: Decodable>(filename: String) -> [T] {
        let fileURL = getFileURL(for: filename)
        
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return []
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode([T].self, from: data)
        } catch {
            print("Error loading \(filename): \(error)")
            return []
        }
    }
    
    /// Saves an array of Codable objects to a JSON file in the Documents directory.
    func save<T: Encodable>(_ items: [T], filename: String) {
        let fileURL = getFileURL(for: filename)
        
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            let data = try encoder.encode(items)
            try data.write(to: fileURL, options: [.atomic, .completeFileProtection])
        } catch {
            print("Error saving \(filename): \(error)")
        }
    }
    
    /// Returns the raw URL for the file in the Documents directory (useful for sharing).
    func getLocalFileURL(for filename: String) -> URL? {
        let fileURL = getFileURL(for: filename)
        return FileManager.default.fileExists(atPath: fileURL.path) ? fileURL : nil
    }
}

