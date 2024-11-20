//
//  APIService.swift
//  NewsAppExam
//
//  Created by Isam Melioui on 20/11/2024.
//


import Foundation

struct APIService {
    
    private let apiKey = "9be243a1a16d4e199359a387e3e9cf24" 
    
    func fetchArticles(query: String) async -> [ArticleResponse] {
        
        // Opprett URL
        let urlString = "https://newsapi.org/v2/everything?q=\(query)&apiKey=\(apiKey)"
        guard let url = URL(string: urlString) else {
            print("Error: Invalid URL")
            return []
        }
        
        // Send forespørselen
        let request = URLRequest(url: url)
        let session = URLSession.shared
        
        do {
            let (data, _) = try await session.data(for: request)
            
            // Parse data
            let decoder = JSONDecoder()
            let newsResponse = try decoder.decode(NewsAPIResponse.self, from: data)
            
            return newsResponse.articles
        } catch {
            print("Error fetching articles: \(error)")
        }
        
        return []
    }
}

