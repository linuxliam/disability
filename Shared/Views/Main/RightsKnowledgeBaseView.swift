//
//  RightsKnowledgeBaseView.swift
//  Disability Advocacy
//
//  Rights knowledge base and legal information
//

import SwiftUI

struct RightsKnowledgeBaseView: View {
    @State private var selectedLaw: DisabilityLaw?
    @State private var searchText = ""
    
    let laws: [DisabilityLaw] = [
        DisabilityLaw(
            name: "Americans with Disabilities Act (ADA)",
            year: 1990,
            description: "Prohibits discrimination against individuals with disabilities in all areas of public life.",
            keyProvisions: [
                "Title I: Employment - Prohibits discrimination in employment",
                "Title II: State and Local Government - Ensures accessibility in public services",
                "Title III: Public Accommodations - Requires accessibility in businesses open to the public",
                "Title IV: Telecommunications - Ensures accessible phone and internet services"
            ],
            protectedAreas: ["Employment", "Public Services", "Public Accommodations", "Telecommunications"],
            enforcement: "U.S. Department of Justice, Equal Employment Opportunity Commission"
        ),
        DisabilityLaw(
            name: "Section 504 of the Rehabilitation Act",
            year: 1973,
            description: "Prohibits discrimination on the basis of disability in programs receiving federal financial assistance.",
            keyProvisions: [
                "Applies to all programs and activities receiving federal funding",
                "Requires reasonable accommodations",
                "Mandates accessibility in facilities and programs"
            ],
            protectedAreas: ["Education", "Employment", "Healthcare", "Housing"],
            enforcement: "Office for Civil Rights (OCR)"
        ),
        DisabilityLaw(
            name: "Individuals with Disabilities Education Act (IDEA)",
            year: 1975,
            description: "Ensures students with disabilities receive free appropriate public education.",
            keyProvisions: [
                "Free Appropriate Public Education (FAPE)",
                "Individualized Education Program (IEP)",
                "Least Restrictive Environment (LRE)",
                "Procedural safeguards and parent rights"
            ],
            protectedAreas: ["Education"],
            enforcement: "U.S. Department of Education"
        ),
        DisabilityLaw(
            name: "Fair Housing Act (FHA)",
            year: 1968,
            description: "Prohibits discrimination in the sale, rental, and financing of dwellings based on disability.",
            keyProvisions: [
                "Requires landlords to allow reasonable modifications",
                "Requires reasonable accommodations in rules and policies",
                "Requires new multi-family housing to be accessible"
            ],
            protectedAreas: ["Housing"],
            enforcement: "U.S. Department of Housing and Urban Development (HUD)"
        )
    ]
    
    var filteredLaws: [DisabilityLaw] {
        if searchText.isEmpty {
            return laws
        } else {
            return laws.filter { $0.name.localizedCaseInsensitiveContains(searchText) || $0.description.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        Group {
            #if os(macOS)
            GeometryReader { geometry in
                ScrollView {
                    VStack(alignment: .leading, spacing: LayoutConstants.sectionHeaderSpacing) {
                        AppSectionHeader(
                            title: "Legal Protections",
                            systemImage: "shield.fill",
                            subtitle: "Comprehensive guide to disability rights laws"
                        )
                        .padding(.bottom, LayoutConstants.spacingS)
                        
                        LazyVGrid(columns: AdaptiveLayout.gridColumns(for: .regular, availableWidth: geometry.size.width), spacing: LayoutConstants.cardGap) {
                            ForEach(filteredLaws) { law in
                                NavigationLink(value: law) {
                                    DisabilityLawGridCard(law: law)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .adaptiveContentFrame()
                    .padding(.top, LayoutConstants.paddingM)
                    .padding(.bottom, LayoutConstants.paddingXXL)
                }
            }
            #else
            List(filteredLaws) { law in
                NavigationLink(value: law) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(law.name)
                            .font(.headline)
                        Text(law.description)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                    }
                    .padding(.vertical, 4)
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
        .navigationTitle(String(localized: "Rights Knowledge Base"))
        .platformInlineNavigationTitle()
        .searchable(text: $searchText, prompt: String(localized: "Search laws..."))
        .appScreenChrome()
    }
}

struct DisabilityLaw: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let year: Int
    let description: String
    let keyProvisions: [String]
    let protectedAreas: [String]
    let enforcement: String
}

struct LawDetailView: View {
    let law: DisabilityLaw
    
    var body: some View {
        List {
            // Header Card Section
            Section {
                AppDetailHeader(
                    title: law.name,
                    subtitle: nil,
                    icon: "shield.fill",
                    iconColor: .triadPrimary,
                    chipText: String(localized: "Enacted \(law.year)"),
                    chipStyle: .tertiary
                )
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
            }
            
            // Description
            Section {
                Text(law.description)
                    .standardBody()
                    .padding(.vertical, 4)
            } header: {
                Text(String(localized: "Overview"))
            }
            
            // Key Provisions
            Section {
                ForEach(law.keyProvisions, id: \.self) { provision in
                    Label {
                        Text(provision)
                            .standardBody()
                    } icon: {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.triadTertiary)
                    }
                    .padding(.vertical, 4)
                }
            } header: {
                Text(String(localized: "Key Provisions"))
            }
            
            // Protected Areas
            Section {
                DisabilityLawFlowLayout(items: law.protectedAreas) { area in
                    AppChip(text: area, style: .primary)
                }
                .padding(.vertical, 4)
            } header: {
                Text(String(localized: "Protected Areas"))
            }
            
            // Enforcement
            Section {
                Text(law.enforcement)
                    .standardBody()
                    .padding(.vertical, 4)
            } header: {
                Text(String(localized: "Enforcement"))
            }
            
            // Resources
            Section {
                if let adaURL = URL(string: "https://www.ada.gov") {
                    Link(destination: adaURL) {
                        Label("ADA.gov - Official ADA Information", systemImage: "safari")
                    }
                }
                
                if let dolURL = URL(string: "https://www.dol.gov/agencies/odep") {
                    Link(destination: dolURL) {
                        Label("Office of Disability Employment Policy", systemImage: "safari")
                    }
                }
            } header: {
                Text(String(localized: "Additional Resources"))
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
        .navigationTitle(law.name)
        .appScreenChrome()
        .frame(maxWidth: AdaptiveLayout.contentMaxWidth(for: .regular))
        .frame(maxWidth: .infinity)
    }
}

// Simple FlowLayout helper for protected areas
struct DisabilityLawFlowLayout<T: Hashable, Content: View>: View {
    let items: [T]
    let content: (T) -> Content
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(items, id: \.self) { item in
                content(item)
            }
        }
    }
}
