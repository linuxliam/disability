//
//  AdminDashboardView.swift
//  Disability Advocacy
//
//  Administrator dashboard for content management and developer tools.
//

import SwiftUI

struct AdminDashboardView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    var body: some View {
        Group {
            #if os(macOS)
            GeometryReader { geometry in
                ScrollView {
                    VStack(alignment: .leading, spacing: LayoutConstants.sectionGap) {
                        VStack(alignment: .leading, spacing: LayoutConstants.sectionHeaderSpacing) {
                            AppSectionHeader(
                                title: "Content Management",
                                systemImage: "pencil.and.outline",
                                subtitle: "Add, edit, or delete resource and event entries"
                            )
                            .tint(.triadPrimary)
                            
                            LazyVGrid(columns: AdaptiveLayout.gridColumns(for: .regular, availableWidth: geometry.size.width), spacing: LayoutConstants.cardGap) {
                                AppNavigationGridCard(
                                    title: String(localized: "Manage Resources"),
                                    subtitle: String(localized: "Maintain the library of disability resources"),
                                    icon: "book.closed.fill",
                                    iconColor: .triadPrimary,
                                    value: AdminDestination.manageResources
                                )
                                
                                AppNavigationGridCard(
                                    title: String(localized: "Manage Events"),
                                    subtitle: String(localized: "Update the upcoming events calendar"),
                                    icon: "calendar.badge.plus",
                                    iconColor: .triadPrimary,
                                    value: AdminDestination.manageEvents
                                )
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: LayoutConstants.sectionHeaderSpacing) {
                            AppSectionHeader(
                                title: "Developer Tools",
                                systemImage: "hammer.fill",
                                subtitle: "Export local changes back to project source"
                            )
                            .tint(.triadSecondary)
                            
                            DataExportView()
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
                    NavigationLink(value: AdminDestination.manageResources) {
                        Label {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(String(localized: "Manage Resources"))
                                    .font(.headline)
                                Text(String(localized: "Add, edit, or delete resource entries"))
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        } icon: {
                            Image(systemName: "book.closed.fill")
                                .foregroundStyle(.triadPrimary)
                        }
                    }
                    
                    NavigationLink(value: AdminDestination.manageEvents) {
                        Label {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(String(localized: "Manage Events"))
                                    .font(.headline)
                                Text(String(localized: "Add, edit, or delete event listings"))
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        } icon: {
                            Image(systemName: "calendar.badge.plus")
                                .foregroundStyle(.triadPrimary)
                        }
                    }
                } header: {
                    AppSectionHeader(title: "Content Management", systemImage: "pencil.and.outline")
                        .tint(.triadPrimary)
                } footer: {
                    Text(String(localized: "Changes are saved locally to the Documents directory."))
                }
                
                Section {
                    DataExportView()
                } header: {
                    AppSectionHeader(title: "Developer Tools", systemImage: "hammer.fill")
                        .tint(.triadSecondary)
                } footer: {
                    Text(String(localized: "Export local changes back to the project source files."))
                }
            }
            .listStyle(.insetGrouped)
            #endif
        }
        .appListBackground()
        .navigationTitle(String(localized: "Admin Dashboard"))
        .platformInlineNavigationTitle()
        .navigationDestination(for: AdminDestination.self) { destination in
            switch destination {
            case .manageResources: ManageResourcesView()
            case .manageEvents: ManageEventsView()
            }
        }
    }
}

enum AdminDestination: Hashable {
    case manageResources
    case manageEvents
}
