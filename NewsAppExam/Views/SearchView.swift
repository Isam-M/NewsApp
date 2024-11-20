//
//  SearchView.swift
//  NewsAppExam
//
//  Created by Isam Melioui on 20/11/2024.
//

import SwiftUI

struct SearchView: View {
    @State private var query = ""
    @State private var articles: [ArticleResponse] = []
    @State private var isLoading = false
    
    let apiService = APIService()
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Search news...", text: $query, onCommit: fetchArticles)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                

                if isLoading {
                    ProgressView("Loading...")
                } else {
                    List(articles) { article in
                        HStack {
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
                            }
                            
                            
                            VStack(alignment: .leading) {
                                Text(article.title)
                                    .font(.headline)
                                Text(article.source.name)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Search News")
        }
    }
    
    func fetchArticles() {
        
        Task {
            isLoading = true
            articles = await apiService.fetchArticles(query: query)
            isLoading = false
        }
    }
}

#Preview {
    SearchView()
}
