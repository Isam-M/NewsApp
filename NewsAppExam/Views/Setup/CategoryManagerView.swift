





import SwiftUI
import SwiftData

struct CategoryManagerView: View {
    @Query private var categories: [Category]
    @Query private var articles: [Article]
    @Environment(\.modelContext) private var context
    @State private var newCategoryName: String = ""

    var body: some View {
        NavigationStack {
            VStack {
                
                List {
                    ForEach(categories) { category in
                        HStack {
                            Text(category.name)
                            Spacer()
                            if category.name != "Uncategorized" {
                                Button(role: .destructive) {
                                    deleteCategory(category)
                                } label: {
                                    Image(systemName: "trash")
                                }
                            }
                        }
                    }
                }


                
                HStack {
                    TextField("New category name", text: $newCategoryName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button("Add") {
                        addCategory()
                    }
                    .disabled(newCategoryName.isEmpty)
                }
                .padding()
            }
            .navigationTitle("Manage Categories")
        }
    }

    private func addCategory() {
        let newCategory = Category(name: newCategoryName)
        context.insert(newCategory)
        do {
            try context.save()
            newCategoryName = ""
            print("Category created at: \(newCategory.createdAt)")
        } catch {
            print("Failed to add category: \(error)")
        }
    }

    private func deleteCategory(_ category: Category) {
        let uncategorized = Category.uncategorizedCategory(context: context)
        
        
        guard category != uncategorized else {
            print("Cannot delete the Uncategorized category")
            return
        }

        
        for article in articles where article.category == category {
            article.category = uncategorized
        }

        
        context.delete(category)
        do {
            try context.save()
            print("Category deleted successfully")
        } catch {
            print("Failed to delete category: \(error)")
        }
    }


}
