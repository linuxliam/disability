//
//  DataExportView.swift
//  Disability Advocacy
//
//  View for exporting local data changes.
//

import SwiftUI

struct DataExportView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(String(localized: "Export local data files to use as bundled resources in the project."))
                .font(.subheadline)
                .foregroundStyle(.secondaryText)
            
            HStack(spacing: 12) {
                exportButton(filename: "Resources.json", icon: "book.fill", color: .triadPrimary)
                exportButton(filename: "Events.json", icon: "calendar", color: .triadSecondary)
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
    
    private func exportButton(filename: String, icon: String, color: Color) -> some View {
        let fileURL = DataManager.shared.getJSONStorageManager().getLocalFileURL(for: filename)
        
        return Group {
            if let url = fileURL {
                ShareLink(item: url) {
                    HStack(spacing: 8) {
                        Image(systemName: icon)
                        Text(filename)
                            .font(.subheadline.weight(.semibold))
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
                    .frame(maxWidth: .infinity)
                    .background(color.opacity(0.1))
                    .foregroundStyle(color)
                    .cornerRadius(10)
                }
            } else {
                HStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle")
                    Text(filename)
                        .font(.subheadline)
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity)
                .background(Color.secondary.opacity(0.1))
                .foregroundStyle(.secondary)
                .cornerRadius(10)
            }
        }
    }
}
