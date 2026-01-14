//
//  ShareButton.swift
//  Disability Advocacy macOS
//
//  Native macOS share button using NSSharingServicePicker
//

#if os(macOS)
import SwiftUI
import AppKit

/// A button that shows the native macOS share sheet
struct NativeShareButton: NSViewRepresentable {
    let items: [Any]
    let label: String
    let systemImage: String
    
    init(items: [Any], label: String = "Share", systemImage: String = "square.and.arrow.up") {
        self.items = items
        self.label = label
        self.systemImage = systemImage
    }
    
    func makeNSView(context: Context) -> NSButton {
        let button = NSButton()
        button.title = label
        button.image = NSImage(systemSymbolName: systemImage, accessibilityDescription: label)
        button.imagePosition = .imageLeading
        button.bezelStyle = .rounded
        button.target = context.coordinator
        button.action = #selector(Coordinator.share(_:))
        return button
    }
    
    func updateNSView(_ nsView: NSButton, context: Context) {
        nsView.title = label
        nsView.image = NSImage(systemSymbolName: systemImage, accessibilityDescription: label)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(items: items)
    }
    
    class Coordinator: NSObject {
        let items: [Any]
        
        init(items: [Any]) {
            self.items = items
        }
        
        @objc func share(_ sender: NSButton) {
            let sharingServicePicker = NSSharingServicePicker(items: items)
            sharingServicePicker.show(relativeTo: .zero, of: sender, preferredEdge: .minY)
        }
    }
}

/// SwiftUI wrapper for native macOS share functionality
struct ShareButton: View {
    let items: [Any]
    let label: String
    let systemImage: String
    let style: ShareButtonStyle
    
    enum ShareButtonStyle {
        case button
        case icon
        case custom(AnyView)
    }
    
    init(items: [Any], label: String = "Share", systemImage: String = "square.and.arrow.up", style: ShareButtonStyle = .button) {
        self.items = items
        self.label = label
        self.systemImage = systemImage
        self.style = style
    }
    
    var body: some View {
        ShareButtonWrapper(items: items, label: label, systemImage: systemImage, style: style)
    }
}

private struct ShareButtonWrapper: NSViewRepresentable {
    let items: [Any]
    let label: String
    let systemImage: String
    let style: ShareButton.ShareButtonStyle
    
    func makeNSView(context: Context) -> NSView {
        let containerView = NSView()
        containerView.wantsLayer = true
        
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
        case .custom:
            button.title = label
            button.image = NSImage(systemSymbolName: systemImage, accessibilityDescription: label)
            button.imagePosition = .imageLeading
            button.bezelStyle = .rounded
        }
        
        containerView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            button.topAnchor.constraint(equalTo: containerView.topAnchor),
            button.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        return containerView
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {
        // Update if needed
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(items: items)
    }
    
    class Coordinator: NSObject {
        let items: [Any]
        
        init(items: [Any]) {
            self.items = items
        }
        
        @objc func share(_ sender: NSView) {
            let sharingServicePicker = NSSharingServicePicker(items: items)
            sharingServicePicker.show(relativeTo: .zero, of: sender, preferredEdge: .minY)
        }
    }
}
#endif
