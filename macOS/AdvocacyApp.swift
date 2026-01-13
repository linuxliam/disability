//
//  AdvocacyApp.swift
//  Disability Advocacy
//
//  App Entry point for macOS
//

import SwiftUI
import SwiftData

@main
@MainActor
struct AdvocacyApp: App {
    @State private var appState = AppState()
    @State private var notificationManager = NotificationManager.shared
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView()
                    .environment(appState)
                    .environment(notificationManager)
                    .tint(.accentColor)

                // Global toast overlay (parity with iOS)
                ToastStack(feedback: appState.feedback)
                    .ignoresSafeArea()
            }
            .frame(minWidth: 1000, minHeight: 700)
            .modelContainer(for: [PersistentResource.self, PersistentEvent.self, PersistentUser.self])
            .task {
                notificationManager.initialize()
                _ = try? await notificationManager.requestAuthorization()
            }
        }
        .windowStyle(.automatic)
        .defaultSize(width: 1200, height: 800)
        .commands {
            AppCommands(appState: appState)
        }
    }
}

struct AppCommands: Commands {
    var appState: AppState
    
    var body: some Commands {
        CommandGroup(replacing: .newItem) {}
        
        CommandGroup(after: .newItem) {
            // Note: Import resources functionality can be added to AppState if needed
            // Button("Import Resources...") {
            //     Task { await appState.importResources() }
            // }
            // .keyboardShortcut("i", modifiers: [.command, .shift])
            
            // Note: Import/Export functionality can be added to AppState if needed
            // Button("Import Events...") {
            //     Task { await appState.importEvents() }
            // }
            // .keyboardShortcut("i", modifiers: [.command, .option])
            
            // Divider()
            
            // Button("Export Resources...") {
            //     Task { await appState.exportResources() }
            // }
            // .keyboardShortcut("e", modifiers: [.command, .shift])
            
            // Button("Export Events...") {
            //     Task { await appState.exportEvents() }
            // }
            // .keyboardShortcut("e", modifiers: [.command, .option])
        }
        
        CommandGroup(replacing: .textEditing) {
            Button("Cut") { NSApp.sendAction(#selector(NSText.cut(_:)), to: nil, from: nil) }
                .keyboardShortcut("x", modifiers: .command)
            Button("Copy") { NSApp.sendAction(#selector(NSText.copy(_:)), to: nil, from: nil) }
                .keyboardShortcut("c", modifiers: .command)
            Button("Paste") { NSApp.sendAction(#selector(NSText.paste(_:)), to: nil, from: nil) }
                .keyboardShortcut("v", modifiers: .command)
            Divider()
            Button("Select All") { NSApp.sendAction(#selector(NSText.selectAll(_:)), to: nil, from: nil) }
                .keyboardShortcut("a", modifiers: .command)
        }
        
        CommandGroup(after: .toolbar) {
            // Note: Sidebar toggle functionality can be added to AppState if needed
            // Button("Show Sidebar") { appState.toggleSidebar() }
            //     .keyboardShortcut("s", modifiers: [.command, .control])
            
            Divider()
            
            Button("Search...") {
                appState.showSearch = true
            }
            .keyboardShortcut("f", modifiers: .command)
            
            Button("Profile") {
                appState.showProfile = true
            }
            .keyboardShortcut(",", modifiers: .command)
        }
        
        CommandGroup(replacing: .help) {
            Button("Advocacy Help") {
                if let url = URL(string: "https://example.com/help") {
                    NSWorkspace.shared.open(url)
                }
            }
            .keyboardShortcut("?", modifiers: .command)
        }
    }
}

