//
//  DragDropSupport.swift
//  Disability Advocacy
//
//  Unified drag and drop support for resources using NSItemProvider
//

import SwiftUI
import UniformTypeIdentifiers
#if os(macOS)
import AppKit
#else
import UIKit
#endif

struct DraggableResource: ViewModifier {
    let resource: Resource
    
    func body(content: Content) -> some View {
        content
            .onDrag {
                let provider = NSItemProvider()
                
                // Provide resource as JSON
                if let jsonData = try? JSONEncoder().encode(resource) {
                    provider.registerDataRepresentation(
                        forTypeIdentifier: UTType.json.identifier,
                        visibility: .all
                    ) { completion in
                        completion(jsonData, nil)
                        return nil
                    }
                }
                
                // Provide URL if available
                if let urlString = resource.url, let url = URL(string: urlString) {
                    #if os(macOS)
                    provider.registerObject(url as NSURL, visibility: .all)
                    #else
                    // iOS NSItemProvider.registerObject requires conforming to NSItemProviderWriting
                    // For URLs, we can use registerDataRepresentation
                    provider.registerDataRepresentation(
                        forTypeIdentifier: UTType.url.identifier,
                        visibility: .all
                    ) { completion in
                        completion(url.dataRepresentation, nil)
                        return nil
                    }
                    #endif
                }
                
                // Provide plain text
                let text = "\(resource.title)\n\(resource.description)"
                provider.registerDataRepresentation(
                    forTypeIdentifier: UTType.plainText.identifier,
                    visibility: .all
                ) { completion in
                    if let data = text.data(using: .utf8) {
                        completion(data, nil)
                    }
                    return nil
                }
                
                return provider
            }
    }
}

struct DroppableResourceArea: ViewModifier {
    @Binding var droppedResources: [Resource]
    let onDrop: ([Resource]) -> Void
    
    func body(content: Content) -> some View {
        content
            .onDrop(of: [.json, .url, .text], isTargeted: nil) { providers in
                let totalCount = providers.count
                let dropCollector = DropSession(totalCount: totalCount, onDrop: onDrop)
                
                for provider in providers {
                    // Try to load as Resource JSON
                    if provider.hasItemConformingToTypeIdentifier(UTType.json.identifier) {
                        provider.loadItem(forTypeIdentifier: UTType.json.identifier, options: nil) { data, error in
                            if let data = data as? Data,
                               let resource = try? JSONDecoder().decode(Resource.self, from: data) {
                                Task { @MainActor in
                                    dropCollector.addResource(resource)
                                }
                            }
                        }
                    }
                    // Try to load as URL
                    else if provider.hasItemConformingToTypeIdentifier(UTType.url.identifier) {
                        provider.loadItem(forTypeIdentifier: UTType.url.identifier, options: nil) { data, error in
                            // iOS returns Data or URL depending on how it was registered
                            let url: URL? = {
                                if let url = data as? URL { return url }
                                if let data = data as? Data { return URL(dataRepresentation: data, relativeTo: nil) }
                                return nil
                            }()
                            
                            if let url = url {
                                // Create resource from URL
                                let resource = Resource(
                                    title: url.host ?? "Imported Resource",
                                    description: "Resource imported from \(url.absoluteString)",
                                    category: .legal,
                                    url: url.absoluteString
                                )
                                Task { @MainActor in
                                    dropCollector.addResource(resource)
                                }
                            }
                        }
                    }
                }
                
                return true
            }
    }
}

@MainActor
private class DropSession {
    private var resources: [Resource] = []
    private let totalCount: Int
    private let onDrop: ([Resource]) -> Void
    
    init(totalCount: Int, onDrop: @escaping ([Resource]) -> Void) {
        self.totalCount = totalCount
        self.onDrop = onDrop
    }
    
    func addResource(_ resource: Resource) {
        resources.append(resource)
        // Note: Simple completion logic - in a real app you might want a timeout or error handling
        if resources.count == totalCount {
            onDrop(resources)
        }
    }
}

extension View {
    func draggableResource(_ resource: Resource) -> some View {
        modifier(DraggableResource(resource: resource))
    }
    
    func droppableResourceArea(droppedResources: Binding<[Resource]>, onDrop: @escaping ([Resource]) -> Void) -> some View {
        modifier(DroppableResourceArea(droppedResources: droppedResources, onDrop: onDrop))
    }
}
