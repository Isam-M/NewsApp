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
    var topHeadlines: [Article] = []

    init(name: String, code: String) {
        self.id = UUID()
        self.name = name
        self.code = code
    }
}
