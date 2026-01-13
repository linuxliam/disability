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
            
            Button(action: onShare) {
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
            
            Button(action: onShare) {
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
            
            Button(action: onShare) {
                Label("Share", systemImage: "square.and.arrow.up")
            }
        }
    }
}
#endif

