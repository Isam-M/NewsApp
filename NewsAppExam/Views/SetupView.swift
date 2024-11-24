//
//  SetupView.swift
//  NewsAppExam
//
//  Created by Isam Melioui on 20/11/2024.
//

import SwiftUI



struct SetupView: View {
    @AppStorage("tickerPosition") private var tickerPosition: String = "top"
    @AppStorage("isTickerEnabled") private var isTickerEnabled: Bool = true

    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("News Ticker Settings")) {
                    Toggle("Enable Ticker", isOn: $isTickerEnabled)

                    Picker("Ticker Position", selection: $tickerPosition) {
                        Text("Top").tag("top")
                        Text("Bottom").tag("bottom")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }

                Section(header: Text("Manage Content")) {
                    NavigationLink("Manage Categories", destination: CategoryManagerView())
                    NavigationLink("View Archived Articles", destination: ArchivedArticlesView())
                }
            }
            .navigationTitle("Setup")
        }
    }
}

#Preview {
    SetupView()
}
