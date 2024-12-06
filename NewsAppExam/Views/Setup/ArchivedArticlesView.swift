//
//  ArchivedArticlesView.swift
//  NewsAppExam
//
//  Created by Isam Melioui on 21/11/2024.
//


import SwiftUI
import SwiftData

struct ArchivedArticlesView: View {
    @Query private var articles: [Article]
    @Environment(\.modelContext) private var context

    var body: some View {
        NavigationStack {
            VStack {
                if archivedArticles.isEmpty {
                    emptyStateView
                } else {
                    archivedArticlesList
                }
            }
            .navigationTitle("Archived Articles")
        }
    }

    
    private var archivedArticles: [Article] {
        return articles.filter { $0.isArchived }
    }

    
    private var emptyStateView: some View {
        VStack {
            Image(systemName: "archivebox")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.gray)
            Text("No archived articles")
                .foregroundColor(.gray)
                .font(.headline)
        }
    }

    
    private var archivedArticlesList: some View {
        List {
            ForEach(archivedArticles) { article in
                VStack(alignment: .leading) {
                    Text(article.title)
                        .font(.headline)
                    Text(article.category.name)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .swipeActions {
                    Button(role: .destructive) {
                        deleteArticle(article)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }

                    Button {
                        restoreArticle(article)
                    } label: {
                        Label("Restore", systemImage: "arrow.uturn.left")
                    }
                    .tint(.blue)
                }
            }
        }
    }

    
    private func deleteArticle(_ article: Article) {
        context.delete(article)

        do {
            try context.save()
            print("Article deleted permanently!")
        } catch {
            print("Failed to delete article: \(error)")
        }
    }

    
    private func restoreArticle(_ article: Article) {
        article.isArchived = false

        do {
            try context.save()
            print("Article restored!")
        } catch {
            print("Failed to restore article: \(error)")
        }
    }
}

#Preview {
    ArchivedArticlesView()
}
