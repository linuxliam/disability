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
    @Environment(\.themeManager) private var themeManager
    @Environment(\.dismiss) var dismiss
    
    // Bind directly to theme manager
    private var highContrast: Binding<Bool> {
        Binding(
            get: { themeManager.highContrast },
            set: { themeManager.highContrast = $0 }
        )
    }
    
    private var reducedMotion: Binding<Bool> {
        Binding(
            get: { themeManager.reducedMotion },
            set: { themeManager.reducedMotion = $0 }
        )
    }
    
    private var screenReaderOptimized: Binding<Bool> {
        Binding(
            get: { themeManager.screenReaderOptimized },
            set: { themeManager.screenReaderOptimized = $0 }
        )
    }
    
    private var customFontSize: Binding<CGFloat> {
        Binding(
            get: { themeManager.customFontSize },
            set: { themeManager.customFontSize = $0 }
        )
    }
    
    @State private var colorSchemeSelection: ColorScheme? = nil
    
    var body: some View {
        Form {
            Section {
                headerCard
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
            }

            Section {
                // Color Scheme Selection
                Picker(selection: $colorSchemeSelection) {
                    Text(String(localized: "System")).tag(ColorScheme?.none)
                    Text(String(localized: "Light")).tag(ColorScheme?.some(.light))
                    Text(String(localized: "Dark")).tag(ColorScheme?.some(.dark))
                } label: {
                    Label(String(localized: "Appearance"), systemImage: "circle.lefthalf.filled")
                }
                .onChange(of: colorSchemeSelection) { oldValue, newValue in
                    themeManager.configuration.colorScheme = newValue
                }
                .onAppear {
                    colorSchemeSelection = themeManager.configuration.colorScheme
                }
                
                Toggle(isOn: highContrast) {
                    Label(String(localized: "High Contrast Mode"), systemImage: "circle.lefthalf.filled")
                }
                .accessibilityLabel("Enable high contrast mode")

                VStack(alignment: .leading, spacing: 12) {
                    Label(String(localized: "Custom Font Size"), systemImage: "textformat")
                        .font(.subheadline.weight(.semibold))
                    
                    HStack(spacing: 16) {
                        Text("\(Int(customFontSize.wrappedValue * 14))pt")
                            .font(.caption.monospacedDigit())
                            .foregroundStyle(.secondary)
                            .frame(width: 50)
                        
                        Slider(value: customFontSize, in: 0.8...2.0, step: 0.1)
                            .accessibilityLabel("Adjust font size multiplier")
                    }
                }
                .padding(.vertical, 4)
            } header: {
                AppSectionHeader(title: "Visual", systemImage: "eye.fill")
                    .tint(.triadPrimary)
            }
            
            Section {
                Toggle(isOn: reducedMotion) {
                    Label(String(localized: "Reduce Motion"), systemImage: "move.3d")
                }
                .accessibilityLabel("Reduce animations and motion effects")
            } header: {
                AppSectionHeader(title: "Motion", systemImage: "figure.walk.motion")
                    .tint(.triadSecondary)
            }

            Section {
                Toggle(isOn: screenReaderOptimized) {
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



