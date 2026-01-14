//
//  Resource.swift
//  Disability Advocacy
//
//  Resource data model
//

import Foundation

struct Resource: Identifiable, Codable, Hashable {
    let id: UUID
    var title: String
    var description: String
    var category: ResourceCategory
    var url: String?
    var tags: [String]
    var dateAdded: Date
    
    init(id: UUID = UUID(), title: String, description: String, category: ResourceCategory, url: String? = nil, tags: [String] = [], dateAdded: Date = Date()) {
        self.id = id
        self.title = title
        self.description = description
        self.category = category
        self.url = url
        self.tags = tags
        self.dateAdded = dateAdded
    }
}

enum ResourceCategory: String, Codable, CaseIterable {
    case legal = "Legal Rights"
    case education = "Education"
    case employment = "Employment"
    case healthcare = "Healthcare"
    case technology = "Assistive Technology"
    case community = "Community Support"
    case government = "Government Services"
    case advocacy = "Advocacy Organizations"
    
    var icon: String {
        switch self {
        case .legal: return "scale.3d"
        case .education: return "graduationcap.fill"
        case .employment: return "briefcase.fill"
        case .healthcare: return "cross.case.fill"
        case .technology: return "laptopcomputer"
        case .community: return "person.2.fill"
        case .government: return "building.2.fill"
        case .advocacy: return "megaphone.fill"
        }
    }
}

// MARK: - Resource Filtering Extension
extension Array where Element == Resource {
    /// Filters resources by search text, category, and tag in a single pass
    /// - Parameters:
    ///   - searchText: Search query (will be trimmed and lowercased)
    ///   - category: Optional category filter
    ///   - tag: Optional tag filter
    /// - Returns: Filtered array of resources
    func filtered(searchText: String, category: ResourceCategory?, tag: String?) -> [Resource] {
        // Pre-compute search text once
        let trimmedSearch = searchText.trimmingCharacters(in: .whitespaces)
        let lowerSearch = trimmedSearch.isEmpty ? nil : trimmedSearch.lowercased()

        // Single-pass filtering: combine all filters in one operation
        return self.filter { resource in
            // Search text filter
            if let search = lowerSearch {
                if !resource.matches(searchText: search) {
                    return false
                }
            }
            
            // Category filter
            if let category = category, resource.category != category {
                return false
            }
            
            // Tag filter
            if let tag = tag, !resource.tags.contains(tag) {
                return false
            }
            
            return true
        }
    }
}

// MARK: - Resource Search Matching
extension Resource {
    /// Checks if resource matches search text (assumes searchText is already lowercased)
    func matches(searchText: String) -> Bool {
        // Use lowercased() once per property instead of localizedCaseInsensitiveContains
        // This is faster when searchText is already lowercased
        let lowerTitle = title.lowercased()
        let lowerDescription = description.lowercased()
        
        return lowerTitle.contains(searchText) ||
               lowerDescription.contains(searchText) ||
               tags.contains { $0.lowercased().contains(searchText) }
    }
}


