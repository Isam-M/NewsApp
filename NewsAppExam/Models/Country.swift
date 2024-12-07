







import Foundation
import SwiftData

@Model
class Country: Identifiable {
    var id: UUID
    var name: String
    var code: String
    var articles: [Article] = [] 
    var createdAt: Date
    var updatedAt: Date
    var notes: String

    init(name: String, code: String, notes: String = "") {
        self.id = UUID()
        self.name = name
        self.code = code
        self.createdAt = Date()
        self.updatedAt = Date()
        self.notes = notes
    }

    

}

