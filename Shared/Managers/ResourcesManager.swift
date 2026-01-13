//
//  ResourcesManager.swift
//  Disability Advocacy
//
//  Manages resource data and persistence using JSONStorageManager.
//

import Foundation

@MainActor
class ResourcesManager {
    static let shared = ResourcesManager()
    
    private let filename = "Resources.json"
    private var cachedResources: [Resource]?
    
    func getAllResources() -> [Resource] {
        if let cached = cachedResources {
            return cached
        }
        AppLogger.debug("Loading resources from disk", log: AppLogger.resources)
        let resources: [Resource] = JSONStorageManager.shared.load(filename: filename)
        cachedResources = resources
        return resources
    }
    
    func saveResources(_ resources: [Resource]) {
        AppLogger.info("Saving \(resources.count) resources to disk", log: AppLogger.resources)
        cachedResources = resources
        JSONStorageManager.shared.save(resources, filename: filename)
    }
    
    func addResource(_ resource: Resource) {
        var resources = getAllResources()
        resources.append(resource)
        saveResources(resources)
    }
    
    func updateResource(_ resource: Resource) {
        var resources = getAllResources()
        if let index = resources.firstIndex(where: { $0.id == resource.id }) {
            resources[index] = resource
            saveResources(resources)
        }
    }
    
    func deleteResource(id: UUID) {
        var resources = getAllResources()
        resources.removeAll(where: { $0.id == id })
        saveResources(resources)
    }
    
    /// Forces a reload from disk and clears the cache
    func reloadResources() -> [Resource] {
        cachedResources = nil
        return getAllResources()
    }
}

