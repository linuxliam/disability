//
//  TestConfiguration.swift
//  DisabilityAdvocacyTests
//
//  Test configuration and environment settings
//

import Foundation

/// Test configuration for managing test environment settings
struct TestConfiguration {
    /// Test environment detection
    static var isCI: Bool {
        ProcessInfo.processInfo.environment["CI"] != nil ||
        ProcessInfo.processInfo.environment["CONTINUOUS_INTEGRATION"] != nil
    }
    
    /// Test data configuration
    struct TestData {
        /// Use test data instead of real data
        static var useTestData: Bool = true
        
        /// Test data timeout
        static var timeout: TimeInterval = 5.0
    }
    
    /// Mock service configuration
    struct MockServices {
        /// Enable network mocking
        static var enableNetworkMock: Bool = true
        
        /// Enable cache mocking
        static var enableCacheMock: Bool = true
        
        /// Enable notification mocking
        static var enableNotificationMock: Bool = true
    }
    
    /// Test execution settings
    struct Execution {
        /// Run tests in parallel
        static var parallelExecution: Bool = true
        
        /// Maximum test execution time (in seconds)
        static var maxExecutionTime: TimeInterval = 300.0 // 5 minutes
    }
    
    /// Get environment variable value
    static func environmentVariable(_ key: String) -> String? {
        ProcessInfo.processInfo.environment[key]
    }
    
    /// Set environment variable for tests (affects current process only)
    static func setEnvironmentVariable(_ key: String, value: String) {
        setenv(key, value, 1)
    }
}


