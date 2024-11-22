//
//  ArticleResponse.swift
//  NewsAppExam
//
//  Created by Isam Melioui on 20/11/2024.
//

import Foundation

struct NewsAPIResponse: Decodable {
    let articles: [ArticleResponse]
}

struct ArticleResponse: Identifiable, Decodable {
    let id = UUID()
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    let source: Source
    let publishedAt: String?
    let content: String?
}


struct Source: Decodable {
    let name: String
}

