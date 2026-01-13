//
//  AppTheme.swift
//  Disability Advocacy
//
//  Shared design wrappers to keep iOS + macOS visually consistent.
//
//  CONTRACT:
//  1. Root Screens: Use .appScreenChrome() on the top-level View.
//  2. Lists: Use .appListBackground() on List/Form to ensure semantic background.
//  3. Sheets: Wrap sheet content in NavigationStack if they need a toolbar (Done button).
//  4. Detail Views: Use .appScreenChrome() and ensure consistent spacing.

import SwiftUI
#if os(macOS)
import AppKit
#endif

enum AppTheme {
    /// Default maximum content width for wide layouts (iPad/macOS). Override via environment if needed.
    static let defaultContentMaxWidth: CGFloat = 1100

    /// Returns the platform-appropriate grouped background color.
    static var groupedBackgroundColor: Color {
        #if os(iOS)
        return Color.groupedBackground
        #elseif os(macOS)
        // On macOS, use the system grouped background approximation.
        return Color(nsColor: .windowBackgroundColor)
        #else
        return Color.groupedBackground
        #endif
    }
}

private struct ContentMaxWidthKey: EnvironmentKey {
    static let defaultValue: CGFloat = AppTheme.defaultContentMaxWidth
}

extension EnvironmentValues {
    var appContentMaxWidth: CGFloat {
        get { self[ContentMaxWidthKey.self] }
        set { self[ContentMaxWidthKey.self] = newValue }
    }
}

extension View {
    /// Override the default maximum content width for this view subtree.
    @MainActor
    func appContentMaxWidth(_ width: CGFloat) -> some View {
        environment(\.appContentMaxWidth, width)
    }

    /// Standard background used across screens on iOS + macOS.
    /// Ensures content doesn't bleed into the safe area unless it's the background.
    @MainActor
    func appScreenBackground() -> some View {
        self
            .background {
                AppTheme.groupedBackgroundColor.ignoresSafeArea()
            }
    }

    /// Standard content container behavior (centers content on wide macOS windows / iPad landscape).
    /// Used to prevent text lines from becoming too long on desktop.
    @MainActor
    func appContentFrame() -> some View {
        self.modifier(_AppContentFrameModifier())
    }

    /// Standard navigation chrome for parity (material toolbar backgrounds where available).
    @MainActor
    func appNavigationChrome() -> some View {
        #if os(iOS)
        return self
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        #else
        // macOS: keep default toolbar behavior; background comes from appScreenBackground.
        return self
        #endif
    }

    /// Standard tab bar chrome for iOS.
    @MainActor
    func appTabBarChrome() -> some View {
        #if os(iOS)
        return self
            .toolbarBackground(.visible, for: .tabBar)
            .toolbarBackground(.ultraThinMaterial, for: .tabBar)
        #else
        return self
        #endif
    }

    /// Standard top-level chrome for most screens (background + nav chrome + max content width on wide displays).
    @MainActor
    func appScreenChrome() -> some View {
        return self
            .appScreenBackground()
            .appNavigationChrome()
            .appContentFrame()
    }

    /// Standard List styling/background on iOS (hide List's default background and use our grouped background).
    @MainActor
    func appListBackground() -> some View {
        #if os(iOS)
        return self
            .scrollContentBackground(.hidden)
            .background(AppTheme.groupedBackgroundColor)
        #else
        // On macOS, apply our grouped background to keep parity with iOS unless the platform default is desired.
        return self
            .background(AppTheme.groupedBackgroundColor)
        #endif
    }

    @MainActor
    @ViewBuilder
    func navigationDestinations(appState: AppState) -> some View {
        self
            .navigationDestination(for: Resource.self) { resource in
                ResourceDetailView(resource: resource)
            }
            .navigationDestination(for: Event.self) { event in
                EventDetailView(event: event)
            }
            .navigationDestination(for: CommunityPost.self) { post in
                PostDetailView(post: post)
            }
            .navigationDestination(for: NewsArticle.self) { article in
                ArticleDetailView(article: article)
            }
            .navigationDestination(for: DisabilityLaw.self) { law in
                LawDetailView(law: law)
            }
            .navigationDestination(for: SearchResult.self) { result in
                switch result.type {
                case .resource:
                    if let resourceId = result.resourceId,
                       let resource = ResourcesManager.shared.getAllResources().first(where: { $0.id == resourceId }) {
                        ResourceDetailView(resource: resource)
                    } else {
                        Text(String(localized: "Resource not found"))
                    }
                case .event:
                    if let eventId = result.eventId,
                       let event = EventsManager.shared.getAllEvents().first(where: { $0.id == eventId }) {
                        EventDetailView(event: event)
                    } else {
                        Text(String(localized: "Event not found"))
                    }
                case .post:
                    Text(String(localized: "Post detail view not implemented"))
                case .article:
                    Text(String(localized: "Article detail view not implemented"))
                }
            }
            .navigationDestination(for: AppTab.self) { tab in
                switch tab {
                case .resources: ResourcesView()
                case .advocacy: AdvocacyToolsView()
                case .community: CommunityView()
                case .events: EventsView()
                case .news: NewsView()
                case .library: LibraryView()
                case .connect: ConnectView()
                case .settings: SettingsView()
                case .home: HomeView()
                case .dataManagement: AdminDashboardView()
                }
            }
            .navigationDestination(for: AppDestination.self) { destination in
                switch destination {
                case .search: SearchView()
                case .profile: ProfileView()
                case .accessibility: AccessibilitySettingsView()
                case .letterGenerator: LetterTemplateView()
                case .rightsKnowledgeBase: RightsKnowledgeBaseView()
                }
            }
            .navigationDestination(for: AdvocacyTool.self) { tool in
                switch tool.title {
                case "Letter Template Generator":
                    LetterTemplateView()
                case "Rights Knowledge Base":
                    RightsKnowledgeBaseView()
                default:
                    ToolDetailView(tool: tool)
                }
            }
    }
}

private struct _AppContentFrameModifier: ViewModifier {
    @Environment(\.appContentMaxWidth) private var maxWidth

    func body(content: Content) -> some View {
        content
            .frame(maxWidth: maxWidth, alignment: .center)
    }
}

