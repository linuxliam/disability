//
//  UserManager.swift
//  Disability Advocacy
//
//  Unified User Manager for iOS and macOS
//

import Foundation

import Observation

@MainActor
@Observable
class UserManager {
    static let shared = UserManager()
    private let userDefaultsKey = "savedUserProfile"
    
    var currentUser: User?
    
    private init() {
        Task {
            let result = await loadUser()
            if case .success(let user) = result {
                self.currentUser = user
            }
        }
    }
    
    /// Saves user profile data
    func saveUser(_ user: User) async -> Result<Void, AppError> {
        do {
            let encoded = try JSONEncoder().encode(user)
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
            self.currentUser = user
            AppLogger.info("User profile saved successfully", log: AppLogger.user)
            return .success(())
        } catch {
            let appError = AppError.userSaveFailed(error)
            AppLogger.error("Failed to save user profile", log: AppLogger.user, error: error)
            return .failure(appError)
        }
    }
    
    /// Loads user profile data
    func loadUser() async -> Result<User, AppError> {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey) else {
            AppLogger.debug("No saved user profile found", log: AppLogger.user)
            return .failure(.userLoadFailed(NSError(domain: "UserManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "No saved profile found"])))
        }
        
        do {
            let user = try JSONDecoder().decode(User.self, from: data)
            AppLogger.info("User profile loaded successfully", log: AppLogger.user)
            return .success(user)
        } catch {
            let appError = AppError.userDecodeFailed(error)
            AppLogger.error("Failed to decode user profile", log: AppLogger.user, error: error)
            UserDefaults.standard.removeObject(forKey: userDefaultsKey)
            return .failure(appError)
        }
    }
    
    /// Deletes user profile data
    func deleteUser() async {
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
        self.currentUser = nil
        AppLogger.info("User profile deleted", log: AppLogger.user)
    }
}


