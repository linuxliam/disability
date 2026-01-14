//
//  ContentView.swift
//  Disability Advocacy
//
//  Content View for iOS app using TabView
//

import SwiftUI

@MainActor
struct ContentView: View {
    @Environment(AppState.self) var appState: AppState
    @State private var showOnboarding = !UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @State private var selectedSidebarSection: AppTab? = .home
    
    var body: some View {
        @Bindable var appState = appState
        Group {
            if horizontalSizeClass == .regular {
                NavigationSplitView {
                    SidebarView(selectedSection: $selectedSidebarSection)
                    .navigationSplitViewColumnWidth(min: 250, ideal: 280, max: 350)
                } detail: {
                    NavigationStack {
                        DetailView(selectedSection: selectedSidebarSection ?? .home)
                            .navigationDestinations(appState: appState)
                    }
                }
            } else {
                TabView(selection: $appState.selectedTab) {
                    ForEach(AppTab.iOSVisibleTabs, id: \.self) { tab in
                        NavigationStack(path: path(for: tab)) {
                            view(for: tab)
                                .navigationDestinations(appState: appState)
                        }
                        .tabItem {
                            Label(tab.title, systemImage: tab.icon)
                        }
                        .tag(tab)
                    }
                }
            }
        }
        .tint(.accentColor)
        .appTabBarChrome()
        .sheet(isPresented: $appState.showProfile) {
            NavigationStack {
                ProfileView()
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            AppDismissButton()
                        }
                    }
            }
        }
        .fullScreenCover(isPresented: $showOnboarding) {
            OnboardingView(isPresented: $showOnboarding)
        }
    }
    
    @ViewBuilder
    private func view(for tab: AppTab) -> some View {
        switch tab {
        case .home:
            HomeView()
        case .library, .resources, .advocacy:
            LibraryView()
        case .connect, .community, .events:
            ConnectView()
        case .settings:
            SettingsView()
        case .news:
            NewsView()
        case .dataManagement:
            AdminDashboardView()
        }
    }
    
    private func path(for tab: AppTab) -> Binding<NavigationPath> {
        @Bindable var appState = appState
        switch tab {
        case .home: return $appState.homePath
        case .library, .resources, .advocacy: return $appState.libraryPath
        case .connect, .community, .events: return $appState.connectPath
        case .settings: return $appState.settingsPath
        case .news: return $appState.newsPath
        case .dataManagement: return $appState.adminPath
        }
    }
}


