//
//  ImageExtensions.swift
//  Disability Advocacy iOS
//
//  System image name constants and computed properties
//

import SwiftUI

extension Image {
    // MARK: - Common Icons
    static let home = Image(systemName: "house.fill")
    static let resources = Image(systemName: "book.fill")
    static let events = Image(systemName: "calendar")
    static let community = Image(systemName: "person.3.fill")
    static let more = Image(systemName: "ellipsis.circle.fill")
    static let profile = Image(systemName: "person.circle.fill")
    static let favorite = Image(systemName: "heart")
    static let favoriteFilled = Image(systemName: "heart.fill")
    static let share = Image(systemName: "square.and.arrow.up")
    static let copy = Image(systemName: "doc.on.doc")
    static let search = Image(systemName: "magnifyingglass")
    static let filter = Image(systemName: "line.3.horizontal.decrease.circle")
    static let close = Image(systemName: "xmark.circle.fill")
    static let chevronRight = Image(systemName: "chevron.right")
    static let calendar = Image(systemName: "calendar.badge.plus")
    static let link = Image(systemName: "link")
    static let safari = Image(systemName: "safari.fill")
    static let accessibility = Image(systemName: "accessibility")
    static let news = Image(systemName: "newspaper.fill")
    static let tools = Image(systemName: "wrench.and.screwdriver.fill")
}

// MARK: - Category Icons
extension Resource.Category {
    var icon: Image {
        switch self {
        case .legal: return Image(systemName: "scale.3d")
        case .education: return Image(systemName: "book.closed.fill")
        case .healthcare: return Image(systemName: "cross.case.fill")
        case .employment: return Image(systemName: "briefcase.fill")
        case .housing: return Image(systemName: "house.fill")
        case .transportation: return Image(systemName: "car.fill")
        case .technology: return Image(systemName: "laptopcomputer")
        case .advocacy: return Image(systemName: "megaphone.fill")
        case .community: return Image(systemName: "person.3.fill")
        case .financial: return Image(systemName: "dollarsign.circle.fill")
        }
    }
}

extension Event.Category {
    var icon: Image {
        switch self {
        case .workshop: return Image(systemName: "person.2.fill")
        case .conference: return Image(systemName: "building.2.fill")
        case .networking: return Image(systemName: "network")
        case .support: return Image(systemName: "hands.sparkles.fill")
        case .advocacy: return Image(systemName: "megaphone.fill")
        case .social: return Image(systemName: "party.popper.fill")
        }
    }
}

extension CommunityPost.Category {
    var icon: Image {
        switch self {
        case .discussion: return Image(systemName: "bubble.left.and.bubble.right.fill")
        case .question: return Image(systemName: "questionmark.circle.fill")
        case .announcement: return Image(systemName: "megaphone.fill")
        case .support: return Image(systemName: "heart.fill")
        case .resource: return Image(systemName: "book.fill")
        }
    }
}

