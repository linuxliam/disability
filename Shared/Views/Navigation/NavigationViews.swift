//
//  NavigationViews.swift
//  Disability Advocacy
//
//  Primary navigation views for Library, Connect, Settings, and Sidebar.
//

import SwiftUI

// MARK: - Library View
struct LibraryView: View {
    @Environment(AppState.self) var appState
    
    var body: some View {
        Group {
            #if os(macOS)
            GeometryReader { geometry in
                ScrollView {
                    VStack(alignment: .leading, spacing: LayoutConstants.sectionGap) {
                        VStack(alignment: .leading, spacing: LayoutConstants.sectionHeaderSpacing) {
                            AppSectionHeader(title: "Information & Tools", systemImage: "info.circle.fill")
                                .tint(.triadPrimary)
                            
                            LazyVGrid(columns: AdaptiveLayout.gridColumns(for: .regular, availableWidth: geometry.size.width), spacing: LayoutConstants.cardGap) {
                                AppNavigationGridCard(
                                    title: String(localized: "Resources"),
                                    subtitle: String(localized: "Browse our extensive library of disability resources"),
                                    icon: "book.fill",
                                    iconColor: .triadPrimary,
                                    value: AppTab.resources
                                )
                                
                                AppNavigationGridCard(
                                    title: String(localized: "Advocacy Tools"),
                                    subtitle: String(localized: "Tools to help you advocate for yourself and others"),
                                    icon: "megaphone.fill",
                                    iconColor: .triadPrimary,
                                    value: AppTab.advocacy
                                )
                                
                                AppNavigationGridCard(
                                    title: String(localized: "Rights Knowledge Base"),
                                    subtitle: String(localized: "Learn about your legal rights and protections"),
                                    icon: "shield.fill",
                                    iconColor: .triadPrimary,
                                    value: AppDestination.rightsKnowledgeBase
                                )
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: LayoutConstants.sectionHeaderSpacing) {
                            AppSectionHeader(title: "Discovery", systemImage: "magnifyingglass")
                                .tint(.triadSecondary)
                            
                            LazyVGrid(columns: AdaptiveLayout.gridColumns(for: .regular, availableWidth: geometry.size.width), spacing: LayoutConstants.cardGap) {
                                AppNavigationGridCard(
                                    title: String(localized: "Search Library"),
                                    subtitle: String(localized: "Search for specific topics or organizations"),
                                    icon: "magnifyingglass",
                                    iconColor: .triadSecondary,
                                    value: AppDestination.search
                                )
                            }
                        }
                    }
                    .adaptiveContentFrame()
                    .padding(.top, LayoutConstants.paddingM)
                    .padding(.bottom, LayoutConstants.paddingXXL)
                }
            }
            #else
            List {
                Section {
                    NavigationLink(value: AppTab.resources) {
                        Label(String(localized: "Resources"), systemImage: "book.fill")
                    }
                    NavigationLink(value: AppTab.advocacy) {
                        Label(String(localized: "Advocacy Tools"), systemImage: "megaphone.fill")
                    }
                    NavigationLink(value: AppDestination.rightsKnowledgeBase) {
                        Label(String(localized: "Rights Knowledge Base"), systemImage: "shield.fill")
                    }
                } header: {
                    AppSectionHeader(title: "Information & Tools", systemImage: "info.circle.fill")
                        .tint(.triadPrimary)
                }
                
                Section {
                    NavigationLink(value: AppDestination.search) {
                        Label(String(localized: "Search Library"), systemImage: "magnifyingglass")
                    }
                } header: {
                    AppSectionHeader(title: "Discovery", systemImage: "magnifyingglass")
                        .tint(.triadSecondary)
                }
            }
                    #if os(iOS)
        .listStyle(.insetGrouped)
        #else
        .listStyle(.sidebar)
        #endif
            #endif
        }
        .appListBackground()
        .navigationTitle(String(localized: "Library"))
        .platformInlineNavigationTitle()
        .toolbar {
            ToolbarItem(placement: PlatformUI.trailingToolbarItemPlacement) {
                ProfileToolbarButton()
            }
        }
        .appScreenChrome()
    }
}

// MARK: - Connect View
struct ConnectView: View {
    @Environment(AppState.self) var appState
    
    var body: some View {
        Group {
            #if os(macOS)
            GeometryReader { geometry in
                ScrollView {
                    VStack(alignment: .leading, spacing: LayoutConstants.sectionGap) {
                        VStack(alignment: .leading, spacing: LayoutConstants.sectionHeaderSpacing) {
                            AppSectionHeader(title: "Social", systemImage: "person.2.fill")
                                .tint(.triadTertiary)
                            
                            LazyVGrid(columns: AdaptiveLayout.gridColumns(for: .regular, availableWidth: geometry.size.width), spacing: LayoutConstants.cardGap) {
                                AppNavigationGridCard(
                                    title: String(localized: "Community Forum"),
                                    subtitle: String(localized: "Connect with the community and share experiences"),
                                    icon: "person.3.fill",
                                    iconColor: .triadTertiary,
                                    value: AppTab.community
                                )
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: LayoutConstants.sectionHeaderSpacing) {
                            AppSectionHeader(title: "Activity", systemImage: "bolt.fill")
                                .tint(.triadPrimary)
                            
                            LazyVGrid(columns: AdaptiveLayout.gridColumns(for: .regular, availableWidth: geometry.size.width), spacing: LayoutConstants.cardGap) {
                                AppNavigationGridCard(
                                    title: String(localized: "Upcoming Events"),
                                    subtitle: String(localized: "Stay updated on local and virtual events"),
                                    icon: "calendar",
                                    iconColor: .triadPrimary,
                                    value: AppTab.events
                                )
                            }
                        }
                    }
                    .adaptiveContentFrame()
                    .padding(.top, LayoutConstants.paddingM)
                    .padding(.bottom, LayoutConstants.paddingXXL)
                }
            }
            #else
            List {
                Section {
                    NavigationLink(value: AppTab.community) {
                        Label(String(localized: "Community Forum"), systemImage: "person.3.fill")
                    }
                } header: {
                    AppSectionHeader(title: "Social", systemImage: "person.2.fill")
                        .tint(.triadTertiary)
                }
                
                Section {
                    NavigationLink(value: AppTab.events) {
                        Label(String(localized: "Upcoming Events"), systemImage: "calendar")
                    }
                } header: {
                    AppSectionHeader(title: "Activity", systemImage: "bolt.fill")
                        .tint(.triadPrimary)
                }
            }
                    #if os(iOS)
        .listStyle(.insetGrouped)
        #else
        .listStyle(.sidebar)
        #endif
            #endif
        }
        .appListBackground()
        .navigationTitle(String(localized: "Connect"))
        .platformInlineNavigationTitle()
        .toolbar {
            ToolbarItem(placement: PlatformUI.trailingToolbarItemPlacement) {
                ProfileToolbarButton()
            }
        }
        .appScreenChrome()
    }
}

// MARK: - Settings View
struct SettingsView: View {
    @Environment(AppState.self) var appState
    
    var body: some View {
        @Bindable var appState = appState
        Group {
            #if os(macOS)
            GeometryReader { geometry in
                ScrollView {
                    VStack(alignment: .leading, spacing: LayoutConstants.sectionGap) {
                        VStack(alignment: .leading, spacing: LayoutConstants.sectionHeaderSpacing) {
                            AppSectionHeader(title: "Account", systemImage: "person.fill")
                                .tint(.triadSecondary)
                            
                            LazyVGrid(columns: AdaptiveLayout.gridColumns(for: .regular, availableWidth: geometry.size.width), spacing: LayoutConstants.cardGap) {
                                AppNavigationGridCard(
                                    title: String(localized: "My Profile"),
                                    subtitle: String(localized: "Manage your personal information and preferences"),
                                    icon: "person.circle.fill",
                                    iconColor: .triadSecondary,
                                    value: AppDestination.profile
                                )
                                
                                AppNavigationGridCard(
                                    title: String(localized: "My Favorites"),
                                    subtitle: String(localized: "Access your bookmarked resources and tools"),
                                    icon: "heart.fill",
                                    iconColor: .triadSecondary,
                                    value: AppTab.resources
                                )
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: LayoutConstants.sectionHeaderSpacing) {
                            AppSectionHeader(title: "Preferences", systemImage: "slider.horizontal.3")
                                .tint(.triadTertiary)
                            
                            LazyVGrid(columns: AdaptiveLayout.gridColumns(for: .regular, availableWidth: geometry.size.width), spacing: LayoutConstants.cardGap) {
                                AppNavigationGridCard(
                                    title: String(localized: "Accessibility"),
                                    subtitle: String(localized: "Customize your app experience for better accessibility"),
                                    icon: "accessibility",
                                    iconColor: .triadTertiary,
                                    value: AppDestination.accessibility
                                )
                                
                                Button(action: {
                                    PlatformUI.openSystemSettings()
                                }) {
                                    AppGridCard(minHeight: 140) {
                                        VStack(alignment: .leading, spacing: LayoutConstants.spacingM) {
                                            Image(systemName: "bell.fill")
                                                .font(.title2.weight(.bold))
                                                .foregroundStyle(.triadTertiary)
                                                .frame(width: 44, height: 44)
                                                .background(Color.triadTertiary.opacity(0.1))
                                                .cornerRadius(12)
                                            
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(String(localized: "Notifications"))
                                                    .font(.headline.weight(.bold))
                                                    .foregroundStyle(.primary)
                                                
                                                Text(String(localized: "Manage system notification settings"))
                                                    .font(.caption)
                                                    .foregroundStyle(Color.secondaryText)
                                                    .lineLimit(2)
                                            }
                                            
                                            Spacer(minLength: 0)
                                            
                                            HStack {
                                                Spacer()
                                                Image(systemName: "arrow.up.forward.app")
                                                    .font(.caption2.weight(.bold))
                                                    .foregroundStyle(Color.tertiaryText)
                                            }
                                        }
                                    }
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: LayoutConstants.sectionHeaderSpacing) {
                            AppSectionHeader(title: "Data Management", systemImage: "database.fill")
                                .tint(.triadPrimary)
                            
                            LazyVGrid(columns: AdaptiveLayout.gridColumns(for: .regular, availableWidth: geometry.size.width), spacing: LayoutConstants.cardGap) {
                                AppNavigationGridCard(
                                    title: String(localized: "Admin Dashboard"),
                                    subtitle: String(localized: "Manage resources and event data locally"),
                                    icon: "lock.shield.fill",
                                    iconColor: .triadPrimary,
                                    value: AppTab.dataManagement
                                )
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: LayoutConstants.sectionHeaderSpacing) {
                            AppSectionHeader(title: "Information", systemImage: "info.bubble.fill")
                                .tint(.triadPrimary)
                            
                            LazyVGrid(columns: AdaptiveLayout.gridColumns(for: .regular, availableWidth: geometry.size.width), spacing: LayoutConstants.cardGap) {
                                AppNavigationGridCard(
                                    title: String(localized: "News & Updates"),
                                    subtitle: String(localized: "Stay informed with the latest disability news"),
                                    icon: "newspaper.fill",
                                    iconColor: .triadPrimary,
                                    value: AppTab.news
                                )
                                
                                Button(action: {
                                    if let url = URL(string: "https://www.disability.gov") {
                                        PlatformUI.openURL(url)
                                    }
                                }) {
                                    AppGridCard(minHeight: 140) {
                                        VStack(alignment: .leading, spacing: LayoutConstants.spacingM) {
                                            Image(systemName: "questionmark.circle.fill")
                                                .font(.title2.weight(.bold))
                                                .foregroundStyle(.triadPrimary)
                                                .frame(width: 44, height: 44)
                                                .background(Color.triadPrimary.opacity(0.1))
                                                .cornerRadius(12)
                                            
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(String(localized: "Help & Support"))
                                                    .font(.headline.weight(.bold))
                                                    .foregroundStyle(.primary)
                                                
                                                Text(String(localized: "External resources and governmental support"))
                                                    .font(.caption)
                                                    .foregroundStyle(Color.secondaryText)
                                                    .lineLimit(2)
                                            }
                                            
                                            Spacer(minLength: 0)
                                            
                                            HStack {
                                                Spacer()
                                                Image(systemName: "safari.fill")
                                                    .font(.caption2.weight(.bold))
                                                    .foregroundStyle(Color.tertiaryText)
                                            }
                                        }
                                    }
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .adaptiveContentFrame()
                    .padding(.top, LayoutConstants.paddingM)
                    .padding(.bottom, LayoutConstants.paddingXXL)
                }
            }
            #else
            List {
                Section {
                    NavigationLink(value: AppDestination.profile) {
                        Label(String(localized: "My Profile"), systemImage: "person.circle.fill")
                    }
                    NavigationLink(value: AppTab.resources) { // Shows favorites within resources list
                        Label(String(localized: "My Favorites"), systemImage: "heart.fill")
                    }
                } header: {
                    AppSectionHeader(title: "Account", systemImage: "person.fill")
                        .tint(.triadSecondary)
                }
                
                Section {
                    NavigationLink(value: AppDestination.accessibility) {
                        Label(String(localized: "Accessibility"), systemImage: "accessibility")
                    }
                    Button(action: {
                        PlatformUI.openSystemSettings()
                    }) {
                        Label(String(localized: "Notifications"), systemImage: "bell.fill")
                    }
                } header: {
                    AppSectionHeader(title: "Preferences", systemImage: "slider.horizontal.3")
                        .tint(.triadTertiary)
                }
                
                Section {
                    NavigationLink(value: AppTab.dataManagement) {
                        Label(String(localized: "Admin Dashboard"), systemImage: "lock.shield.fill")
                    }
                } header: {
                    AppSectionHeader(title: "Data Management", systemImage: "database.fill")
                        .tint(.triadPrimary)
                }
                
                Section {
                    NavigationLink(value: AppTab.news) {
                        Label(String(localized: "News & Updates"), systemImage: "newspaper.fill")
                    }
                    Button(action: {
                        if let url = URL(string: "https://www.disability.gov") {
                            PlatformUI.openURL(url)
                        }
                    }) {
                        Label(String(localized: "Help & Support"), systemImage: "questionmark.circle.fill")
                    }
                } header: {
                    AppSectionHeader(title: "Information", systemImage: "info.bubble.fill")
                        .tint(.triadPrimary)
                }
            }
                    #if os(iOS)
        .listStyle(.insetGrouped)
        #else
        .listStyle(.sidebar)
        #endif
            #endif
        }
        .appListBackground()
        .navigationTitle(String(localized: "Settings"))
        .platformInlineNavigationTitle()
        .toolbar {
            ToolbarItem(placement: PlatformUI.trailingToolbarItemPlacement) {
                ProfileToolbarButton()
            }
        }
        .appScreenChrome()
    }
}

// MARK: - Sidebar View
struct SidebarView: View {
    @Binding var selectedSection: AppTab?

    var body: some View {
        List(selection: $selectedSection) {
            Section(String(localized: "Discovery")) {
                NavigationLink(value: AppTab.home) {
                    Label(AppTab.home.title, systemImage: AppTab.home.icon)
                }
                NavigationLink(value: AppTab.news) {
                    Label(AppTab.news.title, systemImage: AppTab.news.icon)
                }
            }
            
            Section(String(localized: "Library")) {
                NavigationLink(value: AppTab.library) {
                    Label(AppTab.library.title, systemImage: AppTab.library.icon)
                }
                NavigationLink(value: AppTab.resources) {
                    Label(AppTab.resources.title, systemImage: AppTab.resources.icon)
                }
                NavigationLink(value: AppTab.advocacy) {
                    Label(AppTab.advocacy.title, systemImage: AppTab.advocacy.icon)
                }
            }
            
            Section(String(localized: "Activity")) {
                NavigationLink(value: AppTab.connect) {
                    Label(AppTab.connect.title, systemImage: AppTab.connect.icon)
                }
                NavigationLink(value: AppTab.community) {
                    Label(AppTab.community.title, systemImage: AppTab.community.icon)
                }
                NavigationLink(value: AppTab.events) {
                    Label(AppTab.events.title, systemImage: AppTab.events.icon)
                }
            }
            
            Section(String(localized: "Preferences")) {
                NavigationLink(value: AppTab.settings) {
                    Label(AppTab.settings.title, systemImage: AppTab.settings.icon)
                }
            }
        }
        .listStyle(.sidebar)
        .navigationTitle(String(localized: "Advocacy"))
    }
}
