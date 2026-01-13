//
//  CommunityViewModel.swift
//  Disability Advocacy
//
//  View model for community view
//

import Foundation
import Observation

@MainActor
@Observable
class CommunityViewModel: BaseViewModelProtocol {
    var posts: [CommunityPost] = []
    var isLoading: Bool = false
    var errorMessage: String?
    var showError: Bool = false
    
    private var loadTask: Task<Void, Never>?
    
    func loadPosts() {
        loadTask?.cancel()
        
        guard !isLoading else { return }
        
        isLoading = true
        clearError()
        
        loadTask = Task {
            await performLoad()
        }
    }
    
    private func performLoad() async {
        defer { isLoading = false }
        
        guard !Task.isCancelled else { return }
        
        do {
            // Simulate async loading
            try await Task.sleep(nanoseconds: AppConstants.Timing.simulatedLoadDelay)
            
            guard !Task.isCancelled else { return }
            
            // Sample community posts
            posts = [
            CommunityPost(
                author: "Sarah M.",
                title: "New ADA Guidelines for Public Spaces",
                content: "I wanted to share some important updates about the new ADA guidelines that were recently published. These changes will affect how public spaces are designed and could have significant impact on accessibility in our communities. Let's discuss what this means for us.",
                category: .discussion,
                likes: 24
            ),
            CommunityPost(
                author: "Michael T.",
                title: "Looking for Employment Resources",
                content: "I'm currently job searching and looking for resources that can help with accommodations in the workplace. Has anyone had experience with requesting reasonable accommodations? What worked for you?",
                category: .support,
                replies: [
                    Reply(author: "Jennifer L.", content: "I've had great success with Job Accommodation Network. They have excellent resources!"),
                    Reply(author: "David K.", content: "Make sure to document everything and work with HR early in the process.")
                ],
                likes: 18
            ),
            CommunityPost(
                author: "Advocacy Team",
                title: "Upcoming Rally for Disability Rights",
                content: "Join us this Saturday at City Hall for a rally to advocate for improved public transportation accessibility. We'll be meeting at 10 AM. All are welcome!",
                category: .advocacy,
                likes: 45
            )
            ]
        } catch {
            handleError(error)
        }
    }
    
    /// Adds a new post to the community feed
    func addPost(_ post: CommunityPost) {
        // Add the new post at the beginning of the array (most recent first)
        posts.insert(post, at: 0)
        AppLogger.info("Post added to community: \(post.title)", log: AppLogger.general)
    }
    
}

