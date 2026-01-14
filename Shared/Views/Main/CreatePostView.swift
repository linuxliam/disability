//
//  CreatePostView.swift
//  Disability Advocacy iOS
//
//  View for creating new community posts
//

import SwiftUI

@MainActor
struct CreatePostView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(AppState.self) var appState
    @State private var viewModel: CreatePostViewModel
    @State private var selectedCategoryString: String = PostCategory.discussion.rawValue
    
    init(communityViewModel: CommunityViewModel) {
        _viewModel = State(initialValue: CreatePostViewModel(communityViewModel: communityViewModel))
    }

    private var selectedCategory: PostCategory {
        PostCategory(rawValue: selectedCategoryString) ?? .discussion
    }
    @State private var title = ""
    @State private var content = ""
    @FocusState private var focusedField: Field?
    
    enum Field {
        case title
        case content
    }
    
    private var canPost: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty &&
        !content.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var body: some View {
        Form {
            Section {
                Picker(selection: $selectedCategoryString) {
                    ForEach(PostCategory.allCases, id: \.rawValue) { category in
                        HStack {
                            Image(systemName: category.icon)
                            Text(category.rawValue)
                        }
                        .tag(category.rawValue)
                    }
                } label: {
                    Text(String(localized: "Category"))
                }
            } header: {
                Text(String(localized: "Post Category"))
            }
            
            Section {
                TextField(String(localized: "Post Title"), text: $title)
                    .focused($focusedField, equals: .title)
            } header: {
                Text(String(localized: "Title"))
            } footer: {
                Text(String(localized: "Choose a clear, descriptive title for your post"))
            }
            
            Section {
                TextEditor(text: $content)
                    .frame(minHeight: 200)
                    .focused($focusedField, equals: .content)
            } header: {
                Text(String(localized: "Content"))
            } footer: {
                Text(String(localized: "Share your thoughts, questions, or experiences with the community"))
            }
        }
        .navigationTitle(String(localized: "New Post"))
        .platformInlineNavigationTitle()
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(String(localized: "Cancel")) {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button(String(localized: "Post")) {
                    Task {
                        await viewModel.createPost(
                            title: title,
                            content: content,
                            category: selectedCategory
                        )
                        appState.feedback.success(String(localized: "Post created successfully"))
                        dismiss()
                    }
                }
                .fontWeight(.semibold)
                .disabled(!canPost)
            }
        }
    }
}

import Observation

@MainActor
@Observable
class CreatePostViewModel {
    private let communityViewModel: CommunityViewModel
    
    nonisolated init(communityViewModel: CommunityViewModel) {
        self.communityViewModel = communityViewModel
    }
    
    func createPost(title: String, content: String, category: PostCategory) async {
        // Get the current user's name for the author field
        let authorName: String
        if let user = UserManager.shared.currentUser, !user.name.isEmpty {
            authorName = user.name
        } else {
            // Fallback to a default name if no user is set
            authorName = "Anonymous User"
        }
        
        // Create the new post
        let newPost = CommunityPost(
            author: authorName,
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            content: content.trimmingCharacters(in: .whitespacesAndNewlines),
            category: category,
            datePosted: Date(),
            replies: [],
            likes: 0
        )
        
        // Add the post to the community view model
        communityViewModel.addPost(newPost)
        
        AppLogger.info("Post created successfully: \(newPost.title)", log: AppLogger.general)
    }
}



