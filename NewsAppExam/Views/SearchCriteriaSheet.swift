//
//  SearchCriteriaSheet.swift
//  NewsAppExam
//
//  Created by Isam Melioui on 23/11/2024.
//

import SwiftUI

struct SearchCriteriaSheet: View {
    @Binding var query: String
    @Binding var sortBy: String
    let onApply: () -> Void

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Query")) {
                    TextField("Enter search term", text: $query)
                }
                
                Section(header: Text("Sort By")) {
                    Picker("Sort By", selection: $sortBy) {
                        Text("Relevance").tag("relevancy")
                        Text("Popularity").tag("popularity")
                        Text("Published Date").tag("publishedAt")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
            .navigationTitle("Search Options")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Apply") {
                        onApply()
                    }
                }
            }
        }
    }
}
