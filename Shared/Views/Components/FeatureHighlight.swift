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
    let title: String
    let message: String
    let icon: String
    @Binding var isPresented: Bool
    
    private var systemBackgroundColor: Color {
        #if os(macOS)
        return Color(NSColor.windowBackgroundColor)
        #else
        return Color(UIColor.systemBackground)
        #endif
    }
    
    var body: some View {
        if isPresented {
            ZStack {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            isPresented = false
                        }
                    }
                
                VStack(spacing: 24) {
                    Image(systemName: icon)
                        .font(.system(size: 44, weight: .semibold))
                        .foregroundStyle(.tint)
                        .padding(20)
                        .background(Color.accentColor.opacity(0.1))
                        .clipShape(Circle())
                    
                    VStack(spacing: 12) {
                        Text(title)
                            .font(.title3.weight(.bold))
                            .foregroundStyle(.primary)
                        
                        Text(message)
                            .font(.body)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    
                    Button(action: {
                        withAnimation {
                            isPresented = false
                        }
                    }) {
                        Text(String(localized: "Got it"))
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.accentColor)
                            .cornerRadius(14)
                    }
                }
                .padding(32)
                .background(Color.cardBackground)
                .cornerRadius(24)
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.primary.opacity(0.05), lineWidth: 0.5)
                )
                .shadow(color: Color.black.opacity(0.15), radius: 30, x: 0, y: 15)
                .padding(40)
                .transition(.scale(scale: 0.9).combined(with: .opacity))
            }
            .zIndex(2000)
        }
    }
}

