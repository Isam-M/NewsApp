//
//  Country.swift
//  NewsAppExam
//
//  Created by Isam Melioui on 20/11/2024.
//


import Foundation
import SwiftData

@Model
class Country: Identifiable {
    @Attribute(.unique) var id: UUID
    var name: String
    var code: String
    var articles: [Article] = [] 
    var createdAt: Date
    var updatedAt: Date
    var notes: String

    init(name: String, code: String, notes: String = "") {
        self.id = UUID()
        self.name = name
        self.code = code
        self.createdAt = Date()
        self.updatedAt = Date()
        self.notes = notes
    }

    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case code
        case articles
        case createdAt
        case updatedAt
        case notes
    }
}

