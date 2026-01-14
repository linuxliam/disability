//
//  NewsView.swift
//  Disability Advocacy iOS
//
//  News and updates feed
//

import SwiftUI

@MainActor
struct NewsView: View {
    @Environment(AppState.self) var appState
    @State private var viewModel = NewsViewModel()
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                LoadingView(message: String(localized: "Loading news..."))
            } else if viewModel.articles.isEmpty {
                EmptyStateView(
                    icon: "newspaper",
                    title: String(localized: "No articles available"),
                    message: String(localized: "Check back soon for the latest news and updates.")
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                Group {
                    #if os(macOS)
                    GeometryReader { geometry in
                        ScrollView {
                            LazyVGrid(columns: AdaptiveLayout.gridColumns(for: .regular, availableWidth: geometry.size.width), spacing: LayoutConstants.cardGap) {
                                ForEach(viewModel.articles) { article in
                                    NavigationLink(value: article) {
                                        NewsArticleGridCard(article: article)
                                    }
                                    .buttonStyle(.plain)
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
                    List(viewModel.articles) { article in
                        NavigationLink(value: article) {
                            NewsArticleRow(article: article)
                        }
                        .buttonStyle(.plain)
                        .contentShape(Rectangle())
                    }
                            #if os(iOS)
        .listStyle(.insetGrouped)
        #else
        .listStyle(.sidebar)
        #endif
                    .scrollDismissesKeyboard(.interactively)
                    #endif
                }
                .appListBackground()
            }
        }
        .navigationTitle(String(localized: "News & Updates"))
        .platformInlineNavigationTitle()
        .toolbar {
            ToolbarItem(placement: PlatformUI.trailingToolbarItemPlacement) {
                ProfileToolbarButton()
            }
        }
        .appScreenChrome()
        .task {
            if viewModel.articles.isEmpty {
                viewModel.loadArticles()
            }
        }
        .refreshable {
            viewModel.loadArticles()
        }
    }
}

struct NewsArticle: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let summary: String
    let date: Date
    let source: String
    let category: String
}

struct NewsArticleRow: View {
    let article: NewsArticle
    
    var body: some View {
        VStack(alignment: .leading, spacing: LayoutConstants.spacingS) {
            HStack {
                AppChip(text: article.category, style: .primary)
                
                Spacer()
                
                Text(article.date, style: .date)
                    .captionText()
            }
            
            Text(article.title)
                .font(.body.weight(.bold))
                .foregroundStyle(.primary)
                .lineLimit(2)
            
            Text(article.summary)
                .lineLimit(3)
                .secondaryBody()
            
            Text(String(format: String(localized: "Source: %@"), article.source))
                .emphasizedCaption()
        }
        .padding(.vertical, LayoutConstants.paddingS)
        .contentShape(Rectangle())
    }
}

struct ArticleDetailView: View {
    let article: NewsArticle
    
    var body: some View {
        List {
            // Header Card Section
            Section {
                AppDetailHeader(
                    title: article.title,
                    subtitle: (nil as String?),
                    icon: "newspaper.fill",
                    iconColor: Color.triadPrimary,
                    chipText: article.category,
                    chipStyle: .primary
                ) {
                    Text(article.date, style: .date)
                        .captionText()
                }
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
            }
            
            // Article Content Section
            Section {
                Text(article.summary)
                    .standardBody()
                    .padding(.vertical, 4)
            } header: {
                Text(String(localized: "Summary"))
            }
            
            // Share Action Section
            Section {
                AppShareButton(
                    item: .article(article),
                    label: "Share Article",
                    systemImage: "square.and.arrow.up",
                    style: .button
                )
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color.accentColor, in: RoundedRectangle(cornerRadius: 12))
                .foregroundStyle(.white)
                .buttonStyle(.plain)
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets())
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
        .navigationTitle("Article")
        .appScreenChrome()
        .frame(maxWidth: AdaptiveLayout.contentMaxWidth(for: .regular))
        .frame(maxWidth: .infinity)
    }
}


