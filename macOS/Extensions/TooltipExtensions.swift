//
//  TooltipExtensions.swift
//  Disability Advocacy
//
//  Tooltip and help text support
//

import SwiftUI

extension View {
    /// Adds a tooltip with keyboard shortcut hint
    func helpTooltip(_ text: String, shortcut: String? = nil) -> some View {
        self.help(shortcut.map { "\(text) (\($0))" } ?? text)
    }
    
    /// Adds a tooltip with standard macOS formatting
    func standardTooltip(_ text: String) -> some View {
        self.help(text)
    }
}

