//
//  NewsViewModel.swift
//  Disability Advocacy
//
//  View model for news view
//

import Foundation
import Observation

@MainActor
@Observable
class NewsViewModel: BaseViewModelProtocol {
    var articles: [NewsArticle] = []
    var isLoading: Bool = false
    var errorMessage: String?
    var showError: Bool = false
    
    private var loadTask: Task<Void, Never>?
    
    nonisolated init() {
        // Empty initializer - all properties are initialized with default values
        // Actual initialization happens on MainActor when properties are accessed
    }
    
    func loadArticles() {
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
            
            // Sample news articles
            articles = [
                NewsArticle(
                    title: "New Federal Guidelines Expand Disability Rights in Digital Spaces",
                    summary: "The Department of Justice has released updated guidelines requiring all federal websites and digital services to meet WCAG 2.1 Level AA standards, marking a significant step forward for digital accessibility.",
                    date: Date().addingTimeInterval(-86400 * 2),
                    source: "Disability Rights News",
                    category: "Policy"
                ),
                NewsArticle(
                    title: "Breakthrough in Assistive Technology: New Voice Control System",
                    summary: "Researchers have developed a new voice control system that can be customized for individuals with speech disabilities, offering more accurate recognition and personalization options.",
                    date: Date().addingTimeInterval(-86400 * 5),
                    source: "Tech for Accessibility",
                    category: "Technology"
                ),
                NewsArticle(
                    title: "Community Rally Successfully Advocates for Improved Public Transit",
                    summary: "Local disability advocates successfully organized a rally that led to commitments from city officials to improve accessibility in public transportation, including new accessible bus stops and training for drivers.",
                    date: Date().addingTimeInterval(-86400 * 7),
                    source: "Local Advocacy Network",
                    category: "Community"
                )
            ]
        } catch {
            handleError(error)
        }
    }
    
}


