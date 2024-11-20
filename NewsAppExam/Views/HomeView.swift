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

    var body: some View {
        NavigationStack {
            if articles.isEmpty {
                VStack {
                    Image(systemName: "book.closed")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.gray)
                    Text("No saved articles")
                        .foregroundColor(.gray)
                        .font(.headline)
                }
            } else {
                List(articles) { article in
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
                .navigationTitle("My Articles")
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
}

#Preview {
    HomeView()
}
