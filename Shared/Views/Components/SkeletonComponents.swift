//
//  SkeletonComponents.swift
//  Disability Advocacy
//
//  Consolidated skeleton loading components with shimmer effect.
//

import SwiftUI

// MARK: - Base Skeleton View

struct SkeletonView: View {
    @State private var phase: CGFloat = -1
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                Color.secondary.opacity(0.15)
                
                // Shimmer
                if !reduceMotion {
                    LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: .clear, location: 0.3),
                            .init(color: .white.opacity(0.4), location: 0.5),
                            .init(color: .clear, location: 0.7)
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .scaleEffect(x: 2)
                    .offset(x: phase * geometry.size.width)
                    .onAppear {
                        withAnimation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                            phase = 1
                        }
                    }
                }
            }
        }
        .mask(Capsule())
    }
}

/// Helper for building skeleton layouts
extension View {
    func skeleton(width: CGFloat? = nil, height: CGFloat? = nil) -> some View {
        SkeletonView()
            .frame(width: width, height: height)
    }
}

// MARK: - Skeleton Row Base

struct SkeletonRow: View {
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            SkeletonView()
                .frame(width: 50, height: 50)
                .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 8) {
                SkeletonView()
                    .frame(height: 18)
                    .frame(width: 200)
                
                SkeletonView()
                    .frame(height: 14)
                    .frame(width: 150)
                
                SkeletonView()
                    .frame(height: 14)
                    .frame(width: 100)
            }
            Spacer()
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Event Skeleton Row

struct EventSkeletonRow: View {
    var body: some View {
        HStack(alignment: .top, spacing: LayoutConstants.spacingL) {
            // Date Badge placeholder
            SkeletonView()
                .frame(width: 50, height: 60)
                .cornerRadius(LayoutConstants.buttonCornerRadius)
            
            VStack(alignment: .leading, spacing: LayoutConstants.paddingS) {
                // Title placeholder
                SkeletonView()
                    .frame(height: 22)
                    .frame(maxWidth: 200)
                
                // Location placeholder
                HStack(spacing: LayoutConstants.spacingS) {
                    SkeletonView()
                        .frame(width: 14, height: 14)
                        .mask(Circle())
                    SkeletonView()
                        .frame(width: 120, height: 14)
                }
                
                // Accessibility info placeholder
                SkeletonView()
                    .frame(width: 140, height: 12)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.cardBackground)
        .cornerRadius(LayoutConstants.cardCornerRadius)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

// MARK: - Post Skeleton Row

struct PostSkeletonRow: View {
    var body: some View {
        VStack(alignment: .leading, spacing: LayoutConstants.spacingS) {
            HStack {
                // Title placeholder
                SkeletonView()
                    .frame(height: 20)
                    .frame(maxWidth: 200)
                
                Spacer()
                
                // Category placeholder
                SkeletonView()
                    .frame(width: 80, height: 20)
                    .cornerRadius(LayoutConstants.buttonCornerRadius)
            }
            
            // Content placeholder
            VStack(alignment: .leading, spacing: 4) {
                SkeletonView()
                    .frame(height: 14)
                    .frame(maxWidth: .infinity)
                SkeletonView()
                    .frame(height: 14)
                    .frame(maxWidth: .infinity)
                SkeletonView()
                    .frame(height: 14)
                    .frame(maxWidth: 150)
            }
            
            HStack {
                // Author placeholder
                SkeletonView()
                    .frame(width: 100, height: 12)
                
                Spacer()
                
                // Likes/Replies placeholder
                HStack(spacing: LayoutConstants.spacingL) {
                    SkeletonView()
                        .frame(width: 30, height: 12)
                    SkeletonView()
                        .frame(width: 30, height: 12)
                }
            }
        }
        .padding(.vertical, LayoutConstants.paddingS)
    }
}

// MARK: - Resource Skeleton Row

struct ResourceSkeletonRow: View {
    var body: some View {
        HStack(alignment: .top, spacing: LayoutConstants.spacingM) {
            // Category Icon placeholder
            SkeletonView()
                .frame(width: LayoutConstants.iconSizeXL, height: LayoutConstants.iconSizeXL)
                .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: LayoutConstants.spacingXS) {
                // Title placeholder
                SkeletonView()
                    .frame(height: 20)
                    .frame(maxWidth: 240)
                
                // Description placeholder lines
                VStack(alignment: .leading, spacing: 4) {
                    SkeletonView()
                        .frame(height: 14)
                        .frame(maxWidth: .infinity)
                    SkeletonView()
                        .frame(height: 14)
                        .frame(maxWidth: 200)
                }
                
                // Tags placeholder
                HStack(spacing: LayoutConstants.spacingS) {
                    SkeletonView()
                        .frame(width: 60, height: 16)
                    SkeletonView()
                        .frame(width: 80, height: 16)
                }
                .padding(.top, 4)
            }
        }
        .padding(.vertical, LayoutConstants.paddingXS)
    }
}

// MARK: - Previews

#Preview("Skeleton Rows") {
    List {
        Section("Basic") {
            SkeletonRow()
        }
        
        Section("Events") {
            EventSkeletonRow()
        }
        
        Section("Posts") {
            PostSkeletonRow()
        }
        
        Section("Resources") {
            ResourceSkeletonRow()
        }
    }
    #if os(iOS)
    .listStyle(.insetGrouped)
    #else
    .listStyle(.inset)
    #endif
}

