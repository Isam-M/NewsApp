//
//  APIService.swift
//  NewsAppExam
//
//  Created by Isam Melioui on 20/11/2024.
//


import Foundation

struct APIService {
    private let apiKey = "9be243a1a16d4e199359a387e3e9cf24"

    func fetchArticles(query: String, sortBy: String, language: String, fromDate: Date, toDate: Date) async -> [ArticleResponse] {
        let formatter = ISO8601DateFormatter()
        let fromDateString = formatter.string(from: fromDate)
        let toDateString = formatter.string(from: toDate)

        var urlString = "https://newsapi.org/v2/everything?q=\(query)&sortBy=\(sortBy)&apiKey=\(apiKey)"
        
        if !language.isEmpty {
            urlString += "&language=\(language)"
        }
        
        urlString += "&from=\(fromDateString)&to=\(toDateString)"

        guard let url = URL(string: urlString) else {
            print("Error: Invalid URL")
            return []
        }

        let request = URLRequest(url: url)
        let session = URLSession.shared

        do {
            let (data, _) = try await session.data(for: request)
            let decoder = JSONDecoder()
            let newsResponse = try decoder.decode(NewsAPIResponse.self, from: data)
            
            return newsResponse.articles
            
        } catch {
            print("Error fetching articles: \(error)")
        }

        return []
    }
    
    func fetchTopHeadlines(country: String, category: String, pageSize: Int = 20) async -> [ArticleResponse] {
        var urlString = "https://newsapi.org/v2/top-headlines?apiKey=\(apiKey)"
        
        if !country.isEmpty {
            urlString += "&country=\(country)"
        }
        
        if !category.isEmpty {
            urlString += "&category=\(category)"
        }
        
        urlString += "&pageSize=\(pageSize)"

        guard let url = URL(string: urlString) else {
            print("Error: Invalid URL")
            return []
        }

        let request = URLRequest(url: url)
        let session = URLSession.shared

        do {
            let (data, _) = try await session.data(for: request)
            let decoder = JSONDecoder()
            let newsResponse = try decoder.decode(NewsAPIResponse.self, from: data)
            return newsResponse.articles
        } catch {
            print("Error fetching top headlines: \(error)")
        }

        return []
    }


}


