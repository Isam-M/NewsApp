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
    let id = UUID() // For bruk i SwiftUI
    let title: String
    let description: String?
    let urlToImage: String?
    let source: Source
}

struct Source: Decodable {
    let name: String
}

