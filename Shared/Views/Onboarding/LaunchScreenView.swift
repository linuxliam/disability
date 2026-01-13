//
//  LaunchScreenView.swift
//  Disability Advocacy
//
//  Launch screen shown while app is loading
//

import SwiftUI
#if os(iOS)
import UIKit
#endif

struct LaunchScreenView: View {
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0.5
    
    var body: some View {
        ZStack {
            // Background gradient matching app theme
            LinearGradient(
                colors: [
                    Color.appBackground,
                    Color.groupedBackground
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: LayoutConstants.spacingXXL) {
                // App Icon/Logo
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.accentColor,
                                    Color.accentColor.opacity(0.7)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 120, height: 120)
                        .shadow(color: Color.accentColor.opacity(0.3), radius: 20, x: 0, y: 10)
                    
                    Image(systemName: "accessibility")
                        .font(.system(size: 60, weight: .medium))
                        .foregroundStyle(.white)
                }
                .scaleEffect(scale)
                .opacity(opacity)
                
                // App Name
                Text(String(localized: "Disability Advocacy"))
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .opacity(opacity)
                
                // Tagline
                Text(String(localized: "Empowering voices, building community"))
                    .font(.callout)
                    .foregroundStyle(.white.opacity(0.7))
                    .opacity(opacity)
            }
        }
        .onAppear {
            #if os(iOS)
            if UIAccessibility.isReduceMotionEnabled {
                scale = 1.0
                opacity = 1.0
            } else {
                withAnimation(.easeOut(duration: 1.0)) {
                    scale = 1.0
                    opacity = 1.0
                }
            }
            #else
            // macOS: Always animate (macOS handles reduced motion differently)
            withAnimation(.easeOut(duration: 1.0)) {
                scale = 1.0
                opacity = 1.0
            }
            #endif
        }
    }
}

#Preview {
    LaunchScreenView()
}

