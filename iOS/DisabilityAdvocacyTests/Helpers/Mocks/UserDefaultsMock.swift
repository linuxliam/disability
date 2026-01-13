//
//  UserDefaultsMock.swift
//  DisabilityAdvocacyTests
//
//  Mock UserDefaults for isolated testing
//

import Foundation

/// In-memory UserDefaults implementation for testing
class UserDefaultsMock: UserDefaults {
    private var storage: [String: Any] = [:]
    private let queue = DispatchQueue(label: "com.disabilityadvocacy.userdefaultsmock", attributes: .concurrent)
    
    init() {
        // Use a unique suite name for test isolation
        super.init(suiteName: "com.disabilityadvocacy.testuserdefaults")!
    }
    
    override func set(_ value: Any?, forKey defaultName: String) {
        queue.async(flags: .barrier) {
            if let value = value {
                self.storage[defaultName] = value
            } else {
                self.storage.removeValue(forKey: defaultName)
            }
        }
    }
    
    override func object(forKey defaultName: String) -> Any? {
        var result: Any? = nil
        queue.sync {
            result = self.storage[defaultName]
        }
        return result
    }
    
    override func string(forKey defaultName: String) -> String? {
        return object(forKey: defaultName) as? String
    }
    
    override func array(forKey defaultName: String) -> [Any]? {
        return object(forKey: defaultName) as? [Any]
    }
    
    override func dictionary(forKey defaultName: String) -> [String: Any]? {
        return object(forKey: defaultName) as? [String: Any]
    }
    
    override func data(forKey defaultName: String) -> Data? {
        return object(forKey: defaultName) as? Data
    }
    
    override func stringArray(forKey defaultName: String) -> [String]? {
        return object(forKey: defaultName) as? [String]
    }
    
    override func integer(forKey defaultName: String) -> Int {
        return object(forKey: defaultName) as? Int ?? 0
    }
    
    override func float(forKey defaultName: String) -> Float {
        return object(forKey: defaultName) as? Float ?? 0.0
    }
    
    override func double(forKey defaultName: String) -> Double {
        return object(forKey: defaultName) as? Double ?? 0.0
    }
    
    override func bool(forKey defaultName: String) -> Bool {
        return object(forKey: defaultName) as? Bool ?? false
    }
    
    override func url(forKey defaultName: String) -> URL? {
        return object(forKey: defaultName) as? URL
    }
    
    override func removeObject(forKey defaultName: String) {
        queue.async(flags: .barrier) {
            self.storage.removeValue(forKey: defaultName)
        }
    }
    
    override func synchronize() -> Bool {
        return true
    }
    
    /// Clear all stored values
    func clearAll() {
        queue.async(flags: .barrier) {
            self.storage.removeAll()
        }
    }
    
    /// Get all keys
    var allKeys: [String] {
        var result: [String] = []
        queue.sync {
            result = Array(self.storage.keys)
        }
        return result
    }
    
    /// Check if key exists
    func hasKey(_ key: String) -> Bool {
        var result = false
        queue.sync {
            result = self.storage[key] != nil
        }
        return result
    }
}

