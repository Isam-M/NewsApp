
import SwiftUI
import SwiftData

@main
struct NewsAppExamApp: App {
    init() {
        
        Category.defaultCategories(context: sharedModelContainer.mainContext)
        let countriesRepository = CountriesRepository(context: sharedModelContainer.mainContext)
        countriesRepository.initializeCountries()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(sharedModelContainer)
        }
    }
}

var sharedModelContainer: ModelContainer = {
    let schema = Schema([Article.self, Category.self, Search.self, Country.self])
    let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let databaseURL = documentDirectory.appendingPathComponent("newsapi.store")
    let modelConfiguration = ModelConfiguration(schema: schema, url: databaseURL)

    do {
        return try ModelContainer(for: schema, configurations: modelConfiguration)
    } catch {
        fatalError("Could not create model container: \(error.localizedDescription)")
    }
}()

// Brukes kun når det trengs
func resetDatabase() {
    let storeURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("newsapi.store")
    if let url = storeURL {
        try? FileManager.default.removeItem(at: url)
        print("Database reset successfully.")
    }
}
