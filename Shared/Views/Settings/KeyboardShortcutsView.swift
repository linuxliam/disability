//
//  KeyboardShortcutsView.swift
//  Disability Advocacy
//
//  Keyboard shortcuts reference view
//

import SwiftUI

struct KeyboardShortcutsView: View {
    @Environment(\.dismiss) var dismiss
    
    let shortcuts: [(category: String, items: [ShortcutItem])] = [
        ("Navigation", [
            ShortcutItem(command: "Search", shortcut: "⌘F", description: "Open search"),
            ShortcutItem(command: "Show Sidebar", shortcut: "⌘⌃S", description: "Toggle sidebar visibility"),
            ShortcutItem(command: "Refresh", shortcut: "⌘R", description: "Refresh current view")
        ]),
        ("File Operations", [
            ShortcutItem(command: "Import Resources", shortcut: "⌘⇧I", description: "Import resources from file"),
            ShortcutItem(command: "Import Events", shortcut: "⌘⌥I", description: "Import events from file"),
            ShortcutItem(command: "Export Resources", shortcut: "⌘⇧E", description: "Export resources to file"),
            ShortcutItem(command: "Export Events", shortcut: "⌘⌥E", description: "Export events to file")
        ]),
        ("Edit", [
            ShortcutItem(command: "Cut", shortcut: "⌘X", description: "Cut selected text"),
            ShortcutItem(command: "Copy", shortcut: "⌘C", description: "Copy selected text"),
            ShortcutItem(command: "Paste", shortcut: "⌘V", description: "Paste from clipboard"),
            ShortcutItem(command: "Select All", shortcut: "⌘A", description: "Select all text")
        ]),
        ("Window", [
            ShortcutItem(command: "Minimize", shortcut: "⌘M", description: "Minimize window"),
            ShortcutItem(command: "Zoom", shortcut: "⌘⌥Z", description: "Zoom window"),
            ShortcutItem(command: "Bring All to Front", shortcut: "", description: "Bring all windows to front")
        ]),
        ("Settings", [
            ShortcutItem(command: "Accessibility Settings", shortcut: "⌘⇧,", description: "Open accessibility settings")
        ]),
        ("Help", [
            ShortcutItem(command: "Help", shortcut: "⌘?", description: "Open help"),
            ShortcutItem(command: "Keyboard Shortcuts", shortcut: "⌘⇧?", description: "Show this window")
        ])
    ]
    
    var body: some View {
        List {
            ForEach(shortcuts, id: \.category) { category in
                Section(category.category) {
                    ForEach(category.items, id: \.command) { item in
                        ShortcutRow(item: item)
                    }
                }
            }
        }
        #if os(iOS)
                #if os(iOS)
        .listStyle(.insetGrouped)
        #else
        .listStyle(.sidebar)
        #endif
        #else
        .listStyle(.inset)
        #endif
        .navigationTitle("Keyboard Shortcuts")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Done") {
                    dismiss()
                }
            }
        }
        #if os(macOS)
        .frame(minWidth: 500, minHeight: 400)
        #endif
    }
}

struct ShortcutItem {
    let command: String
    let shortcut: String
    let description: String
}

struct ShortcutRow: View {
    let item: ShortcutItem
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(item.command)
                    .font(.body)
                    .foregroundStyle(Color.primaryText)
                
                if !item.description.isEmpty {
                    Text(item.description)
                        .font(.caption)
                        .foregroundStyle(Color.secondaryText)
                }
            }
            
            Spacer()
            
            if !item.shortcut.isEmpty {
                Text(item.shortcut)
                    .font(.system(.body, design: .monospaced))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 6))
            }
        }
        .padding(.vertical, 8)
    }
}

