//
//  PlatformUI.swift
//  Disability Advocacy
//
//  Centralized platform-specific UI helpers for iOS + macOS
//

import SwiftUI

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

enum PlatformUI {
    // MARK: - Toolbar placements
    static var trailingToolbarItemPlacement: ToolbarItemPlacement {
        #if os(iOS)
        return .topBarTrailing
        #else
        return .primaryAction
        #endif
    }

    static var leadingToolbarItemPlacement: ToolbarItemPlacement {
        #if os(iOS)
        return .navigationBarLeading
        #else
        return .cancellationAction
        #endif
    }

    // MARK: - Clipboard
    @MainActor
    static func copyToClipboard(_ string: String) {
        #if os(iOS)
        UIPasteboard.general.string = string
        #elseif os(macOS)
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(string, forType: .string)
        #endif
    }

    // MARK: - URLs / Settings
    @MainActor
    static func openSystemSettings() {
        #if os(iOS)
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
        #elseif os(macOS)
        // Best-effort: open System Settings. (Deep-linking to app-specific pages is limited.)
        guard let url = URL(string: "x-apple.systempreferences:") else { return }
        NSWorkspace.shared.open(url)
        #endif
    }

    @MainActor
    static func openURL(_ url: URL) {
        #if os(iOS)
        UIApplication.shared.open(url)
        #elseif os(macOS)
        NSWorkspace.shared.open(url)
        #endif
    }
}

extension View {
    /// Applies iOS-only inline navigation title display mode; no-op on macOS.
    func platformInlineNavigationTitle() -> some View {
        #if os(iOS)
        return self.navigationBarTitleDisplayMode(.inline)
        #else
        return self
        #endif
    }

    /// Applies iOS-only text input defaults (capitalization + submit label); no-op on macOS.
    func platformTextInputDefaults() -> some View {
        #if os(iOS)
        return self
            .textInputAutocapitalization(.never)
            .submitLabel(.next)
        #else
        return self
        #endif
    }
}


