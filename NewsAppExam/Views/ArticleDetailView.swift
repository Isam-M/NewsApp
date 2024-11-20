import SwiftUI
import SwiftData

struct ArticleDetailView: View {
    let article: Article?
    let apiArticle: ArticleResponse?

    @Environment(\.modelContext) private var context
    @State private var selectedCategory: Category?
    @State private var notes: String = ""
    @Query private var categories: [Category]

    init(article: Article? = nil, apiArticle: ArticleResponse? = nil) {
        self.article = article
        self.apiArticle = apiArticle
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Bilde
                if let imageUrl = apiArticle?.urlToImage ?? article?.urlToImage, let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { image in
                        image.resizable().scaledToFit().cornerRadius(8)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(maxWidth: .infinity)
                }

                // Tittel
                Text(apiArticle?.title ?? article?.title ?? "No Title")
                    .font(.largeTitle)
                    .bold()

                // Kilde
                Text("Source: \(apiArticle?.source.name ?? article?.source ?? "Unknown")")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                // Publiseringsdato
                if let publishedAt = apiArticle?.publishedAt ?? article?.publishedAt {
                    Text("Published: \(formatDate(publishedAt))")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                // Beskrivelse
                if let description = apiArticle?.description ?? article?.articleDescription {
                    Text(description)
                        .font(.body)
                }

                if article == nil {
                    // Lagre artikkel-knapp for API-hentede artikler
                    saveArticleSection()
                } else {
                    // Vis notater for lagrede artikler
                    if let notes = article?.notes, !notes.isEmpty {
                        Text("Notes:")
                            .font(.headline)
                        Text(notes)
                            .font(.body)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Article Details")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func saveArticleSection() -> some View {
        VStack {
            Picker("Category", selection: $selectedCategory) {
                Text("None").tag(nil as Category?)
                ForEach(categories, id: \.self) { category in
                    Text(category.name).tag(category as Category?)
                }
            }
            .pickerStyle(MenuPickerStyle())

            TextField("Add notes...", text: $notes)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button(action: saveArticle) {
                Text("Save Article")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }

    private func saveArticle() {
        guard let apiArticle = apiArticle, let selectedCategory = selectedCategory else { return }

        let newArticle = Article(
            title: apiArticle.title,
            description: apiArticle.description,
            source: apiArticle.source.name,
            url: apiArticle.url,
            urlToImage: apiArticle.urlToImage,
            publishedAt: apiArticle.publishedAt,
            content: apiArticle.content,
            category: selectedCategory,
            notes: notes
        )

        context.insert(newArticle)

        do {
            try context.save()
            print("Article saved!")
        } catch {
            print("Failed to save article: \(error)")
        }
    }

    private func formatDate(_ isoDate: String) -> String {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: isoDate) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateStyle = .medium
            return displayFormatter.string(from: date)
        }
        return isoDate
    }
}
