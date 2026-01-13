//
//  FeedbackViewModel.swift
//  Disability Advocacy iOS
//
//  Centralized feedback management for toasts and alerts
//

import SwiftUI
import Observation

/// Type of feedback to display
enum FeedbackType {
    case success
    case error
    case warning
    case info
    
    var icon: String {
        switch self {
        case .success: return "checkmark.circle.fill"
        case .error: return "exclamationmark.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .info: return "info.circle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .success: return .semanticSuccess
        case .error: return .semanticError
        case .warning: return .semanticWarning
        case .info: return .semanticInfo
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .success: return .semanticSuccessBackground
        case .error: return .semanticErrorBackground
        case .warning: return .semanticWarningBackground
        case .info: return .semanticInfoBackground
        }
    }
}

/// Model for a toast notification
struct Toast: Identifiable, Equatable {
    let id = UUID()
    let message: String
    let type: FeedbackType
    var duration: Double = 3.5
    
    static func == (lhs: Toast, rhs: Toast) -> Bool {
        lhs.id == rhs.id
    }
}

@MainActor
@Observable
class FeedbackViewModel {
    var toasts: [Toast] = []
    
    /// Show a toast notification
    /// - Parameters:
    ///   - message: The message to display
    ///   - type: The type of feedback (success, error, warning, info)
    ///   - duration: How long to show the toast before auto-dismissing
    func show(message: String, type: FeedbackType = .info, duration: Double = 3.5) {
        let toast = Toast(message: message, type: type, duration: duration)
        
        // Add to list with animation
        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
            toasts.append(toast)
        }
        
        // Auto-dismiss
        Task {
            try? await Task.sleep(nanoseconds: UInt64(duration * 1_000_000_000))
            dismiss(toast)
        }
    }
    
    /// Dismiss a specific toast
    func dismiss(_ toast: Toast) {
        withAnimation(.easeInOut(duration: 0.2)) {
            toasts.removeAll { $0.id == toast.id }
        }
    }
    
    // MARK: - Convenience Methods
    
    func success(_ message: String) {
        show(message: message, type: .success)
    }
    
    func error(_ message: String) {
        show(message: message, type: .error)
    }
    
    func warning(_ message: String) {
        show(message: message, type: .warning)
    }
    
    func info(_ message: String) {
        show(message: message, type: .info)
    }
}

