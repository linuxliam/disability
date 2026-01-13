//
//  LoadingView.swift
//  Disability Advocacy iOS
//
//  Reusable loading indicator component
//

import SwiftUI

struct LoadingView: View {
    var message: String = String(localized: "Loading...")
    @State private var opacity: Double = 0.6
    @State private var rotation: Double = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    var body: some View {
        VStack(spacing: LayoutConstants.sectionGap) {
            ZStack {
                // Outer ring - subtle background
                Circle()
                    .stroke(Color.accentColor.opacity(0.15), lineWidth: 5)
                    .frame(width: 60, height: 60)
                
                // Animated arc
                Circle()
                    .trim(from: 0, to: 0.75)
                    .stroke(
                        Color.accentColor,
                        style: StrokeStyle(lineWidth: 5, lineCap: .round)
                    )
                    .frame(width: 60, height: 60)
                    .rotationEffect(.degrees(rotation))
            }
            .accessibilityLabel("Loading")
            
            Text(message)
                .font(.body)
                .foregroundStyle(Color.secondaryText)
                .opacity(opacity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.groupedBackground)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(message)
        .onAppear {
            AccessibilityAnnouncer.announce(message)
            if reduceMotion {
                opacity = 1.0
            } else {
                withAnimation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true)) {
                    opacity = 1.0
                }
                withAnimation(.linear(duration: 1.2).repeatForever(autoreverses: false)) {
                    rotation = 360
                }
            }
        }
        .onDisappear {
            AccessibilityAnnouncer.announce(String(localized: "Loading completed"))
        }
    }
}

struct LoadingOverlay: View {
    var body: some View {
        ZStack {
            Color.groupedBackground
                .opacity(0.9)
            
            VStack(spacing: LayoutConstants.spacingM) {
                ProgressView()
                    .scaleEffect(1.2)
                    .tint(.accentColor)
                
                Text(String(localized: "Loading..."))
                    .font(.subheadline)
                    .foregroundStyle(Color.secondaryText)
            }
            .padding(LayoutConstants.paddingXL)
            .background(Color.cardBackground)
            .cornerRadius(LayoutConstants.buttonCornerRadius)
            .shadow(color: Color.black.opacity(0.2), radius: LayoutConstants.cardShadowRadius, x: 0, y: LayoutConstants.cardShadowRadius / 2)
        }
    }
}

