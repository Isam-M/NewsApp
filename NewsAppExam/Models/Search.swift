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

    init(keyword: String) {
        self.id = UUID()
        self.keyword = keyword
        self.createdAt = Date()
    }
}
