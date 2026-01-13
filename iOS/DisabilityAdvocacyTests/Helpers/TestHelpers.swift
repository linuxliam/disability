//
//  TestHelpers.swift
//  DisabilityAdvocacyTests
//
//  Test helper utilities for writing tests
//

import XCTest
import Foundation

/// Async test helpers
extension XCTestCase {
    /// Assert that a condition becomes true within a timeout period
    func XCTAssertEventually(
        _ expression: @autoclosure () throws -> Bool,
        timeout: TimeInterval = 5.0,
        message: @autoclosure () -> String = "Condition did not become true within timeout",
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let expectation = expectation(description: "Async condition")
        let startTime = Date()
        
        Task {
            while Date().timeIntervalSince(startTime) < timeout {
                if let result = try? expression(), result == true {
                    expectation.fulfill()
                    return
                }
                try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: timeout)
        
        do {
            let result = try expression()
            XCTAssertTrue(result, message(), file: file, line: line)
        } catch {
            XCTFail("Error evaluating expression: \(error)", file: file, line: line)
        }
    }
    
    /// Wait for an async operation to complete within a timeout
    func awaitEventually<T>(
        timeout: TimeInterval = 5.0,
        file: StaticString = #filePath,
        line: UInt = #line,
        operation: @escaping () async throws -> T?
    ) async throws -> T {
        let startTime = Date()
        
        while Date().timeIntervalSince(startTime) < timeout {
            if let result = try await operation() {
                return result
            }
            try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        }
        
        XCTFail("Operation did not complete within timeout", file: file, line: line)
        throw TestError.timeout
    }
}

enum TestError: Error {
    case timeout
    case invalidTestData
}

/// Test environment detection
enum TestEnvironment {
    static var isCI: Bool {
        ProcessInfo.processInfo.environment["CI"] != nil ||
        ProcessInfo.processInfo.environment["CONTINUOUS_INTEGRATION"] != nil
    }
    
    static var isRunningInXcode: Bool {
        ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != nil
    }
}

/// Test data cleanup helpers
extension XCTestCase {
    /// Clean up UserDefaults for a specific key
    func cleanupUserDefaults(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    /// Clean up multiple UserDefaults keys
    func cleanupUserDefaults(keys: [String]) {
        keys.forEach { UserDefaults.standard.removeObject(forKey: $0) }
    }
}

