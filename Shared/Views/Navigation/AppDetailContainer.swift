//
//  AppDetailContainer.swift
//  Disability Advocacy
//
//  Central detail view switcher for the application's navigation.
//

import SwiftUI

struct DetailView: View {
    let selectedSection: AppTab

    var body: some View {
        Group {
            switch selectedSection {
            case .home:
                HomeView()
            case .news:
                NewsView()
            case .library:
                LibraryView()
            case .resources:
                ResourcesView()
            case .advocacy:
                AdvocacyToolsView()
            case .connect:
                ConnectView()
            case .community:
                CommunityView()
            case .events:
                EventsView()
            case .settings:
                SettingsView()
            case .dataManagement:
                AdminDashboardView()
            }
        }
    }
}
