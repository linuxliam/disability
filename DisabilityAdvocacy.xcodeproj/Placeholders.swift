import SwiftUI

// MARK: - Skeleton Loading Views
// Lightweight shimmering placeholder used in lists and loading states
struct SkeletonView: View {
    @State private var phase: CGFloat = 0
    
    var body: some View {
        RoundedRectangle(cornerRadius: 8, style: .continuous)
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.primary.opacity(0.06),
                        Color.primary.opacity(0.12),
                        Color.primary.opacity(0.06)
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .overlay(
                GeometryReader { geo in
                    LinearGradient(
                        colors: [Color.white.opacity(0), Color.white.opacity(0.25), Color.white.opacity(0)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: geo.size.width / 3)
                    .offset(x: phase * (geo.size.width + geo.size.width / 3) - geo.size.width / 3)
                }
            )
            .clipped()
            .onAppear {
                withAnimation(.linear(duration: 1.2).repeatForever(autoreverses: false)) {
                    phase = 1
                }
            }
            .accessibilityHidden(true)
    }
}

// Row placeholder for a resource list item
struct ResourceSkeletonRow: View {
    var body: some View {
        HStack(spacing: 12) {
            SkeletonView()
                .frame(width: 28, height: 28)
                .cornerRadius(6)
            VStack(alignment: .leading, spacing: 6) {
                SkeletonView().frame(height: 12).cornerRadius(6)
                SkeletonView().frame(height: 10).cornerRadius(5)
            }
        }
        .padding(.vertical, 8)
        .accessibilityHidden(true)
    }
}

// Row placeholder for a community post item
struct PostSkeletonRow: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            SkeletonView().frame(height: 12).cornerRadius(6)
            SkeletonView().frame(height: 10).cornerRadius(5)
        }
        .padding(.vertical, 8)
        .accessibilityHidden(true)
    }
}

// MARK: - Toast Placeholder
// Minimal placeholder so AppRootView compiles. Replace with your real toast implementation when available.
struct ToastStack: View {
    // The app uses `ToastStack(feedback: appState.feedback)`; we accept Any? to avoid coupling.
    var feedback: Any? = nil
    
    var body: some View {
        // No-op overlay. Insert your real toast presentation here.
        EmptyView()
    }
}
