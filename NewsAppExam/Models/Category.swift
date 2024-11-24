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
        
        let existingCategories = try? context.fetch(FetchDescriptor<Category>())

        
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

extension Category {
    static func uncategorizedCategory(context: ModelContext) -> Category {
        let fetchRequest = FetchDescriptor<Category>(predicate: #Predicate { $0.name == "Uncategorized" })
        if let existing = try? context.fetch(fetchRequest).first {
            return existing
        } else {
            let uncategorized = Category(name: "Uncategorized")
            context.insert(uncategorized)
            try? context.save()
            return uncategorized
        }
    }
}
