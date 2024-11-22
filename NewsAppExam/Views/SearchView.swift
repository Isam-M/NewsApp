import SwiftUI
import SwiftData

struct SearchView: View {
    @State private var query = ""
    @State private var articles: [ArticleResponse] = []
    @State private var isLoading = false
    @FocusState private var isSearchFieldFocused: Bool // Håndterer fokusstatus

    // Bruk @Query for å hente tidligere søk automatisk
    @Query(sort: \Search.createdAt, order: .reverse) private var previousSearches: [Search]
    
    @Environment(\.modelContext) private var context // SwiftData-kontekst

    let apiService = APIService()

    var body: some View {
        NavigationStack {
            VStack {
                // Søkefelt
                TextField("Search news...", text: $query, onCommit: {
                    performSearch()
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .focused($isSearchFieldFocused) // Binder fokusstatus
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .padding(.leading, 8)
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

                // "Nylige søk"-seksjonen
                if isSearchFieldFocused && !previousSearches.isEmpty {
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
                                        isSearchFieldFocused = false // Skjul listen når et søk velges
                                        performSearch()
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .frame(maxHeight: 200) // Begrens høyden på listen
                }

                // Vis søkeresultater eller lastestatus
                if isLoading {
                    ProgressView("Loading...")
                } else {
                    List(articles) { article in
                        NavigationLink(destination: ArticleDetailView(apiArticle: article)) {
                            HStack {
                                // Bilde hvis tilgjengelig
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
                                }
                                
                                // Tittel og kilde
                                VStack(alignment: .leading) {
                                    Text(article.title)
                                        .font(.headline)
                                    Text(article.source.name)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Search News")
        }
    }
    
    func performSearch() {
        Task {
            isLoading = true
            articles = await apiService.fetchArticles(query: query)
            isLoading = false
            
            // Lagre søket hvis det er nytt
            saveSearch(keyword: query)
        }
    }
    
    func saveSearch(keyword: String) {
        // Sjekk om søket allerede finnes
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
        // Slett søk fra databasen
        context.delete(search)
        do {
            try context.save()
        } catch {
            print("Error deleting search: \(error)")
        }
    }
}

#Preview {
    SearchView()
}
