






import Foundation
import SwiftData

@Model
class Search: Identifiable {
    var id: UUID
    var keyword: String
    var createdAt: Date
    var updatedAt: Date
    var notes: String

    init(keyword: String, notes: String = "") {
        self.id = UUID()
        self.keyword = keyword
        self.createdAt = Date()
        self.updatedAt = Date()
        self.notes = notes
    }

    
   
}
