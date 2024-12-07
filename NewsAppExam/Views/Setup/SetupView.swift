




import SwiftUI

struct SetupView: View {
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false

    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("News Ticker Settings")) {
                    NavigationLink("Edit News Ticker Settings", destination: NewsTickerSettingsView())
                }
                Section(header: Text("Manage Content")) {
                    NavigationLink("Manage Categories", destination: CategoryManagerView())
                    NavigationLink("View Archived Articles", destination: ArchivedArticlesView())
                }
                Section(header: Text("API Key")) {
                    NavigationLink("Set API Key", destination: APIKeySettingsView())
                }
                Section(header: Text("Appearance")) {
                    Toggle("Dark Mode", isOn: $isDarkMode)
                }
            }
            .navigationTitle("Setup")
            .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}

#Preview {
    SetupView()
}

