//
//  CategoryManagerView.swift
//  NewsAppExam
//
//  Created by Isam Melioui on 20/11/2024.
//


import SwiftUI
import SwiftData

struct CategoryManagerView: View {
    @Query private var categories: [Category]
    @Environment(\.modelContext) private var context
    @State private var newCategoryName: String = ""

    var body: some View {
        NavigationStack {
            VStack {
                // Liste over eksisterende kategorier
                List {
                    ForEach(categories) { category in
                        HStack {
                            Text(category.name)
                            Spacer()
                            Button(role: .destructive) {
                                deleteCategory(category)
                            } label: {
                                Image(systemName: "trash")
                            }
                        }
                    }
                }

                // Legg til ny kategori
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
        } catch {
            print("Failed to add category: \(error)")
        }
    }

    private func deleteCategory(_ category: Category) {
        context.delete(category)
        do {
            try context.save()
        } catch {
            print("Failed to delete category: \(error)")
        }
    }
}
