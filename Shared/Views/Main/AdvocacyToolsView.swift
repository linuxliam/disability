//
//  AdvocacyToolsView.swift
//  Disability Advocacy iOS
//
//  Tools and resources for advocacy
//

import SwiftUI

struct AdvocacyToolsView: View {
    @Environment(AppState.self) var appState
    
    let tools: [AdvocacyTool] = [
        AdvocacyTool(
            title: "Letter Template Generator",
            description: "Create professional letters to legislators, employers, or service providers",
            icon: "envelope.fill",
            color: .blue
        ),
        AdvocacyTool(
            title: "Accommodation Request Builder",
            description: "Build structured accommodation requests for work, school, or public services",
            icon: "doc.text.fill",
            color: .green
        ),
        AdvocacyTool(
            title: "Rights Knowledge Base",
            description: "Learn about your rights under ADA, Section 504, and other disability laws",
            icon: "book.fill",
            color: .orange
        ),
        AdvocacyTool(
            title: "Contact Your Representatives",
            description: "Find and contact your local, state, and federal representatives",
            icon: "person.2.fill",
            color: .purple
        ),
        AdvocacyTool(
            title: "Accessibility Complaint Form",
            description: "File complaints about accessibility violations in public spaces",
            icon: "exclamationmark.triangle.fill",
            color: .red
        ),
        AdvocacyTool(
            title: "Resource Sharing",
            description: "Share helpful resources with the community",
            icon: "square.and.arrow.up.fill",
            color: .teal
        )
    ]
    
    var body: some View {
        Group {
            #if os(macOS)
            GeometryReader { geometry in
                ScrollView {
                    VStack(alignment: .leading, spacing: LayoutConstants.sectionHeaderSpacing) {
                        AppSectionHeader(
                            title: "Available Tools",
                            systemImage: "hammer.fill",
                            subtitle: "Resources to help you advocate"
                        )
                        .padding(.bottom, LayoutConstants.spacingS)
                        
                        LazyVGrid(columns: AdaptiveLayout.gridColumns(for: .regular, availableWidth: geometry.size.width), spacing: LayoutConstants.cardGap) {
                            ForEach(tools) { tool in
                                NavigationLink(value: tool) {
                                    AdvocacyToolGridCard(tool: tool)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding(.horizontal, LayoutConstants.screenHorizontalPadding)
                    .padding(.top, LayoutConstants.paddingM)
                    .padding(.bottom, LayoutConstants.paddingXXL)
                    .frame(maxWidth: AdaptiveLayout.contentMaxWidth(for: .regular))
                    .frame(maxWidth: .infinity)
                }
            }
            #else
            List {
                Section {
                    ForEach(tools) { tool in
                        NavigationLink(value: tool) {
                            AppRow(
                                title: tool.title,
                                subtitle: tool.description,
                                systemImage: tool.icon
                            )
                        }
                    }
                } header: {
                    AppSectionHeader(
                        title: "Available Tools",
                        systemImage: "hammer.fill",
                        subtitle: "Resources to help you advocate"
                    )
                }
            }
                    #if os(iOS)
        .listStyle(.insetGrouped)
        #else
        .listStyle(.sidebar)
        #endif
            #endif
        }
        .appListBackground()
        .navigationTitle(String(localized: "Advocacy Tools"))
        .platformInlineNavigationTitle()
        .toolbar {
            ToolbarItem(placement: PlatformUI.trailingToolbarItemPlacement) {
                ProfileToolbarButton()
            }
        }
        .appScreenChrome()
    }
}

// Move AdvocacyToolRow to separate file for consistency
// See AdvocacyToolRow.swift

struct AdvocacyTool: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let description: String
    let icon: String
    let color: Color
}

struct ToolDetailView: View {
    let tool: AdvocacyTool
    
    var body: some View {
        List {
            Section {
                AppDetailHeader(
                    title: tool.title,
                    subtitle: String(localized: "Advocacy Tool"),
                    icon: tool.icon,
                    iconColor: tool.color,
                    chipText: nil
                )
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
            }
            
            Section {
                Text(tool.description)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .padding(.vertical, 4)
            } header: {
                Text(String(localized: "About This Tool"))
            }
            
            Section {
                VStack(spacing: LayoutConstants.spacingM) {
                    Image(systemName: "clock.fill")
                        .font(.title2)
                        .foregroundStyle(.orange)
                    
                    Text(String(localized: "Coming Soon"))
                        .font(.headline)
                    
                    Text(String(localized: "We're working on implementing \(tool.title.lowercased()). This feature will be available in a future update."))
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
            }
        }
        #if os(iOS)
                #if os(iOS)
        .listStyle(.insetGrouped)
        #else
        .listStyle(.sidebar)
        #endif
        #else
        .listStyle(.inset)
        #endif
        .navigationTitle(tool.title)
        .appScreenChrome()
        .frame(maxWidth: AdaptiveLayout.contentMaxWidth(for: .regular))
        .frame(maxWidth: .infinity)
    }
}


