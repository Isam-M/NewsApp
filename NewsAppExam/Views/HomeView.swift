//
//  HomeView.swift
//  NewsAppExam
//
//  Created by Isam Melioui on 20/11/2024.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Query private var articles: [Article]
    @Query private var categories: [Category]
    @State private var selectedCategory: Category?
    @Environment(\.modelContext) private var context
    
    var body: some View {
        NavigationStack {
            VStack {
                if filteredArticles.isEmpty {
                    emptyStateView
                } else {
                    articleListView
                }
            }
            .navigationTitle("My Articles")
            .toolbar {
                categoryPickerToolbar
            }
        }
    }
    
    
    private var filteredArticles: [Article] {
        if let selectedCategory = selectedCategory {
            return articles.filter { $0.category == selectedCategory && !$0.isArchived }
        } else {
            return articles.filter { !$0.isArchived }
        }
    }
    
    
    private var emptyStateView: some View {
        VStack {
            Image(systemName: "book.closed")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.gray)
            Text("No articles found")
                .foregroundColor(.gray)
                .font(.headline)
        }
    }
    
    
    private var articleListView: some View {
        List {
            ForEach(filteredArticles) { article in
                NavigationLink(destination: ArticleDetailView(article: article)) {
                    VStack(alignment: .leading) {
                        Text(article.title)
                            .font(.headline)
                        Text(article.category.name)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .onDelete(perform: archiveArticle)
        }
    }
    
    
    private var categoryPickerToolbar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Menu {
                Picker("Select Category", selection: $selectedCategory) {
                    Text("All Categories").tag(nil as Category?)
                    ForEach(categories, id: \.self) { category in
                        Text(category.name).tag(category as Category?)
                    }
                }
            } label: {
                Image(systemName: "ellipsis.circle")
                    .font(.title2)
                    .foregroundColor(.blue)
            }
        }
    }


    
    private func archiveArticle(at offsets: IndexSet) {
        for index in offsets {
            let article = filteredArticles[index]
            article.isArchived = true
        }
        try? context.save()
    }
}
    

#Preview {
    HomeView()
}
