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

    @AppStorage("tickerPosition") private var tickerPosition: String = "top" // Lagret posisjon
      @AppStorage("isTickerEnabled") private var isTickerEnabled: Bool = true // Aktivert/deaktivert ticker
      @State private var headlines: [String] = [] // Nyhetsoverskrifter

      let apiService = APIService()

      var body: some View {
          NavigationStack {
              VStack {
                  // Top ticker
                  if isTickerEnabled && tickerPosition == "top" {
                      if headlines.isEmpty {
                          Text("Loading headlines...")
                              .foregroundColor(.gray)
                              .frame(height: 50)
                      } else {
                          NewsTickerView(headlines: headlines, duration: 20)
                      }
                  }

                  if filteredArticles.isEmpty {
                      emptyStateView
                  } else {
                      articleListView
                  }

                  // Bottom ticker
                  if isTickerEnabled && tickerPosition == "bottom" {
                      if headlines.isEmpty {
                          Text("Loading headlines...")
                              .foregroundColor(.gray)
                              .frame(height: 50)
                      } else {
                          NewsTickerView(headlines: headlines, duration: 20)
                      }
                  }
              }
            
              .toolbar {
                  categoryPickerToolbar
              }
              .onAppear {
                  fetchTopHeadlines()
              }
          }
      }

      private func fetchTopHeadlines() {
          Task {
              let articles = await apiService.fetchTopHeadlines(country: "us", category: "general", pageSize: 10)
              headlines = articles.compactMap { $0.title }

              if headlines.isEmpty {
                  print("No headlines found")
              } else {
                  print("Headlines loaded: \(headlines)")
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
                    HStack{
                        
                        if let url = article.urlToImage, let imageURL = URL(string: url) {
                            AsyncImage(url: imageURL) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            } placeholder: {
                                ProgressView()
                            }
                        } else {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 50, height: 50)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }

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
