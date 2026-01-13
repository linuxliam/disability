//
//  FeedbackComponents.swift
//  Disability Advocacy
//
//  Consolidated feedback and notification UI components.
//

import SwiftUI

// MARK: - Toast View

struct ToastView: View {
    let toast: Toast
    let onDismiss: () -> Void
    
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: toast.type.icon)
                .foregroundStyle(toast.type.color)
                .font(.headline)
                .accessibilityHidden(true)
            
            Text(toast.message)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(.primary)
                .multilineTextAlignment(TextAlignment.leading)
            
            Spacer()
            
            Button(action: {
                withAnimation {
                    onDismiss()
                }
            }) {
                Image(systemName: "xmark")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(.secondary)
            }
            .accessibilityLabel(String(localized: "Dismiss notification"))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.12), radius: 12, x: 0, y: 6)
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(toast.type.color.opacity(0.15), lineWidth: 0.5)
        }
        .padding(.horizontal, 16)
        .transition(reduceMotion ? .opacity : .move(edge: .top).combined(with: .opacity))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(toast.type == .error ? "Error" : "Notification"): \(toast.message)")
        .accessibilityAddTraits(.isStaticText)
    }
}

// MARK: - Toast Stack

/// A container view for managing multiple toasts
struct ToastStack: View {
    @Bindable var feedback: FeedbackViewModel
    
    var body: some View {
        VStack(spacing: 12) {
            ForEach(feedback.toasts) { toast in
                ToastView(toast: toast) {
                    feedback.dismiss(toast)
                }
                .gesture(
                    DragGesture(minimumDistance: 10, coordinateSpace: .local)
                        .onEnded { value in
                            if value.translation.height < -20 {
                                feedback.dismiss(toast)
                            }
                        }
                )
            }
            Spacer()
        }
        .padding(.top, 12)
        .zIndex(100) // Ensure toasts are above other content
    }
}

// MARK: - Previews

#Preview("Toast Variants") {
    ZStack {
        Color.gray.opacity(0.1).ignoresSafeArea()
        
        VStack(spacing: 16) {
            ToastView(toast: Toast(message: "Successfully saved profile!", type: .success), onDismiss: {})
            ToastView(toast: Toast(message: "Failed to load resources.", type: .error), onDismiss: {})
            ToastView(toast: Toast(message: "Please check your internet connection.", type: .warning), onDismiss: {})
            ToastView(toast: Toast(message: "A new version is available.", type: .info), onDismiss: {})
        }
    }
}

