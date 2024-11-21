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
    

    var body: some View {
        NavigationStack {
            VStack {
                // Artikelliste
                if filteredArticles.isEmpty {
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
                } else {
                    List(filteredArticles) { article in
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
                }
            }
            .navigationTitle("My Articles")
            .toolbar {
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
        }
    }

    
    private var filteredArticles: [Article] {
        if let selectedCategory = selectedCategory {
            return articles.filter { $0.category == selectedCategory }
        } else {
            return articles
        }
    }
}


    // Konverterer Article til ArticleResponse for detaljvisning
    private func convertToArticleResponse(_ article: Article) -> ArticleResponse {
        return ArticleResponse(
    
            title: article.title,
            description: article.articleDescription,
            url: nil,
            urlToImage: nil,
            source: Source(name: article.source),
            publishedAt: nil,
            content: article.notes
        )
    }



#Preview {
    HomeView()
}
