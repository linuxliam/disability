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
    /// Filters resources by search text and category
    func filtered(searchText: String, category: ResourceCategory?) -> [Resource] {
        var filtered = self

        // Pre-compute lowercase search for efficiency
        let trimmedSearch = searchText.trimmingCharacters(in: .whitespaces)

        if !trimmedSearch.isEmpty {
            filtered = filtered.filter { $0.matches(searchText: trimmedSearch) }
        }

        if let category = category {
            filtered = filtered.filter { $0.category == category }
        }

        return filtered
    }
}

// MARK: - Resource Search Matching
extension Resource {
    /// Checks if resource matches search text
    func matches(searchText: String) -> Bool {
        title.localizedCaseInsensitiveContains(searchText) ||
        description.localizedCaseInsensitiveContains(searchText) ||
        tags.contains { $0.localizedCaseInsensitiveContains(searchText) }
    }
}


