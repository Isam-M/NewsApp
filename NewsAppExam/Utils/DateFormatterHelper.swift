//
//  DateFormatterHelper.swift
//  NewsAppExam
//
//  Created by Isam Melioui on 21/11/2024.
//


import Foundation

struct DateFormatterHelper {
    static func formatDate(_ isoDate: String) -> String {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: isoDate) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateStyle = .medium
            return displayFormatter.string(from: date)
        }
        return isoDate
    }
}
