//
//  ResourcesView.swift
//  Disability Advocacy iOS
//
//  Resource library with search and filtering
//

import SwiftUI

@MainActor
struct ResourcesView: View {
    @Environment(AppState.self) private var appState: AppState
    @State private var viewModel = ResourcesViewModel()
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        ResourcesContentView(
            viewModel: viewModel
        )
        .navigationTitle(String(localized: "Resources"))
        .platformInlineNavigationTitle()
        .toolbar {
            ToolbarItem(placement: PlatformUI.trailingToolbarItemPlacement) {
                ProfileToolbarButton()
            }
        }
        .task {
            if viewModel.resources.isEmpty {
                viewModel.loadResources()
            }
        }
        .refreshable {
            viewModel.loadResources()
        }
        .appScreenChrome()
    }
}

// MARK: - Resources View With Category (for navigation from HomeView)
@MainActor
struct ResourcesViewWithCategory: View {
    @Environment(AppState.self) private var appState: AppState
    @State private var viewModel = ResourcesViewModel()
    let initialCategory: ResourceCategory
    
    var body: some View {
        ResourcesContentView(
            viewModel: viewModel
        )
        .navigationTitle(String(localized: "Resources"))
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                if viewModel.selectedCategory != nil {
                    Button(String(localized: "Clear")) {
                        HapticManager.light()
                        viewModel.selectedCategory = nil
                    }
                }
            }
        }
        .task {
            if viewModel.resources.isEmpty {
                viewModel.loadResources()
            }
            viewModel.selectedCategory = initialCategory
        }
        .refreshable {
            viewModel.loadResources()
        }
    }
}

// MARK: - Resources Content View (for navigation destinations)
@MainActor
struct ResourcesContentView: View {
    @Environment(AppState.self) private var appState: AppState
    @Bindable var viewModel: ResourcesViewModel

    // Helper to access appState in complex view expressions
    private var environmentAppState: AppState {
        appState
    }
    
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    private var emptyStateMessage: String {
        if viewModel.selectedCategory != nil || viewModel.selectedTag != nil {
            return String(localized: "Try selecting a different category or tag, or clearing the filters.")
        } else if !viewModel.searchText.isEmpty {
            return String(localized: "Try adjusting your search terms.")
        } else {
            return String(localized: "No resources available at this time.")
        }
    }

    // MARK: - Filter Buttons
    private var filterButtonRow: some View {
        VStack(spacing: LayoutConstants.spacingS) {
            Picker(String(localized: "Category"), selection: $viewModel.selectedCategory) {
                Text(String(localized: "All Categories")).tag(Optional<ResourceCategory>.none)
                ForEach(ResourceCategory.allCases, id: \.self) { category in
                    Text(category.rawValue).tag(Optional(category))
                }
            }
            .pickerStyle(.menu)
            
            if !viewModel.availableTags.isEmpty {
                Picker(String(localized: "Tag"), selection: $viewModel.selectedTag) {
                    Text(String(localized: "All Tags")).tag(Optional<String>.none)
                    ForEach(viewModel.availableTags, id: \.self) { tag in
                        Text(tag).tag(Optional(tag))
                    }
                }
                .pickerStyle(.menu)
            }
        }
        .padding(.horizontal, LayoutConstants.screenHorizontalPadding)
    }
    
    @ViewBuilder
    private var loadingView: some View {
        VStack(spacing: 0) {
            // Search bar placeholder
            SearchBar(text: .constant(""))
                .padding(.horizontal, LayoutConstants.screenHorizontalPadding)
                .padding(.top, LayoutConstants.paddingM)
                .padding(.bottom, LayoutConstants.paddingS)
                .disabled(true)

            // Filter row placeholder
            HStack {
                SkeletonView()
                    .frame(width: 120, height: 32)
                    .cornerRadius(8)
                Spacer()
            }
            .padding(.horizontal, LayoutConstants.screenHorizontalPadding)
            .padding(.bottom, LayoutConstants.paddingM)

            // List skeletons
            List {
                ForEach(0..<6) { _ in
                    ResourceSkeletonRow()
                }
            }
            .listStyle(.plain)
        }
    }

    @ViewBuilder
    private var errorView: some View {
        EmptyStateView(
            icon: "exclamationmark.triangle",
            title: String(localized: "Unable to Load Resources"),
            message: viewModel.errorMessage ?? ""
        )
    }

    var body: some View {
        Group {
            if viewModel.isLoading && viewModel.resources.isEmpty {
                loadingView
            } else if let _ = viewModel.errorMessage {
                errorView
            } else {
                contentView
            }
        }
        .refreshable {
            viewModel.loadResources()
        }
    }

    @ViewBuilder
    private var searchAndFilterSection: some View {
        VStack(spacing: 0) {
            // Enhanced Search Bar
            SearchBar(text: $viewModel.searchText)
                .padding(.horizontal, LayoutConstants.screenHorizontalPadding)
                .padding(.top, LayoutConstants.paddingM)
                .padding(.bottom, LayoutConstants.paddingS)

            // Category Picker
            filterButtonRow
                .padding(.bottom, LayoutConstants.paddingM)
                .background(Color.groupedBackground)
        }
    }

    @ViewBuilder
    private var emptyStateView: some View {
        EmptyStateView(
            icon: "magnifyingglass",
            title: String(localized: "No resources found"),
            message: emptyStateMessage,
            primaryActionTitle: (viewModel.selectedCategory != nil || viewModel.selectedTag != nil || !viewModel.searchText.isEmpty) ? String(localized: "Clear all filters") : nil,
            primaryAction: { viewModel.clearFilters() }
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    @ViewBuilder
    private var resourcesListView: some View {
        #if os(macOS)
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading, spacing: LayoutConstants.sectionHeaderSpacing) {
                    AppSectionHeader(
                        title: viewModel.selectedCategory != nil ? LocalizedStringKey(viewModel.selectedCategory!.rawValue) : "All Resources",
                        systemImage: viewModel.selectedCategory?.icon ?? "books.vertical.fill",
                        subtitle: !viewModel.searchText.isEmpty ? "Searching for \"\(viewModel.searchText)\"" : nil
                    )
                    .padding(.bottom, LayoutConstants.spacingS)
                    
                    LazyVGrid(columns: AdaptiveLayout.gridColumns(for: .regular, availableWidth: geometry.size.width), spacing: LayoutConstants.cardGap) {
                        ForEach(viewModel.filteredResources) { resource in
                            NavigationLink(value: resource) {
                                ResourceCard(resource: resource)
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
                ForEach(viewModel.filteredResources) { resource in
                    NavigationLink(value: resource) {
                        ResourceListRow(resource: resource)
                    }
                }
            } header: {
                AppSectionHeader(
                    title: viewModel.selectedCategory != nil ? LocalizedStringKey(viewModel.selectedCategory!.rawValue) : "All Resources",
                    systemImage: viewModel.selectedCategory?.icon ?? "books.vertical.fill",
                    subtitle: !viewModel.searchText.isEmpty ? "Searching for \"\(viewModel.searchText)\"" : nil
                )
            }
        }
                #if os(iOS)
        .listStyle(.insetGrouped)
        #else
        .listStyle(.sidebar)
        #endif
        .scrollContentBackground(.hidden)
        #endif
    }

    @ViewBuilder
    private var contentView: some View {
        VStack(spacing: 0) {
            searchAndFilterSection

            // Resources List
            if viewModel.filteredResources.isEmpty && !viewModel.isLoading {
                emptyStateView
            } else {
                resourcesListView
            }
        }
        .appListBackground()
        .appContentFrame()
    }

}

@MainActor
struct ResourceListRow: View {
    let resource: Resource
    @Environment(AppState.self) private var appState: AppState
    
    private var isFavorite: Bool {
        appState.favoriteResources.contains(resource.id)
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: LayoutConstants.spacingM) {
            // Category Icon
            Image(systemName: resource.category.icon)
                .font(.title3)
                .foregroundStyle(.tint)
                .frame(width: LayoutConstants.iconSizeXL, height: LayoutConstants.iconSizeXL)
                .accessibilityHidden(true)
            
            // Resource Details
            VStack(alignment: .leading, spacing: LayoutConstants.spacingXS) {
                Text(resource.title)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                    .accessibilityAddTraits(.isHeader)
                
                Text(resource.description)
                    .font(.subheadline)
                    .foregroundStyle(Color.secondaryText)
                    .lineLimit(2)
                
                HStack(spacing: LayoutConstants.spacingS) {
                    Label(
                        resource.category.rawValue,
                        systemImage: "tag.fill"
                    )
                    .font(.caption)
                    .foregroundStyle(Color.secondaryText)
                    
                    if isFavorite {
                        Label(String(localized: "Favorited"), systemImage: "heart.fill")
                            .font(.caption)
                            .foregroundStyle(.tint)
                    }
                }
            }
        }
        .padding(.vertical, LayoutConstants.paddingXS)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(resource.title), \(resource.category.rawValue)")
    }
}

@MainActor
struct ResourceDetailView: View {
    let resource: Resource
    @Environment(AppState.self) private var appState: AppState
    @Environment(\.dismiss) var dismiss
    
    private var isFavorite: Bool {
        appState.favoriteResources.contains(resource.id)
    }
    
    var body: some View {
        List {
            Section {
                AppDetailHeader(
                    title: resource.title,
                    subtitle: nil,
                    icon: resource.category.icon,
                    iconColor: .triadPrimary,
                    chipText: resource.category.rawValue,
                    chipStyle: .primary
                ) {
                    Button(action: {
                        HapticManager.light()
                        Task { await appState.toggleFavorite(resource.id) }
                    }) {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .foregroundStyle(isFavorite ? .red : .tertiaryText)
                            .font(.title3.weight(.semibold))
                    }
                    .buttonStyle(.plain)
                }
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
            }
            
            Section("About") {
                Text(resource.description)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .padding(.vertical, 4)
            }
            
            if !resource.tags.isEmpty {
                Section("Tags") {
                    FlowLayout(spacing: 8) {
                        ForEach(resource.tags, id: \.self) { tag in
                            Text(tag)
                                .font(.caption2.weight(.medium))
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(Color.accentColor.opacity(0.1))
                                .foregroundStyle(.tint)
                                .cornerRadius(8)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            
            Section {
                actionButtons
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
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
        .navigationTitle(String(localized: "Resource Details"))
        .appScreenChrome()
        .frame(maxWidth: AdaptiveLayout.contentMaxWidth(for: .regular))
        .frame(maxWidth: .infinity)
    }
    
    private var actionButtons: some View {
        VStack(spacing: 12) {
            if let urlString = resource.url, let url = URL(string: urlString) {
                Link(destination: url) {
                    Label(String(localized: "Visit Website"), systemImage: "safari.fill")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(Color.accentColor)
                        .cornerRadius(12)
                }
                
                HStack(spacing: 12) {
                    AppShareButton(
                        item: .url(url),
                        label: String(localized: "Share"),
                        systemImage: "square.and.arrow.up",
                        style: .button
                    )
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.primary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(Color.secondary.opacity(0.1))
                    .cornerRadius(12)
                    
                    Button(action: {
                        PlatformUI.copyToClipboard(urlString)
                        Task { @MainActor in
                            HapticManager.success()
                            appState.feedback.success(String(localized: "URL copied"))
                        }
                    }) {
                        Label(String(localized: "Copy"), systemImage: "doc.on.doc")
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(.primary)
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(Color.secondary.opacity(0.1))
                            .cornerRadius(12)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(.horizontal, LayoutConstants.screenHorizontalPadding)
    }
}

// Simple FlowLayout helper for tags
struct FlowLayout: View {
    let spacing: CGFloat
    let content: [AnyView]
    
    init<Views: View>(spacing: CGFloat = 8, @ViewBuilder content: @escaping () -> Views) {
        self.spacing = spacing
        self.content = [AnyView(content())]
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            // Simplified for now - can be enhanced with a real FlowLayout if needed
            HStack(wrap: true, spacing: spacing) {
                ForEach(0..<content.count, id: \.self) { index in
                    content[index]
                }
            }
        }
    }
}

extension HStack {
    init(wrap: Bool, spacing: CGFloat?, @ViewBuilder content: () -> Content) {
        self.init(spacing: spacing, content: content)
    }
}

// MARK: - Search Bar Component (Enhanced)
struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        EnhancedSearchBar(text: $text, placeholder: String(localized: "Search resources..."))
            .accessibilityIdentifier("searchResourcesTextField")
            .accessibilityHint(String(localized: "Double tap to clear the search text"))
    }
}
