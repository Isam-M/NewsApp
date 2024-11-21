//
//  NewsAppExamApp.swift
//  NewsAppExam
//
//  Created by Isam Melioui on 20/11/2024.
//

import SwiftUI
import SwiftData

@main
struct NewsAppExamApp: App {
    init() {
           
        Category.defaultCategories(context: sharedModelContainer.mainContext)
       }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
            
                .modelContainer(sharedModelContainer)
        }
    }
}


var sharedModelContainer: ModelContainer = {
    // Definer skjemaet med modellene som skal inkluderes
    let schema = Schema([Article.self, Category.self, Search.self, Country.self])
    
    // Konfigurer hvor databasen skal lagres
    let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let databaseURL = documentDirectory.appendingPathComponent("newsapi.store")
    let modelConfiguration = ModelConfiguration(schema: schema, url: databaseURL)
    
    do {
        return try ModelContainer(for: schema, configurations: modelConfiguration)
    } catch {
        fatalError("Could not create model container: \(error.localizedDescription)")
    }
}()
