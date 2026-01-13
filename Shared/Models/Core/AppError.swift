//
//  AppError.swift
//  Disability Advocacy
//
//  Custom error types for better error handling
//

import Foundation

enum AppError: LocalizedError, Equatable {
    case dataLoadingFailed
    case networkError(String)
    case decodingError(String)
    case persistenceError(String)
    case calendarAccessDenied
    case invalidURL(String)
    case userSaveFailed(Error)
    case userLoadFailed(Error)
    case userDecodeFailed(Error)
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .dataLoadingFailed:
            return "Failed to load data. Please try again."
        case .networkError(let message):
            return "Network error: \(message)"
        case .decodingError(let message):
            return "Data format error: \(message)"
        case .persistenceError(let message):
            return "Failed to save data: \(message)"
        case .calendarAccessDenied:
            return "Calendar access is required to add events. Please enable access in System Settings."
        case .invalidURL(let url):
            return "Invalid URL: \(url)"
        case .userSaveFailed(let error):
            return "Failed to save profile: \(error.localizedDescription)"
        case .userLoadFailed(let error):
            return "Failed to load profile: \(error.localizedDescription)"
        case .userDecodeFailed(let error):
            return "Profile data is corrupted: \(error.localizedDescription)"
        case .unknown(let error):
            return "An unexpected error occurred: \(error.localizedDescription)"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .dataLoadingFailed, .networkError:
            return "Please check your internet connection and try again."
        case .calendarAccessDenied:
            return "Go to System Settings > Privacy & Security > Calendars to enable access."
        case .persistenceError:
            return "Please ensure you have sufficient storage space."
        case .userSaveFailed:
            return "Please ensure you have sufficient storage space."
        case .userLoadFailed, .userDecodeFailed:
            return "Try recreating your profile in the Profile settings."
        default:
            return "If the problem persists, please contact support."
        }
    }
    
    static func == (lhs: AppError, rhs: AppError) -> Bool {
        switch (lhs, rhs) {
        case (.dataLoadingFailed, .dataLoadingFailed),
             (.calendarAccessDenied, .calendarAccessDenied):
            return true
        case (.networkError(let lhsMsg), .networkError(let rhsMsg)),
             (.decodingError(let lhsMsg), .decodingError(let rhsMsg)),
             (.persistenceError(let lhsMsg), .persistenceError(let rhsMsg)),
             (.invalidURL(let lhsMsg), .invalidURL(let rhsMsg)):
            return lhsMsg == rhsMsg
        case (.userSaveFailed(let lhsErr), .userSaveFailed(let rhsErr)),
             (.userLoadFailed(let lhsErr), .userLoadFailed(let rhsErr)),
             (.userDecodeFailed(let lhsErr), .userDecodeFailed(let rhsErr)):
            return lhsErr.localizedDescription == rhsErr.localizedDescription
        case (.unknown(let lhsError), .unknown(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}

