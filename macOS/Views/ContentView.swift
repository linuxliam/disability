//
//  ContentView.swift
//  Disability Advocacy
//
//  Content View for macOS app using NavigationSplitView
//

import SwiftUI

@MainActor
struct ContentView: View {
    @Environment(AppState.self) var appState
    @State private var selectedSection: AppTab? = .home
    
    var body: some View {
        @Bindable var appState = appState
        NavigationSplitView {
            SidebarView(selectedSection: $selectedSection)
                .navigationSplitViewColumnWidth(min: 200, ideal: 240, max: 300)
        } detail: {
            NavigationStack {
                DetailView(selectedSection: selectedSection ?? .home)
                    .navigationDestinations(appState: appState)
            }
        }
        .appScreenBackground()
        .appNavigationChrome()
        .sheet(isPresented: $appState.showAccessibilitySettings) {
            NavigationStack {
                AccessibilitySettingsView()
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            AppDismissButton()
                        }
                    }
            }
            .frame(minWidth: 600, minHeight: 500)
        }
        .sheet(isPresented: $appState.showProfile) {
            NavigationStack {
                ProfileView()
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            AppDismissButton()
                        }
                    }
            }
            .frame(minWidth: 500, minHeight: 400)
        }
        .sheet(isPresented: $appState.showSearch) {
            NavigationStack {
                SearchView()
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            AppDismissButton()
                        }
                    }
            }
        }
        .sheet(isPresented: $appState.showKeyboardShortcuts) {
            NavigationStack {
                KeyboardShortcutsView()
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            AppDismissButton()
                        }
                    }
            }
        }
    }
}


