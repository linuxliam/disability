//
//  FeatureHighlight.swift
//  Disability Advocacy
//
//  A component to highlight new features to the user
//

import SwiftUI
#if os(macOS)
import AppKit
#else
import UIKit
#endif

struct FeatureHighlight: View {
    @Environment(\.themeManager) private var themeManager
    
    let title: String
    let message: String
    let icon: String
    @Binding var isPresented: Bool
    
    var body: some View {
        if isPresented {
            ZStack {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        if let animation = themeManager.animationStyle {
                            withAnimation(animation) {
                                isPresented = false
                            }
                        } else {
                            isPresented = false
                        }
                    }
                
                VStack(spacing: 24) {
                    Image(systemName: icon)
                        .font(.system(size: 44, weight: .semibold))
                        .foregroundStyle(ColorTokens.brandPrimary(theme: themeManager))
                        .padding(20)
                        .background(ColorTokens.brandPrimary(theme: themeManager).opacity(0.1))
                        .clipShape(Circle())
                    
                    VStack(spacing: 12) {
                        Text(title)
                            .font(TypographyTokens.headingSmall(theme: themeManager))
                            .foregroundStyle(ColorTokens.textPrimary(theme: themeManager))
                        
                        Text(message)
                            .font(TypographyTokens.bodyMedium(theme: themeManager))
                            .foregroundStyle(ColorTokens.textSecondary(theme: themeManager))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    
                    Button(action: {
                        if let animation = themeManager.animationStyle {
                            withAnimation(animation) {
                                isPresented = false
                            }
                        } else {
                            isPresented = false
                        }
                    }) {
                        Text(String(localized: "Got it"))
                            .font(TypographyTokens.labelLarge(theme: themeManager))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(ColorTokens.brandPrimary(theme: themeManager))
                            .cornerRadius(14)
                    }
                }
                .padding(32)
                .background(ColorTokens.surfacePrimary(theme: themeManager))
                .cornerRadius(24)
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(ColorTokens.borderPrimary(theme: themeManager).opacity(0.2), lineWidth: 0.5)
                )
                .shadow(
                    color: Color.black.opacity(themeManager.colorScheme == .dark ? 0.4 : 0.15),
                    radius: 30,
                    x: 0,
                    y: 15
                )
                .padding(40)
                .transition(.scale(scale: 0.9).combined(with: .opacity))
            }
            .zIndex(2000)
        }
    }
}

