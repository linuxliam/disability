//
//  AccessibilitySettingsView.swift
//  Disability Advocacy
//
//  Accessibility preferences and settings
//

import SwiftUI
#if os(macOS)
import AppKit
#endif

// Force import of the model
import Foundation

struct AccessibilitySettingsView: View {
    @Environment(AppState.self) var appState
    @Environment(\.dismiss) var dismiss
    @State private var highContrast = false
    @State private var largeText = false
    @State private var reducedMotion = false
    @State private var screenReaderOptimized = false
    @State private var customFontSize: CGFloat = 14.0
    
    var body: some View {
        Form {
            Section {
                headerCard
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
            }

            Section {
                Toggle(isOn: $highContrast) {
                    Label(String(localized: "High Contrast Mode"), systemImage: "circle.lefthalf.filled")
                }
                .accessibilityLabel("Enable high contrast mode")

                Toggle(isOn: $largeText) {
                    Label(String(localized: "Large Text"), systemImage: "textformat.size")
                }
                .accessibilityLabel("Enable large text")

                VStack(alignment: .leading, spacing: 12) {
                    Label(String(localized: "Custom Font Size"), systemImage: "textformat")
                        .font(.subheadline.weight(.semibold))
                    
                    HStack(spacing: 16) {
                        Text("\(Int(customFontSize))pt")
                            .font(.caption.monospacedDigit())
                            .foregroundStyle(.secondary)
                            .frame(width: 40)
                        
                        Slider(value: $customFontSize, in: 12...24, step: 1)
                            .accessibilityLabel("Adjust font size")
                    }
                }
                .padding(.vertical, 4)
            } header: {
                AppSectionHeader(title: "Visual", systemImage: "eye.fill")
                    .tint(.triadPrimary)
            }
            
            Section {
                Toggle(isOn: $reducedMotion) {
                    Label(String(localized: "Reduce Motion"), systemImage: "move.3d")
                }
                .accessibilityLabel("Reduce animations and motion effects")
            } header: {
                AppSectionHeader(title: "Motion", systemImage: "figure.walk.motion")
                    .tint(.triadSecondary)
            }

            Section {
                Toggle(isOn: $screenReaderOptimized) {
                    Label(String(localized: "Screen Reader Optimized"), systemImage: "waveform.circle.fill")
                }
                .accessibilityLabel("Optimize interface for screen readers")
            } header: {
                AppSectionHeader(title: "Screen Reader", systemImage: "ear.fill")
                    .tint(.triadTertiary)
            }
            
            Section {
                Text(String(localized: "These settings help customize the app experience to meet your accessibility needs. Changes will be saved automatically."))
                    .secondaryBody()
                    .padding(.vertical, 4)
            } header: {
                AppSectionHeader(title: "About", systemImage: "info.circle.fill")
            }
        }
        .navigationTitle(String(localized: "Accessibility"))
        .platformInlineNavigationTitle()
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button(String(localized: "Done")) {
                    dismiss()
                }
                .fontWeight(.bold)
            }
        }
        #if os(macOS)
        .frame(minWidth: 500, minHeight: 400)
        #endif
        .appScreenChrome()
    }

    private var headerCard: some View {
        VStack(spacing: 16) {
            Image(systemName: "accessibility")
                .font(.system(size: 48, weight: .bold))
                .foregroundStyle(.white)
                .frame(width: 80, height: 80)
                .background(
                    LinearGradient(
                        colors: [.triadPrimary, .triadPrimary.opacity(0.8)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(Circle())
                .shadow(color: Color.triadPrimary.opacity(0.3), radius: 10, x: 0, y: 5)
            
            VStack(spacing: 4) {
                Text(String(localized: "Accessibility Settings"))
                    .font(.title3.weight(.bold))
                    .foregroundStyle(.primary)
                
                Text(String(localized: "Customize your experience"))
                    .secondaryBody()
            }
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .background(Color.cardBackground)
        .cornerRadius(LayoutConstants.cardCornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: LayoutConstants.cardCornerRadius)
                .stroke(Color.primary.opacity(0.08), lineWidth: 1)
        )
        .padding(.horizontal, LayoutConstants.screenHorizontalPadding)
    }
}



