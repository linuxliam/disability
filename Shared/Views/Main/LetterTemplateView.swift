//
//  LetterTemplateView.swift
//  Disability Advocacy iOS
//
//  Letter template generator view
//

import SwiftUI

struct LetterTemplateView: View {
    @State private var viewModel = LetterTemplateViewModel()
    @State private var selectedCategory: LetterCategory?
    
    var filteredTemplates: [LetterTemplate] {
        if let category = selectedCategory {
            return viewModel.templates.filter { $0.category == category }
        }
        return viewModel.templates
    }
    
    var body: some View {
        if let template = viewModel.selectedTemplate {
            LetterEditorView(viewModel: viewModel, template: template)
        } else {
            LetterTemplateListView(viewModel: viewModel, selectedCategory: $selectedCategory, filteredTemplates: filteredTemplates)
        }
    }
}

struct LetterTemplateListView: View {
    @Bindable var viewModel: LetterTemplateViewModel
    @Binding var selectedCategory: LetterCategory?
    
    let filteredTemplates: [LetterTemplate]
    
    private var filterButtonRow: some View {
        Picker(String(localized: "Category"), selection: $selectedCategory) {
            Text(String(localized: "All Templates")).tag(Optional<LetterCategory>.none)
            ForEach(LetterCategory.allCases, id: \.self) { category in
                Text(category.rawValue).tag(Optional(category))
            }
        }
        .pickerStyle(.menu)
        .padding(.horizontal, LayoutConstants.screenHorizontalPadding)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            filterButtonRow
                .padding(.top, LayoutConstants.paddingM)
                .padding(.bottom, LayoutConstants.paddingS)
            
            if filteredTemplates.isEmpty {
                EmptyStateView(
                    icon: "doc.text",
                    title: String(localized: "No templates found"),
                    message: String(localized: "Try selecting a different category.")
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List {
                    Section {
                        ForEach(filteredTemplates) { template in
                            Button(action: {
                                HapticManager.selection()
                                viewModel.selectTemplate(template)
                            }) {
                                VStack(alignment: .leading, spacing: LayoutConstants.spacingS) {
                                    HStack(alignment: .top, spacing: 12) {
                                        Image(systemName: template.category.icon)
                                            .font(.title3.weight(.bold))
                                            .foregroundStyle(.triadPrimary)
                                            .frame(width: 44, height: 44)
                                            .background(Color.triadPrimary.opacity(0.1))
                                            .cornerRadius(12)
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(template.title)
                                                .font(.body.weight(.bold))
                                                .foregroundStyle(.primary)
                                                .multilineTextAlignment(TextAlignment.leading)
                                            
                                            Text(template.description)
                                                .lineLimit(2)
                                                .secondaryBody()
                                        }
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                            .buttonStyle(.plain)
                        }
                    } header: {
                        AppSectionHeader(
                            title: selectedCategory != nil ? LocalizedStringKey(selectedCategory!.rawValue) : "All Templates",
                            systemImage: selectedCategory?.icon ?? "doc.text.fill"
                        )
                        .tint(.triadPrimary)
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
                .appListBackground()
            }
        }
        .navigationTitle(String(localized: "Letter Templates"))
        .platformInlineNavigationTitle()
        .appScreenChrome()
    }
}

struct LetterEditorView: View {
    @Bindable var viewModel: LetterTemplateViewModel
    let template: LetterTemplate
    @Environment(\.dismiss) var dismiss
    @State private var showingPreview = false
    @FocusState private var focusedField: UUID?
    
    var body: some View {
        Form {
            // Template Info Section
            Section {
                headerCard
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
            }
            
            // Details Section
            Section {
                ForEach(template.placeholders) { placeholder in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(placeholder.label)
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.primary)
                            
                            if placeholder.required {
                                Text("*")
                                    .foregroundStyle(.red)
                            }
                        }
                        
                        TextField(placeholder.label, text: Binding(
                            get: { viewModel.filledPlaceholders[placeholder.id] ?? "" },
                            set: { viewModel.updatePlaceholder(id: placeholder.id, value: $0) }
                        ))
                        .focused($focusedField, equals: placeholder.id)
                    }
                    .padding(.vertical, 4)
                }
            } header: {
                Text(String(localized: "Details"))
            }
            
            // Generate Section
            Section {
                Button(action: {
                    HapticManager.medium()
                    viewModel.generateLetter()
                    showingPreview = true
                }) {
                    Label(String(localized: "Generate Letter"), systemImage: "doc.text.fill")
                        .font(.headline.weight(.bold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                }
                .disabled(!viewModel.canGenerateLetter())
                .buttonStyle(.borderedProminent)
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets())
            }
            
            if !viewModel.generatedLetter.isEmpty {
                // Preview Section
                Section {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text(String(localized: "Preview"))
                                .font(.headline.weight(.bold))
                            
                            Spacer()
                            
                            ShareLink(item: viewModel.generatedLetter, subject: Text(template.title)) {
                                Image(systemName: "square.and.arrow.up")
                                    .font(.title3.weight(.semibold))
                                    .foregroundStyle(.triadPrimary)
                            }
                        }
                        
                        Text(viewModel.generatedLetter)
                            .font(.system(.body, design: .serif))
                            .textSelection(.enabled)
                            .padding()
                            .background(Color.secondary.opacity(0.05))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.primary.opacity(0.05), lineWidth: 1)
                            )
                    }
                    .padding(.vertical, 8)
                } header: {
                    Text(String(localized: "Result"))
                }
            }
        }
        .navigationTitle(template.title)
        .platformInlineNavigationTitle()
        .appScreenChrome()
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(String(localized: "Back")) {
                    viewModel.clearLetter()
                }
                .fontWeight(.semibold)
            }
        }
    }

    private var headerCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 16) {
                Image(systemName: template.category.icon)
                    .font(.title2.weight(.bold))
                    .foregroundStyle(.triadPrimary)
                    .frame(width: 56, height: 56)
                    .background(Color.triadPrimary.opacity(0.1))
                    .cornerRadius(16)
                
                VStack(alignment: .leading, spacing: 6) {
                    AppChip(text: template.category.rawValue, style: .primary)
                    
                    Text(template.title)
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.primary)
                }
            }
            
            Text(template.description)
                .secondaryBody()
        }
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



