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
    @State private var viewModel = CreatePostViewModel()
    @State private var selectedCategoryString: String = PostCategory.discussion.rawValue

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
                    viewModel.createPost(
                        title: title,
                        content: content,
                        category: selectedCategory
                    )
                    appState.feedback.success(String(localized: "Post created successfully"))
                    dismiss()
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
    func createPost(title: String, content: String, category: PostCategory) {
        // In a real implementation, this would send the post to an API
        // For now, we'll just log it
        AppLogger.info("Creating post: \(title)", log: AppLogger.general)
        
        // TODO: Integrate with CommunityViewModel to add the post
        // This requires backend integration
    }
}



