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
            AppLogger.error("Failed to create model container", error: error)
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
// Note: JSONStorageManager is now in its own file: JSONStorageManager.swift

