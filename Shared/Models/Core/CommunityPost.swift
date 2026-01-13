import Foundation

enum PostCategory: String, CaseIterable, Codable {
    case discussion = "Discussion"
    case support = "Support"
    case advocacy = "Advocacy"
    
    var icon: String {
        switch self {
        case .discussion: return "text.bubble.fill"
        case .support: return "hands.sparkles.fill"
        case .advocacy: return "megaphone.fill"
        }
    }
}

struct Reply: Identifiable, Codable, Hashable {
    let id: UUID
    var author: String
    var content: String
    
    init(id: UUID = UUID(), author: String, content: String) {
        self.id = id
        self.author = author
        self.content = content
    }
}

struct CommunityPost: Identifiable, Codable, Hashable {
    let id: UUID
    var author: String
    var title: String
    var content: String
    var category: PostCategory
    var datePosted: Date
    var replies: [Reply]
    var likes: Int
    
    init(id: UUID = UUID(), author: String, title: String, content: String, category: PostCategory, datePosted: Date = Date(), replies: [Reply] = [], likes: Int = 0) {
        self.id = id
        self.author = author
        self.title = title
        self.content = content
        self.category = category
        self.datePosted = datePosted
        self.replies = replies
        self.likes = likes
    }
}

