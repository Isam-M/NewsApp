import Foundation
import SwiftData

@Model
class Category: Identifiable {
    @Attribute(.unique) var id: UUID
    var name: String
    var articles: [Article] = [] 

    init(name: String) {
        self.id = UUID()
        self.name = name
    }

    static func defaultCategories(context: ModelContext) {
        // Hent alle eksisterende kategorier fra databasen
        let existingCategories = try? context.fetch(FetchDescriptor<Category>())

        // Hvis det ikke finnes noen kategorier, legg til standardkategorier
        if existingCategories?.isEmpty ?? true {
            let initialCategories = ["General", "Technology", "Health", "Sports", "Business"]
            for name in initialCategories {
                let category = Category(name: name)
                context.insert(category)
            }
            do {
                try context.save()
                print("Default categories added")
            } catch {
                print("Failed to save default categories: \(error)")
            }
        }
    }

}
