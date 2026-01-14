//
//  DataExportView.swift
//  Disability Advocacy
//
//  View for importing and exporting data files.
//

import SwiftUI

@MainActor
struct DataExportView: View {
    @Environment(AppState.self) private var appState
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(String(localized: "Import and export data files for backup or sharing."))
                .font(.subheadline)
                .foregroundStyle(Color.secondaryText)
            
            #if os(macOS)
            // Import Section
            VStack(alignment: .leading, spacing: 12) {
                Text(String(localized: "Import"))
                    .font(.headline)
                    .foregroundStyle(Color.primaryText)
                
                HStack(spacing: 12) {
                    importButton(
                        title: String(localized: "Import Resources"),
                        icon: "square.and.arrow.down.fill",
                        color: .triadPrimary
                    ) {
                        Task {
                            await appState.importResources()
                        }
                    }
                    
                    importButton(
                        title: String(localized: "Import Events"),
                        icon: "square.and.arrow.down.fill",
                        color: .triadSecondary
                    ) {
                        Task {
                            await appState.importEvents()
                        }
                    }
                }
            }
            
            Divider()
            #endif
            
            // Export Section
            VStack(alignment: .leading, spacing: 12) {
                Text(String(localized: "Export"))
                    .font(.headline)
                    .foregroundStyle(Color.primaryText)
                
                HStack(spacing: 12) {
                    exportButton(
                        title: String(localized: "Export Resources"),
                        icon: "square.and.arrow.up.fill",
                        color: .triadPrimary
                    ) {
                        Task {
                            await appState.exportResources()
                        }
                    }
                    
                    exportButton(
                        title: String(localized: "Export Events"),
                        icon: "square.and.arrow.up.fill",
                        color: .triadSecondary
                    ) {
                        Task {
                            await appState.exportEvents()
                        }
                    }
                }
            }
        }
        .padding(LayoutConstants.cardPadding)
        .background(Color.cardBackground)
        .cornerRadius(LayoutConstants.cardCornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: LayoutConstants.cardCornerRadius)
                .stroke(Color.primary.opacity(0.08), lineWidth: 1)
        )
    }
    
    #if os(macOS)
    @MainActor
    private func importButton(title: String, icon: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                Text(title)
                    .font(.subheadline.weight(.semibold))
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity)
            .background(color.opacity(0.1))
            .foregroundStyle(color)
            .cornerRadius(10)
        }
        .buttonStyle(.plain)
    }
    #endif
    
    @MainActor
    private func exportButton(title: String, icon: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                Text(title)
                    .font(.subheadline.weight(.semibold))
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity)
            .background(color.opacity(0.1))
            .foregroundStyle(color)
            .cornerRadius(10)
        }
        .buttonStyle(.plain)
    }
}
