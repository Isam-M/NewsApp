//
//  ContentView.swift
//  NewsAppExam
//
//  Created by Isam Melioui on 20/11/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
 

    var body: some View {
        TabView{
            HomeView()
                .tabItem {
                    Label("My Articles", systemImage: "book")
                }
            SearchView()
                .tabItem {
                    Label("Search News", systemImage: "magnifyingglass")
                }
            SetupView()
                .tabItem {
                    Label("Setup", systemImage: "gear")
                }
            
        }
    }
}

#Preview {
    ContentView()
        
}
