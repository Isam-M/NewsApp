import SwiftUI
import SwiftData

struct ArticleDetailView: View {
    let article: Article?
    let apiArticle: ArticleResponse?

    @Environment(\.modelContext) private var context
    @State private var selectedCategory: Category?
    @State private var notes: String = ""
    @State private var isEditingCategory: Bool = false
    @State private var isEditingNotes: Bool = false
    @State private var isSaved: Bool = false
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
                    Text("Published: \(DateFormatterHelper.formatDate(publishedAt))")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                // Beskrivelse
                if let description = apiArticle?.description ?? article?.articleDescription {
                    Text(description)
                        .font(.body)
                        .padding(.bottom)
                }

                // Innhold
                if let content = apiArticle?.content ?? article?.content {
                    Text("Content:")
                        .font(.headline)
                        .padding(.bottom, 4)
                    Text(content)
                        .font(.body)
                }

                // Velg lagre- eller redigeringsseksjon
                if article == nil && !isSaved {
                    SaveArticleSection(
                        selectedCategory: $selectedCategory,
                        notes: $notes,
                        categories: categories,
                        onSave: saveArticle
                    )
                } else {
                    EditArticleSection(
                        selectedCategory: $selectedCategory,
                        notes: $notes,
                        isEditingCategory: $isEditingCategory,
                        isEditingNotes: $isEditingNotes,
                        categories: categories,
                        onSave: updateArticle
                    )
                }
            }
            .padding()
        }
        .navigationTitle("Article Details")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if let article = article {
                selectedCategory = article.category
                notes = article.notes
            }
        }
    }

    
    private func saveArticle() {
        guard let apiArticle = apiArticle, let selectedCategory = selectedCategory else {
            print("Please select a category")
            return
        }

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
            isSaved = true
        } catch {
            print("Failed to save article: \(error)")
        }
    }

    
    private func updateArticle() {
        guard let article = article else { return }

        if let newCategory = selectedCategory {
            article.category = newCategory
        }
        article.notes = notes
        article.updatedAt = Date()

        do {
            try context.save()
            print("Article updated!")
            isEditingCategory = false
            isEditingNotes = false
        } catch {
            print("Failed to update article: \(error)")
        }
    }
}
