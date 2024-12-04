import SwiftUI
import SwiftData

struct HomeView: View {
    @Query private var articles: [Article]
    @Query private var categories: [Category]
    @State private var selectedCategory: Category?
    @Environment(\.modelContext) private var context

    @AppStorage("tickerPosition") private var tickerPosition: String = "top"
    @AppStorage("isTickerEnabled") private var isTickerEnabled: Bool = true
    @AppStorage("tickerNewsCount") private var tickerNewsCount: Int = 5
    @AppStorage("tickerCountry") private var tickerCountry: String = "us"
    @AppStorage("tickerCategory") private var tickerCategory: String = "general"

    @State private var headlines: [String] = []
    @State private var enlargedHeadline: String? = nil
    
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false

    let apiService = APIService()

    var body: some View {
        ZStack {
            NavigationStack {
                VStack(spacing: 0) {
                    if isTickerEnabled && tickerPosition == "top" {
                        tickerView
                    }

                    if filteredArticles.isEmpty {
                        Spacer()
                        emptyStateView
                        Spacer()
                    } else {
                        articleListView
                    }

                    if isTickerEnabled && tickerPosition == "bottom" {
                        tickerView
                    }
                }
                .preferredColorScheme(isDarkMode ? .dark : .light)
                .toolbar(content: categoryPickerToolbar)
                .onAppear {
                    fetchTopHeadlines()
                }
            }

            
            if let enlargedHeadline = enlargedHeadline {
                Text(enlargedHeadline)
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.indigo)
                    .cornerRadius(15)
                    .shadow(radius: 8)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }

        }
    }

    private var tickerView: some View {
        Group {
            if headlines.isEmpty {
                Text("Loading headlines...")
                    .foregroundColor(.gray)
                    .frame(height: 50)
            } else {
                NewsTickerView(headlines: headlines, enlargedHeadline: $enlargedHeadline)
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color(.systemGray6))
    }

    private func fetchTopHeadlines() {
        Task {
            let headlinesCount = UserDefaults.standard.integer(forKey: "tickerNewsCount")
            

            print("Fetching \(headlinesCount) headlines")

            headlines = []
            
        
            let articles = await apiService.fetchTopHeadlines(country: tickerCountry, category: tickerCategory, pageSize: headlinesCount)
            headlines = articles.compactMap { $0.title }

            if headlines.isEmpty {
                print("No headlines found")
            } else {
                print("Headlines loaded: \(headlines)")
            }
        }
    }

    private var filteredArticles: [Article] {
        if let selectedCategory = selectedCategory {
            return articles.filter { $0.category == selectedCategory && !$0.isArchived }
        } else {
            return articles.filter { !$0.isArchived }
        }
    }

    private var emptyStateView: some View {
        VStack {
            Image(systemName: "book.closed")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.gray)
            Text("No articles found")
                .foregroundColor(.gray)
                .font(.headline)
        }
    }

    private var articleListView: some View {
        List {
            ForEach(filteredArticles) { article in
                NavigationLink(destination: ArticleDetailView(article: article)) {
                    HStack {
                        if let url = article.urlToImage, let imageURL = URL(string: url) {
                            AsyncImage(url: imageURL) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            } placeholder: {
                                ProgressView()
                            }
                        } else {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 50, height: 50)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }

                        VStack(alignment: .leading) {
                            Text(article.title)
                                .font(.headline)
                            Text(article.category.name)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .onDelete(perform: archiveArticle)
        }
    }

    private func archiveArticle(at offsets: IndexSet) {
        for index in offsets {
            let article = filteredArticles[index]
            article.isArchived = true
        }
        try? context.save()
    }

    private func categoryPickerToolbar() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Menu {
                Picker("Select Category", selection: $selectedCategory) {
                    Text("All Categories").tag(nil as Category?)
                    ForEach(categories, id: \.self) { category in
                        Text(category.name).tag(category as Category?)
                    }
                }
            } label: {
                Image(systemName: "ellipsis.circle")
                    .font(.title2)
                    .foregroundColor(.blue)
            }
        }
    }
}
