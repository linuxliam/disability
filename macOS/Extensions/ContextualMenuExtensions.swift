//
//  ContextualMenuExtensions.swift
//  Disability Advocacy
//
//  Contextual menu (right-click) support
//

import SwiftUI
#if os(macOS)
import AppKit
#endif

#if os(macOS)
extension View {
    /// Adds contextual menu for resources
    func resourceContextMenu(
        resource: Resource,
        appState: AppState,
        onShare: @escaping () -> Void
    ) -> some View {
        self.contextMenu {
            Button(action: {
                Task {
                    await appState.toggleFavorite(resource.id)
                }
            }) {
                Label(
                    appState.favoriteResources.contains(resource.id) ? "Remove from Favorites" : "Add to Favorites",
                    systemImage: appState.favoriteResources.contains(resource.id) ? "heart.slash" : "heart.fill"
                )
            }
            
            if let urlString = resource.url, let url = URL(string: urlString) {
                Divider()
                
                Button(action: {
                    NSWorkspace.shared.open(url)
                }) {
                    Label("Open in Browser", systemImage: "safari")
                }
                
                Button(action: {
                    let pasteboard = NSPasteboard.general
                    pasteboard.clearContents()
                    pasteboard.setString(urlString, forType: .string)
                }) {
                    Label("Copy Link", systemImage: "link")
                }
            }
            
            Divider()
            
            Button(action: {
                shareResource(resource)
            }) {
                Label("Share", systemImage: "square.and.arrow.up")
            }
        }
    }
    
    /// Adds contextual menu for events
    func eventContextMenu(
        event: Event,
        onAddToCalendar: @escaping () -> Void,
        onShare: @escaping () -> Void
    ) -> some View {
        self.contextMenu {
            Button(action: onAddToCalendar) {
                Label("Add to Calendar", systemImage: "calendar.badge.plus")
            }
            
            if let urlString = event.registrationURL, let url = URL(string: urlString) {
                Divider()
                
                Button(action: {
                    NSWorkspace.shared.open(url)
                }) {
                    Label("Open Registration", systemImage: "safari")
                }
                
                Button(action: {
                    let pasteboard = NSPasteboard.general
                    pasteboard.clearContents()
                    pasteboard.setString(urlString, forType: .string)
                }) {
                    Label("Copy Link", systemImage: "link")
                }
            }
            
            Divider()
            
            Button(action: {
                shareEvent(event)
            }) {
                Label("Share", systemImage: "square.and.arrow.up")
            }
        }
    }
    
    /// Adds contextual menu for community posts
    func postContextMenu(
        post: CommunityPost,
        onShare: @escaping () -> Void
    ) -> some View {
        self.contextMenu {
            Button(action: {
                let pasteboard = NSPasteboard.general
                pasteboard.clearContents()
                pasteboard.setString(post.content, forType: .string)
            }) {
                Label("Copy Text", systemImage: "doc.on.doc")
            }
            
            Divider()
            
            Button(action: {
                sharePost(post)
            }) {
                Label("Share", systemImage: "square.and.arrow.up")
            }
        }
    }
    
    // MARK: - Share Helpers
    
    private func shareResource(_ resource: Resource) {
        guard let window = NSApplication.shared.keyWindow,
              let contentView = window.contentView else { return }
        
        var shareItems: [Any] = []
        let shareText = """
        \(resource.title)
        
        \(resource.description)
        
        Category: \(resource.category.rawValue)
        """
        shareItems.append(shareText)
        
        if let urlString = resource.url, let url = URL(string: urlString) {
            shareItems.append(url)
        }
        
        let sharingServicePicker = NSSharingServicePicker(items: shareItems)
        sharingServicePicker.show(relativeTo: .zero, of: contentView, preferredEdge: .minY)
    }
    
    private func shareEvent(_ event: Event) {
        guard let window = NSApplication.shared.keyWindow,
              let contentView = window.contentView else { return }
        
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
        
        if let registrationURL = event.registrationURL, let url = URL(string: registrationURL) {
            shareItems.append(url)
        }
        
        if let eventURL = event.eventURL, let url = URL(string: eventURL) {
            shareItems.append(url)
        }
        
        let sharingServicePicker = NSSharingServicePicker(items: shareItems)
        sharingServicePicker.show(relativeTo: .zero, of: contentView, preferredEdge: .minY)
    }
    
    private func sharePost(_ post: CommunityPost) {
        guard let window = NSApplication.shared.keyWindow,
              let contentView = window.contentView else { return }
        
        let shareText = """
        \(post.title)
        
        \(post.content)
        
        Author: \(post.author)
        """
        
        let sharingServicePicker = NSSharingServicePicker(items: [shareText])
        sharingServicePicker.show(relativeTo: .zero, of: contentView, preferredEdge: .minY)
    }
}
#endif

