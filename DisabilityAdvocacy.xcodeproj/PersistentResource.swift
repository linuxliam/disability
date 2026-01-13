import Foundation
import SwiftData

@Model
final class PersistentResource {
    @Attribute(.unique) var id: UUID
    var title: String
    var details: String
    var createdAt: Date
    
    init(id: UUID = UUID(), title: String, details: String, createdAt: Date = Date()) {
        self.id = id
        self.title = title
        self.details = details
        self.createdAt = createdAt
    }
}
