//
//  ShareManager.swift
//  Disability Advocacy macOS
//
//  Native macOS share sheet manager using NSSharingServicePicker
//

#if os(macOS)
import AppKit
import SwiftUI

@MainActor
class ShareManager: ObservableObject {
    static let shared = ShareManager()
    
    private init() {}
    
    /// Shares a URL using the native macOS share sheet
    /// - Parameters:
    ///   - url: The URL to share
    ///   - sourceView: The view to anchor the share sheet from
    func shareURL(_ url: URL, from sourceView: NSView) {
        let sharingServicePicker = NSSharingServicePicker(items: [url])
        sharingServicePicker.show(relativeTo: .zero, of: sourceView, preferredEdge: .minY)
    }
    
    /// Shares text using the native macOS share sheet
    /// - Parameters:
    ///   - text: The text to share
    ///   - sourceView: The view to anchor the share sheet from
    func shareText(_ text: String, from sourceView: NSView) {
        let sharingServicePicker = NSSharingServicePicker(items: [text])
        sharingServicePicker.show(relativeTo: .zero, of: sourceView, preferredEdge: .minY)
    }
    
    /// Shares multiple items using the native macOS share sheet
    /// - Parameters:
    ///   - items: Array of items to share (URL, String, etc.)
    ///   - sourceView: The view to anchor the share sheet from
    func shareItems(_ items: [Any], from sourceView: NSView) {
        let sharingServicePicker = NSSharingServicePicker(items: items)
        sharingServicePicker.show(relativeTo: .zero, of: sourceView, preferredEdge: .minY)
    }
    
    /// Shares a resource with formatted details
    /// - Parameters:
    ///   - resource: The resource to share
    ///   - sourceView: The view to anchor the share sheet from
    func shareResource(_ resource: Resource, from sourceView: NSView) {
        var shareItems: [Any] = []
        
        // Add title and description
        let shareText = """
        \(resource.title)
        
        \(resource.description)
        
        Category: \(resource.category.rawValue)
        """
        shareItems.append(shareText)
        
        // Add URL if available
        if let urlString = resource.url, let url = URL(string: urlString) {
            shareItems.append(url)
        }
        
        shareItems(items: shareItems, from: sourceView)
    }
    
    /// Shares an event with formatted details
    /// - Parameters:
    ///   - event: The event to share
    ///   - sourceView: The view to anchor the share sheet from
    func shareEvent(_ event: Event, from sourceView: NSView) {
        var shareItems: [Any] = []
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        var shareText = """
        \(event.title)
        
        \(event.description)
        
        Date: \(dateFormatter.string(from: event.date))
        Location: \(event.location)
        """
        
        if event.isVirtual {
            shareText += "\nVirtual Event"
        }
        
        if let registrationURL = event.registrationURL {
            shareText += "\nRegistration: \(registrationURL)"
        }
        
        if let accessibilityNotes = event.accessibilityNotes {
            shareText += "\n\nAccessibility: \(accessibilityNotes)"
        }
        
        shareItems.append(shareText)
        
        // Add URLs if available
        if let registrationURL = event.registrationURL, let url = URL(string: registrationURL) {
            shareItems.append(url)
        }
        
        if let eventURL = event.eventURL, let url = URL(string: eventURL) {
            shareItems.append(url)
        }
        
        shareItems(items: shareItems, from: sourceView)
    }
    
    /// Shares a news article with formatted details
    /// - Parameters:
    ///   - article: The article to share
    ///   - sourceView: The view to anchor the share sheet from
    func shareArticle(_ article: NewsArticle, from sourceView: NSView) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        
        let shareText = """
        \(article.title)
        
        \(article.summary)
        
        Source: \(article.source)
        Date: \(dateFormatter.string(from: article.date))
        Category: \(article.category)
        """
        
        shareText(shareText, from: sourceView)
    }
}
#endif
