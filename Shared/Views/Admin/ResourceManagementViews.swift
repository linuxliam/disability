//
//  ResourceManagementViews.swift
//  Disability Advocacy
//
//  Views for managing and editing resource content.
//

import SwiftUI

struct ManageResourcesView: View {
    @State private var resources: [Resource] = []
    @State private var showingEditView = false
    @State private var selectedResource: Resource?
    
    var body: some View {
        List {
            Section {
                ForEach(resources) { resource in
                    Button {
                        selectedResource = resource
                        showingEditView = true
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(resource.title)
                                .font(.body.weight(.bold))
                                .foregroundStyle(.primary)
                            Text(resource.category.rawValue)
                                .font(.caption)
                                .foregroundStyle(Color.secondaryText)
                        }
                        .padding(.vertical, 4)
                    }
                }
                .onDelete(perform: deleteResources)
            } header: {
                AppSectionHeader(
                    title: "Resources",
                    systemImage: "book.closed.fill",
                    actionTitle: "Add",
                    action: {
                        selectedResource = nil
                        showingEditView = true
                    }
                )
                .tint(.triadPrimary)
            }
        }
                #if os(iOS)
        .listStyle(.insetGrouped)
        #else
        .listStyle(.sidebar)
        #endif
        .appListBackground()
        .navigationTitle(String(localized: "Manage Resources"))
        .sheet(isPresented: $showingEditView) {
            NavigationStack {
                ResourceEditView(resource: selectedResource) { updatedResource in
                    if let _ = selectedResource {
                        ResourcesManager.shared.updateResource(updatedResource)
                    } else {
                        ResourcesManager.shared.addResource(updatedResource)
                    }
                    loadResources()
                }
            }
        }
        .onAppear(perform: loadResources)
    }
    
    private func loadResources() {
        resources = ResourcesManager.shared.getAllResources()
    }
    
    private func deleteResources(at offsets: IndexSet) {
        for index in offsets {
            ResourcesManager.shared.deleteResource(id: resources[index].id)
        }
        loadResources()
    }
}

struct ResourceEditView: View {
    @Environment(\.dismiss) var dismiss
    
    let resource: Resource?
    let onSave: (Resource) -> Void
    
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var category: ResourceCategory = .legal
    @State private var url: String = ""
    @State private var tags: String = ""
    
    var body: some View {
        Form {
            Section(header: Text(String(localized: "Details"))) {
                TextField(String(localized: "Title"), text: $title)
                TextField(String(localized: "Description"), text: $description, axis: .vertical)
                    .lineLimit(3...5)
                
                Picker(String(localized: "Category"), selection: $category) {
                    ForEach(ResourceCategory.allCases, id: \.self) { category in
                        Text(category.rawValue).tag(category)
                    }
                }
                
                TextField(String(localized: "URL (Optional)"), text: $url)
                    #if os(iOS)
                    .keyboardType(.URL)
                    .textInputAutocapitalization(.never)
                    #endif
            }
            
            Section(header: Text(String(localized: "Tags"))) {
                TextField(String(localized: "Tags (comma separated)"), text: $tags)
            }
        }
        .navigationTitle(resource == nil ? String(localized: "New Resource") : String(localized: "Edit Resource"))
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(String(localized: "Cancel")) { dismiss() }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button(String(localized: "Save")) {
                    let tagList = tags.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
                    let newResource = Resource(
                        id: resource?.id ?? UUID(),
                        title: title,
                        description: description,
                        category: category,
                        url: url.isEmpty ? nil : url,
                        tags: tagList,
                        dateAdded: resource?.dateAdded ?? Date()
                    )
                    onSave(newResource)
                    dismiss()
                }
                .disabled(title.isEmpty || description.isEmpty)
            }
        }
        .onAppear {
            if let r = resource {
                title = r.title
                description = r.description
                category = r.category
                url = r.url ?? ""
                tags = r.tags.joined(separator: ", ")
            }
        }
    }
}
