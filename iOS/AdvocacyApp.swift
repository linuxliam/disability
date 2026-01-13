//
//  AdvocacyApp.swift
//  Disability Advocacy
//
//  App Entry point for iOS
//

import SwiftUI
import SwiftData

@main
struct AdvocacyApp: App {
    @State private var appState = AppState()
    @State private var notificationManager = NotificationManager.shared
    @State private var showLaunchScreen = true
    
    var body: some Scene {
        WindowGroup {
            AppRootView(showLaunchScreen: $showLaunchScreen)
                .environment(appState)
                .environment(notificationManager)
                .modelContainer(for: [PersistentResource.self, PersistentEvent.self, PersistentUser.self])
                .task {
                    notificationManager.initialize()
                    _ = try? await notificationManager.requestAuthorization()
                }
        }
    }
}

struct AppRootView: View {
    @Binding var showLaunchScreen: Bool
    @Environment(\.scenePhase) private var scenePhase
    @Environment(AppState.self) var appState: AppState
    
    var body: some View {
        ZStack {
            if showLaunchScreen {
                LaunchScreenView()
                    .transition(.opacity)
            } else {
                ContentView()
            }
            
            // Global toast overlay
            ToastStack(feedback: appState.feedback)
                .ignoresSafeArea(.keyboard)
        }
        .task {
            if UIAccessibility.isReduceMotionEnabled {
                showLaunchScreen = false
            } else {
                withAnimation(.easeInOut(duration: 0.3)) {
                    showLaunchScreen = false
                }
            }
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            // Handle lifecycle changes
        }
    }
}

