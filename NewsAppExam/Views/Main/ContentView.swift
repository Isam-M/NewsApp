

import SwiftUI

struct ContentView: View {
    @State private var showSplash = true

    var body: some View {
        Group {
            if showSplash {
                SplashScreenView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation {
                                showSplash = false
                            }
                        }
                    }
            } else {
                MainContentView()
            }
        }
    }
}


struct MainContentView: View {
    var body: some View {
        TabView {
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
