import Foundation
import SwiftData

@Model
final class PersistentEvent {
    @Attribute(.unique) var id: UUID
    var title: String
    var date: Date
    
    init(id: UUID = UUID(), title: String, date: Date = Date()) {
        self.id = id
        self.title = title
        self.date = date
    }
}
