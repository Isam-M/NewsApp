//
//  Search.swift
//  NewsAppExam
//
//  Created by Isam Melioui on 20/11/2024.
//


import Foundation
import SwiftData

@Model
class Search: Identifiable {
    @Attribute(.unique) var id: UUID
    var keyword: String
    var createdAt: Date
    var updatedAt: Date
    var notes: String

    init(keyword: String, notes: String = "") {
        self.id = UUID()
        self.keyword = keyword
        self.createdAt = Date()
        self.updatedAt = Date()
        self.notes = notes
    }

    
    enum CodingKeys: String, CodingKey {
        case id
        case keyword
        case createdAt
        case updatedAt
        case notes
    }
}
