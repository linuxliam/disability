//
//  CommunityView.swift
//  Disability Advocacy iOS
//
//  Community discussion forum
//

import SwiftUI

struct CommunityView: View {
    @Environment(AppState.self) var appState
    @State private var viewModel = CommunityViewModel()
    @State private var showCreatePost = false
    @State private var selectedCategory: PostCategory?
    
    var filteredPosts: [CommunityPost] {
        var posts = viewModel.posts
        
        if let category = selectedCategory {
            posts = posts.filter { $0.category == category }
        }
        
        return posts.sorted { $0.datePosted > $1.datePosted }
    }
    
    // MARK: - Filter Buttons
    private var filterButtonRow: some View {
        Picker(String(localized: "Category"), selection: $selectedCategory) {
            Text(String(localized: "All Categories")).tag(Optional<PostCategory>.none)
            ForEach(PostCategory.allCases, id: \.self) { category in
                Text(category.rawValue).tag(Optional(category))
            }
        }
        .pickerStyle(.menu)
        .padding(.horizontal, LayoutConstants.screenHorizontalPadding)
    }
    
    var body: some View {
        Group {
            if viewModel.isLoading && viewModel.posts.isEmpty {
                VStack(spacing: 0) {
                    // Filter row placeholder
                    HStack {
                        SkeletonView()
                            .frame(width: 120, height: 32)
                            .cornerRadius(8)
                        Spacer()
                    }
                    .padding(.horizontal, LayoutConstants.screenHorizontalPadding)
                    .padding(.top, LayoutConstants.paddingM)
                    .padding(.bottom, LayoutConstants.paddingS)
                    
                    // List skeletons
                    List {
                        ForEach(0..<8) { _ in
                            PostSkeletonRow()
                        }
                    }
                    .listStyle(.plain)
                    .appListBackground()
                }
            } else {
                VStack(spacing: 0) {
                    // Simplified Category Picker
                    filterButtonRow
                        .padding(.top, LayoutConstants.paddingM)
                        .padding(.bottom, LayoutConstants.paddingS)
                    
                    // Posts List
                    if filteredPosts.isEmpty && !viewModel.isLoading {
                        AppEmptyState(
                            title: "No posts found",
                            systemImage: "person.3",
                            description: selectedCategory != nil
                                ? "Try selecting a different category or clearing the filter."
                                : "Be the first to start a discussion!"
                        )
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        Group {
                            #if os(macOS)
                            GeometryReader { geometry in
                                ScrollView {
                                    VStack(alignment: .leading, spacing: LayoutConstants.sectionHeaderSpacing) {
                                        AppSectionHeader(
                                            title: selectedCategory != nil ? LocalizedStringKey(selectedCategory!.rawValue) : "Community Discussions",
                                            systemImage: "bubble.left.and.bubble.right.fill"
                                        )
                                        .padding(.bottom, LayoutConstants.spacingS)
                                        
                                        LazyVGrid(columns: AdaptiveLayout.gridColumns(for: .regular, availableWidth: geometry.size.width), spacing: LayoutConstants.cardGap) {
                                            ForEach(filteredPosts) { post in
                                                NavigationLink(value: post) {
                                                    CommunityPostGridCard(post: post)
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
                                    ForEach(filteredPosts) { post in
                                        NavigationLink(value: post) {
                                            CommunityPostRow(post: post)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                } header: {
                                    AppSectionHeader(
                                        title: selectedCategory != nil ? LocalizedStringKey(selectedCategory!.rawValue) : "Community Discussions",
                                        systemImage: "bubble.left.and.bubble.right.fill"
                                    )
                                }
                            }
                            .listStyle(.insetGrouped)
                            #endif
                        }
                        .appListBackground()
                    }
                }
            }
        }
        .navigationTitle(String(localized: "Community"))
        .platformInlineNavigationTitle()
        .toolbar {
            ToolbarItem(placement: PlatformUI.trailingToolbarItemPlacement) {
                Button(action: {
                    HapticManager.light()
                    showCreatePost = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundStyle(.tint)
                }
                .accessibilityLabel(String(localized: "New Post"))
            }
            
            ToolbarItem(placement: PlatformUI.trailingToolbarItemPlacement) {
                ProfileToolbarButton()
            }
        }
        .sheet(isPresented: $showCreatePost) {
            NavigationStack {
                CreatePostView()
            }
        }
        .appScreenChrome()
        .task {
            if viewModel.posts.isEmpty {
                viewModel.loadPosts()
            }
        }
        .refreshable {
            viewModel.loadPosts()
        }
    }
}

struct CommunityPostRow: View {
    let post: CommunityPost
    
    var body: some View {
        VStack(alignment: .leading, spacing: LayoutConstants.spacingS) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(post.title)
                        .font(.body.weight(.bold))
                        .foregroundStyle(.primary)
                        .lineLimit(2)
                    
                    Text(post.content)
                        .lineLimit(2)
                        .secondaryBody()
                }
                
                Spacer()
                
                AppChip(text: post.category.rawValue, style: .tertiary)
            }
            
            HStack {
                Label(post.author, systemImage: "person.circle")
                    .emphasizedCaption()
                
                Spacer()
                
                HStack(spacing: LayoutConstants.spacingM) {
                    Label("\(post.likes)", systemImage: "heart.fill")
                        .foregroundStyle(.triadSecondary)
                    Label("\(post.replies.count)", systemImage: "bubble.right.fill")
                        .foregroundStyle(.triadPrimary)
                }
                .font(.caption.weight(.bold))
            }
        }
        .padding(.vertical, 8)
    }
}

struct PostDetailView: View {
    let post: CommunityPost
    @Environment(AppState.self) var appState
    
    var body: some View {
        List {
            // Header Card Section
            Section {
                AppDetailHeader(
                    title: post.title,
                    subtitle: nil,
                    icon: post.category.icon,
                    iconColor: .triadPrimary,
                    chipText: post.category.rawValue,
                    chipStyle: .tertiary
                ) {
                    VStack(alignment: .trailing, spacing: 4) {
                        Text(post.datePosted, style: .date)
                            .font(.caption)
                            .foregroundStyle(.tertiaryText)
                        
                        Label(post.author, systemImage: "person.circle.fill")
                            .emphasizedCaption()
                    }
                }
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
            }
            
            // Content Section
            Section {
                Text(post.content)
                    .font(.body)
                    .foregroundStyle(.primary)
                    .padding(.vertical, 4)
            } header: {
                Text(String(localized: "Discussion"))
            }
            
            // Replies Section
            if !post.replies.isEmpty {
                Section {
                    ForEach(post.replies) { reply in
                        VStack(alignment: .leading, spacing: LayoutConstants.spacingS) {
                            HStack {
                                Label(reply.author, systemImage: "person.circle.fill")
                                    .font(.subheadline.weight(.semibold))
                                Spacer()
                            }
                            
                            Text(reply.content)
                                .font(.body)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 8)
                    }
                } header: {
                    Text(String(localized: "Replies"))
                }
            }
        }
        #if os(iOS)
        .listStyle(.insetGrouped)
        #else
        .listStyle(.inset)
        #endif
        .navigationTitle(String(localized: "Post Details"))
        .appScreenChrome()
        .frame(maxWidth: AdaptiveLayout.contentMaxWidth(for: .regular))
        .frame(maxWidth: .infinity)
    }
}


