

import Foundation
import SwiftData

@Model
class Article: Identifiable {
    var id: UUID
    var title: String
    var articleDescription: String?
    var source: String
    var url: String?
    var urlToImage: String?
    var publishedAt: String?
    var content: String?
    var category: Category
    var notes: String
    var createdAt: Date
    var updatedAt: Date
    var isArchived: Bool = false

    init(title: String, description: String?, source: String, url: String?, urlToImage: String?, publishedAt: String?, content: String?, category: Category, notes: String) {
        self.id = UUID()
        self.title = title
        self.articleDescription = description
        self.source = source
        self.url = url
        self.urlToImage = urlToImage
        self.publishedAt = publishedAt
        self.content = content
        self.category = category
        self.notes = notes
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}
