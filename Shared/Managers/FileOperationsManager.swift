//
//  FileOperationsManager.swift
//  Disability Advocacy
//
//  Universal file operations for iOS and macOS
//

import Foundation
import UniformTypeIdentifiers

#if os(macOS)
import AppKit
#endif

@MainActor
class FileOperationsManager {
    static let shared = FileOperationsManager()
    
    private init() {}
    
    // MARK: - Import Resources
    
    func importResources() async -> [Resource]? {
        #if os(macOS)
        return await importJSONFile(
            title: "Import Resources",
            message: "Select a JSON file containing resources",
            allowedContentTypes: [.json, .text],
            decodeAs: [Resource].self
        )
        #else
        return nil
        #endif
    }
    
    // MARK: - Import Events
    
    func importEvents() async -> [Event]? {
        #if os(macOS)
        return await importJSONFile(
            title: "Import Events",
            message: "Select a JSON file containing events",
            allowedContentTypes: [.json, .text],
            decodeAs: [Event].self
        )
        #else
        return nil
        #endif
    }
    
    // MARK: - Export Resources
    
    func exportResources(_ resources: [Resource]) async -> Bool {
        #if os(macOS)
        return await exportJSONFile(
            resources,
            title: "Export Resources",
            filenamePrefix: "Resources",
            message: "Save resources to a JSON file"
        )
        #else
        return false
        #endif
    }
    
    // MARK: - Export Events
    
    func exportEvents(_ events: [Event]) async -> Bool {
        #if os(macOS)
        return await exportJSONFile(
            events,
            title: "Export Events",
            filenamePrefix: "Events",
            message: "Save events to a JSON file"
        )
        #else
        return false
        #endif
    }
    
    // MARK: - Helper Methods

    #if os(macOS)
    private func importJSONFile<T: Decodable>(
        title: String,
        message: String,
        allowedContentTypes: [UTType],
        decodeAs type: T.Type
    ) async -> T? {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.canChooseFiles = true
        panel.allowedContentTypes = allowedContentTypes
        panel.title = title
        panel.message = message

        guard await beginPanelAsync(panel) == .OK else {
            return nil
        }

        guard let url = panel.url,
              let data = try? Data(contentsOf: url) else {
            return nil
        }

        return decode(type, from: data, context: title)
    }

    private func exportJSONFile<T: Encodable>(
        _ value: T,
        title: String,
        filenamePrefix: String,
        message: String
    ) async -> Bool {
        let panel = NSSavePanel()
        panel.allowedContentTypes = [.json]
        panel.title = title
        panel.nameFieldStringValue = "\(filenamePrefix)_\(Date().formatted(date: .numeric, time: .omitted))"
        panel.message = message

        guard await beginPanelAsync(panel) == .OK else {
            return false
        }

        guard let url = panel.url else {
            return false
        }

        return encodeAndWrite(value, to: url)
    }
    #endif

    private func decode<T: Decodable>(_ type: T.Type, from data: Data, context: String) -> T? {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        do {
            return try decoder.decode(type, from: data)
        } catch {
            return nil
        }
    }
    
    private func encodeAndWrite<T: Encodable>(_ value: T, to url: URL) -> Bool {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        
        do {
            let data = try encoder.encode(value)
            try data.write(to: url)
            return true
        } catch {
            return false
        }
    }
}

#if os(macOS)
// MARK: - NSPanel Async Extension Helper

private func beginPanelAsync(_ panel: NSPanel) async -> NSApplication.ModalResponse {
    await withCheckedContinuation { continuation in
        MainActor.assumeIsolated {
            if let openPanel = panel as? NSOpenPanel {
                openPanel.begin { response in
                    continuation.resume(returning: response)
                }
            } else if let savePanel = panel as? NSSavePanel {
                savePanel.begin { response in
                    continuation.resume(returning: response)
                }
            } else {
                continuation.resume(returning: .cancel)
            }
        }
    }
}
#endif


