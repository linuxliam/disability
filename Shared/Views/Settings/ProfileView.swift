//
//  ProfileView.swift
//  Disability Advocacy
//
//  User profile management view
//

import SwiftUI
#if os(iOS)
import UIKit
#endif

struct ProfileView: View {
    @Environment(AppState.self) var appState
    @Environment(\.dismiss) var dismiss
    @State private var user: User = User(
        name: "User",
        email: "user@example.com"
    )
    @State private var isEditing = false
    
    var body: some View {
        Form {
            Section {
                headerCard
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
            }

            Section {
                if isEditing {
                    TextField("Name", text: $user.name)
                    #if os(iOS)
                    TextField("Email", text: $user.email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                    #else
                    TextField("Email", text: $user.email)
                    #endif
                } else {
                    LabeledContent("Name", value: user.name)
                    LabeledContent("Email", value: user.email)
                }
            } header: {
                Text(String(localized: "Account"))
            }

            Section {
                Toggle(isOn: $user.notificationPreferences.eventReminders) {
                    Label(String(localized: "Event Reminders"), systemImage: "calendar.badge.clock")
                }
                Toggle(isOn: $user.notificationPreferences.newResources) {
                    Label(String(localized: "New Resources"), systemImage: "book.closed.fill")
                }
                Toggle(isOn: $user.notificationPreferences.communityUpdates) {
                    Label(String(localized: "Community Updates"), systemImage: "person.2.fill")
                }
                Toggle(isOn: $user.notificationPreferences.newsUpdates) {
                    Label(String(localized: "News Updates"), systemImage: "newspaper.fill")
                }
            } header: {
                Text(String(localized: "Notifications"))
            }

            if isEditing {
                Section {
                    Button(role: .destructive) {
                        cancelEditing()
                    } label: {
                        Text(String(localized: "Cancel Changes"))
                            .frame(maxWidth: .infinity)
                    }
                }
            }
        }
        .navigationTitle(String(localized: "Profile"))
        .platformInlineNavigationTitle()
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                if isEditing {
                    Button(String(localized: "Save")) {
                        saveProfile()
                    }
                    .fontWeight(.bold)
                } else {
                    Button(String(localized: "Edit")) {
                        isEditing = true
                    }
                    .fontWeight(.semibold)
                }
            }
        }
        .onAppear {
            loadUserData()
        }
        .appScreenChrome()
    }

    private var headerCard: some View {
        VStack(spacing: LayoutConstants.spacingL) {
            // Avatar
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.triadPrimary, .triadPrimary.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                    .shadow(color: Color.triadPrimary.opacity(0.3), radius: 10, x: 0, y: 5)
                
                Text(user.name.prefix(1).uppercased())
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
            }
            
            VStack(spacing: 6) {
                Text(user.name)
                    .font(.title3.weight(.bold))
                    .foregroundStyle(.primary)
                
                if !user.email.isEmpty {
                    Text(user.email)
                        .secondaryBody()
                }
                
                AppChip(text: "Member", style: .tertiary)
                    .padding(.top, 4)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .background(Color.cardBackground)
        .cornerRadius(LayoutConstants.cardCornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: LayoutConstants.cardCornerRadius)
                .stroke(Color.primary.opacity(0.08), lineWidth: 1)
        )
        .padding(.horizontal, LayoutConstants.screenHorizontalPadding)
    }
    
    private func loadUserData() {
        Task { @MainActor in
            let result = await UserManager.shared.loadUser()
            switch result {
            case .success(let savedUser):
                self.user = savedUser
            case .failure(let error):
                appState.feedback.error(error.localizedDescription)
                AppLogger.error("Failed to load user profile", log: AppLogger.user, error: error)
            }
        }
    }
    
    private func saveProfile() {
        Task { @MainActor in
            let result = await UserManager.shared.saveUser(user)
            switch result {
            case .success:
                appState.feedback.success(String(localized: "Profile updated successfully"))
                isEditing = false
            case .failure(let error):
                appState.feedback.error(error.localizedDescription)
                AppLogger.error("Failed to save user profile", log: AppLogger.user, error: error)
                isEditing = false
            }
        }
    }
    
    private func cancelEditing() {
        // Reload original user data
        Task { @MainActor in
            let result = await UserManager.shared.loadUser()
            switch result {
            case .success(let savedUser):
                self.user = savedUser
            case .failure:
                // Silently fail on cancel - user can reload manually
                break
            }
            isEditing = false
        }
    }
}

