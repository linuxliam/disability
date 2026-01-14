//
//  ShareButton.swift
//  Disability Advocacy
//
//  Cross-platform share button component
//  Uses native macOS share sheet on macOS, ShareLink on iOS
//

import SwiftUI

/// Cross-platform share button that uses native APIs
struct AppShareButton: View {
    let item: ShareableItem
    let label: String
    let systemImage: String
    let style: ShareButtonStyle
    
    enum ShareButtonStyle {
        case button
        case icon
        case link
    }
    
    enum ShareableItem {
        case url(URL)
        case text(String)
        case resource(Resource)
        case event(Event)
        case article(NewsArticle)
    }
    
    init(item: ShareableItem, label: String = "Share", systemImage: String = "square.and.arrow.up", style: ShareButtonStyle = .button) {
        self.item = item
        self.label = label
        self.systemImage = systemImage
        self.style = style
    }
    
    var body: some View {
        #if os(macOS)
        macOSShareButton(item: item, label: label, systemImage: systemImage, style: style)
        #else
        iOSShareButton(item: item, label: label, systemImage: systemImage, style: style)
        #endif
    }
}

#if os(macOS)
import AppKit

private struct macOSShareButton: View {
    let item: AppShareButton.ShareableItem
    let label: String
    let systemImage: String
    let style: AppShareButton.ShareButtonStyle
    
    var body: some View {
        ShareButtonWrapper(item: item, label: label, systemImage: systemImage, style: style)
    }
}

private struct ShareButtonWrapper: NSViewRepresentable {
    let item: AppShareButton.ShareableItem
    let label: String
    let systemImage: String
    let style: AppShareButton.ShareButtonStyle
    
    func makeNSView(context: Context) -> NSButton {
        let button = NSButton()
        button.target = context.coordinator
        button.action = #selector(Coordinator.share(_:))
        
        switch style {
        case .button:
            button.title = label
            button.image = NSImage(systemSymbolName: systemImage, accessibilityDescription: label)
            button.imagePosition = .imageLeading
            button.bezelStyle = .rounded
        case .icon:
            button.image = NSImage(systemSymbolName: systemImage, accessibilityDescription: label)
            button.bezelStyle = .texturedRounded
            button.isBordered = false
        case .link:
            button.title = label
            button.image = NSImage(systemSymbolName: systemImage, accessibilityDescription: label)
            button.imagePosition = .imageLeading
            button.bezelStyle = .texturedRounded
            button.isBordered = false
        }
        
        return button
    }
    
    func updateNSView(_ nsView: NSButton, context: Context) {
        switch style {
        case .button:
            nsView.title = label
            nsView.image = NSImage(systemSymbolName: systemImage, accessibilityDescription: label)
            nsView.imagePosition = .imageLeading
            nsView.bezelStyle = .rounded
        case .icon:
            nsView.image = NSImage(systemSymbolName: systemImage, accessibilityDescription: label)
            nsView.bezelStyle = .texturedRounded
            nsView.isBordered = false
        case .link:
            nsView.title = label
            nsView.image = NSImage(systemSymbolName: systemImage, accessibilityDescription: label)
            nsView.imagePosition = .imageLeading
            nsView.bezelStyle = .texturedRounded
            nsView.isBordered = false
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(item: item)
    }
    
    class Coordinator: NSObject {
        let item: AppShareButton.ShareableItem
        
        init(item: AppShareButton.ShareableItem) {
            self.item = item
        }
        
        @objc func share(_ sender: NSView) {
            let items: [Any]
            switch item {
            case .url(let url):
                items = [url]
            case .text(let text):
                items = [text]
            case .resource(let resource):
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
                items = shareItems
            case .event(let event):
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
                
                items = shareItems
            case .article(let article):
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .medium
                
                let shareText = """
                \(article.title)
                
                \(article.summary)
                
                Source: \(article.source)
                Date: \(dateFormatter.string(from: article.date))
                Category: \(article.category)
                """
                items = [shareText]
            }
            
            let sharingServicePicker = NSSharingServicePicker(items: items)
            sharingServicePicker.show(relativeTo: .zero, of: sender, preferredEdge: .minY)
        }
    }
}
#endif

#if os(iOS)
private struct iOSShareButton: View {
    let item: AppShareButton.ShareableItem
    let label: String
    let systemImage: String
    let style: AppShareButton.ShareButtonStyle
    
    var body: some View {
        switch item {
        case .url(let url):
            ShareLink(item: url) {
                shareButtonContent
            }
        case .text(let text):
            ShareLink(item: text) {
                shareButtonContent
            }
        case .resource(let resource):
            let shareText = """
            \(resource.title)
            
            \(resource.description)
            
            Category: \(resource.category.rawValue)
            """
            ShareLink(item: shareText, subject: Text(resource.title)) {
                shareButtonContent
            }
        case .event(let event):
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
            
            ShareLink(item: shareText, subject: Text(event.title)) {
                shareButtonContent
            }
        case .article(let article):
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            
            let shareText = """
            \(article.title)
            
            \(article.summary)
            
            Source: \(article.source)
            Date: \(dateFormatter.string(from: article.date))
            Category: \(article.category)
            """
            ShareLink(item: shareText, subject: Text(article.title)) {
                shareButtonContent
            }
        }
    }
    
    @ViewBuilder
    private var shareButtonContent: some View {
        switch style {
        case .button:
            Label(label, systemImage: systemImage)
        case .icon:
            Image(systemName: systemImage)
        case .link:
            Label(label, systemImage: systemImage)
        }
    }
}
#endif
