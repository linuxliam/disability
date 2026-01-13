//
//  CacheMock.swift
//  DisabilityAdvocacyTests
//
//  Mock CacheManager for testing
//

import Foundation

/// In-memory cache implementation for testing
class CacheMock {
    private var cache: [String: (data: Data, expiration: Date)] = [:]
    private let queue = DispatchQueue(label: "com.disabilityadvocacy.cachemock", attributes: .concurrent)
    
    /// Cache data with optional expiration
    func cache<T: Codable>(_ object: T, key: String, expirationDate: Date? = nil) {
        queue.async(flags: .barrier) {
            let data = try! JSONEncoder().encode(object)
            let expiration = expirationDate ?? Date.distantFuture
            self.cache[key] = (data: data, expiration: expiration)
        }
    }
    
    /// Retrieve cached data
    func retrieve<T: Codable>(key: String, type: T.Type) -> T? {
        var result: T? = nil
        queue.sync {
            guard let cached = self.cache[key] else {
                return
            }
            
            // Check expiration
            if cached.expiration < Date() {
                self.cache.removeValue(forKey: key)
                return
            }
            
            result = try? JSONDecoder().decode(type, from: cached.data)
        }
        return result
    }
    
    /// Check if key exists and is not expired
    func hasKey(_ key: String) -> Bool {
        var result = false
        queue.sync {
            guard let cached = self.cache[key] else {
                return
            }
            
            if cached.expiration < Date() {
                self.cache.removeValue(forKey: key)
                return
            }
            
            result = true
        }
        return result
    }
    
    /// Clear all cache
    func clearAll() {
        queue.async(flags: .barrier) {
            self.cache.removeAll()
        }
    }
    
    /// Clear expired cache entries
    func clearExpired() {
        queue.async(flags: .barrier) {
            let now = Date()
            self.cache = self.cache.filter { $0.value.expiration >= now }
        }
    }
    
    /// Remove specific key
    func remove(key: String) {
        queue.async(flags: .barrier) {
            self.cache.removeValue(forKey: key)
        }
    }
    
    /// Get all keys
    func allKeys() -> [String] {
        var result: [String] = []
        queue.sync {
            result = Array(self.cache.keys)
        }
        return result
    }
    
    /// Check if cache is empty
    var isEmpty: Bool {
        var result = true
        queue.sync {
            result = self.cache.isEmpty
        }
        return result
    }
}

