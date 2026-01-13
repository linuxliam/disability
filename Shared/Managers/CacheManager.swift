//
//  CacheManager.swift
//  Disability Advocacy iOS
//
//  Caching service for offline-first approach
//

import Foundation

/// Manages local caching for app data with expiration and offline support
actor CacheManager {
    static let shared = CacheManager()
    
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    private let cacheExpirationInterval: TimeInterval = 7 * 24 * 60 * 60 // 7 days
    
    private init() {
        let cacheURL = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        cacheDirectory = cacheURL.appendingPathComponent("DisabilityAdvocacy", isDirectory: true)
        
        // Create cache directory if it doesn't exist
        do {
            try fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
        } catch {
        }
    }
    
    // MARK: - Generic Cache Operations
    
    /// Caches data with a key and expiration date
    func cache<T: Codable>(_ data: T, key: String, expirationDate: Date? = nil) {
        let expiration = expirationDate ?? Date().addingTimeInterval(cacheExpirationInterval)
        let cacheItem = CacheItem(data: data, expirationDate: expiration)
        
        let fileURL = cacheDirectory.appendingPathComponent("\(key).json")
        
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let encoded = try encoder.encode(cacheItem)
            try encoded.write(to: fileURL)
        } catch {
            AppLogger.error("Failed to cache data for key: \(key)", log: AppLogger.general, error: error)
        }
    }
    
    /// Retrieves cached data if it exists and hasn't expired
    func retrieve<T: Codable>(key: String, type: T.Type) -> T? {
        let fileURL = cacheDirectory.appendingPathComponent("\(key).json")
        
        guard fileManager.fileExists(atPath: fileURL.path) else {
            return nil
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let cacheItem = try decoder.decode(CacheItem<T>.self, from: data)
            
            // Check expiration
            if cacheItem.expirationDate < Date() {
                // Cache expired, remove it
                do {
                    try fileManager.removeItem(at: fileURL)
                } catch {
                }
                return nil
            }
            
            return cacheItem.data
        } catch {
            AppLogger.error("Failed to retrieve cached data for key: \(key)", log: AppLogger.general, error: error)
            // Remove corrupted cache file
            try? fileManager.removeItem(at: fileURL)
            return nil
        }
    }
    
    /// Removes cached data for a specific key
    func remove(key: String) {
        let fileURL = cacheDirectory.appendingPathComponent("\(key).json")
        do {
            try fileManager.removeItem(at: fileURL)
        } catch {
        }
    }
    
    /// Clears all cached data
    func clearAll() {
        do {
            let files = try fileManager.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: nil)
            for file in files {
                do {
                    try fileManager.removeItem(at: file)
                } catch {
                }
            }
        } catch {
            AppLogger.error("Failed to clear cache", log: AppLogger.general, error: error)
        }
    }
    
    /// Clears expired cache entries
    func clearExpired() {
        do {
            let files = try fileManager.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: nil)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            for file in files {
                guard file.pathExtension == "json" else { continue }
                
                do {
                    let data = try Data(contentsOf: file)
                    if let cacheItem = try? decoder.decode(CacheItem<AnyCodable>.self, from: data) {
                        if cacheItem.expirationDate < Date() {
                            do {
                                try fileManager.removeItem(at: file)
                            } catch {
                            }
                        }
                    }
                } catch {
                    // If we can't decode it, remove it (corrupted)
                    do {
                        try fileManager.removeItem(at: file)
                    } catch {
                    }
                }
            }
        } catch {
            AppLogger.error("Failed to clear expired cache", log: AppLogger.general, error: error)
        }
    }
    
    // MARK: - Cache Keys
    
    enum CacheKey {
        static let resources = "resources"
        static let events = "events"
        static let news = "news"
        static let communityPosts = "community_posts"
    }
}

// MARK: - Cache Item

private struct CacheItem<T: Codable>: Codable {
    let data: T
    let expirationDate: Date
}

// MARK: - AnyCodable Helper (for clearing expired cache)

private struct AnyCodable: Codable {}

// MARK: - Cache Manager Extension for Specific Types

extension CacheManager {
    /// Caches resources
    func cacheResources(_ resources: [Resource]) {
        cache(resources, key: CacheKey.resources)
    }
    
    /// Retrieves cached resources
    func retrieveResources() -> [Resource]? {
        retrieve(key: CacheKey.resources, type: [Resource].self)
    }
    
    /// Caches events
    func cacheEvents(_ events: [Event]) {
        cache(events, key: CacheKey.events)
    }
    
    /// Retrieves cached events
    func retrieveEvents() -> [Event]? {
        retrieve(key: CacheKey.events, type: [Event].self)
    }
}



