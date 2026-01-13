//
//  StringExtensions.swift
//  Disability Advocacy iOS
//
//  String formatting and utility extensions
//

import Foundation

extension String {
    /// Returns a localized string using String(localized:)
    var localized: String {
        String(localized: String.LocalizationValue(self))
    }
    
    /// Capitalizes first letter only
    var capitalizedFirst: String {
        guard !isEmpty else { return self }
        return prefix(1).uppercased() + dropFirst()
    }
    
    /// Truncates string to specified length with ellipsis
    func truncated(to length: Int) -> String {
        guard count > length else { return self }
        return String(prefix(length)) + "..."
    }
    
    /// Removes whitespace and newlines
    var trimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /// Checks if string is a valid URL
    var isValidURL: Bool {
        URL(string: self) != nil
    }
    
    /// Converts string to URL if valid
    var asURL: URL? {
        URL(string: self)
    }
}

