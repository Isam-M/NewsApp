import SwiftUI
import SwiftData

struct SearchView: View {
    @State private var query = ""
    @State private var articles: [ArticleResponse] = []
    @State private var isLoading = false
    @FocusState private var isSearchFieldFocused: Bool

    @Query(sort: \Search.createdAt, order: .reverse) private var previousSearches: [Search]
    @Environment(\.modelContext) private var context

    @State private var showSearchCriteriaSheet = false
    
    @State private var sortBy: String = "relevancy"
    @State private var language: String = ""
    
    //Satt den en måned tilbake pga gratis versjon
    @State private var fromDate: Date = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
    @State private var toDate: Date = Date()


    let apiService = APIService()

    var body: some View {
        NavigationStack {
            VStack {
                searchField
                if isSearchFieldFocused {
                    recentSearches
                }
                if isLoading {
                    ProgressView("Loading...")
                } else {
                    articleList
                }
            }
            .navigationTitle("Search News")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showSearchCriteriaSheet = true
                    }) {
                        Image(systemName: "slider.horizontal.3")
                            .imageScale(.large)
                    }
                    
                }
            }

            .sheet(isPresented: $showSearchCriteriaSheet) {
                SearchCriteriaSheet(
                    sortBy: $sortBy,
                    language: $language,
                    fromDate: $fromDate,
                    toDate: $toDate,
                    onApply: performSearch,
                    onReset: resetSearchCriteria
                )
            }
        }
    }
}

private extension SearchView {
    // MARK: - Subviews

    var searchField: some View {
        TextField("Search news...", text: $query, onCommit: performSearch)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            .focused($isSearchFieldFocused)
            .overlay(
                HStack {
                 
                    Spacer()
                    if !query.isEmpty {
                        Button(action: { query = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                        .padding(.trailing, 8)
                    }
                }
            )
    }

    var recentSearches: some View {
        Group {
            if previousSearches.isEmpty {
                Text("No recent searches")
                    .foregroundColor(.gray)
                    .font(.subheadline)
                    .padding(.horizontal)
            } else {
                VStack(alignment: .leading) {
                    Text("Nylige søk")
                        .font(.headline)
                        .padding(.horizontal)

                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(previousSearches) { search in
                                HStack {
                                    Text(search.keyword)
                                        .foregroundColor(.primary)
                                        .padding(.vertical, 8)

                                    Spacer()

                                    Button(action: {
                                        deleteSearch(search)
                                    }) {
                                        Image(systemName: "xmark")
                                            .foregroundColor(.red)
                                    }
                                }
                                .padding(.horizontal)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                                .padding(.vertical, 4)
                                .onTapGesture {
                                    query = search.keyword
                                    isSearchFieldFocused = false
                                    performSearch()
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(maxHeight: 200)
            }
        }
    }


    var articleList: some View {
        List(articles) { article in
            NavigationLink(destination: ArticleDetailView(apiArticle: article)) {
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
                        Text(article.title ?? "No title")
                            .font(.headline)
                        Text(article.source.name)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }

    // MARK: - Actions

    func performSearch() {
        Task {
            isLoading = true
            articles = await apiService.fetchArticles(query: query, sortBy: sortBy, language: language, fromDate: fromDate, toDate: toDate)
            isLoading = false

            saveSearch(keyword: query)
        }
    }

    func saveSearch(keyword: String) {
        if !previousSearches.contains(where: { $0.keyword == keyword }) {
            let newSearch = Search(keyword: keyword)
            context.insert(newSearch)
            do {
                try context.save()
            } catch {
                print("Error saving search: \(error)")
            }
        }
    }

    func deleteSearch(_ search: Search) {
        context.delete(search)
        do {
            try context.save()
        } catch {
            print("Error deleting search: \(error)")
        }
    }
    
    func resetSearchCriteria() {
        sortBy = "relevancy"
        language = ""
        fromDate = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
        toDate = Date()
    }
}
