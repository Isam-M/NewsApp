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

                if article == nil && !isSaved {
                    saveArticleSection()
                } else {
                    editArticleSection()
                }
            }
            .padding()
        }
        .navigationTitle("Article Details")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func saveArticleSection() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Select a category:")
                .font(.headline)
            Picker("Category", selection: $selectedCategory) {
                Text("None").tag(nil as Category?)
                ForEach(categories, id: \.self) { category in
                    Text(category.name).tag(category as Category?)
                }
            }
            .pickerStyle(MenuPickerStyle())

            TextField("Add notes...", text: $notes)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.top)

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

    private func editArticleSection() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            // Rediger kategori
            HStack {
                if isEditingCategory {
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(categories, id: \.self) { category in
                            Text(category.name).tag(category)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .onAppear {
                        if selectedCategory == nil, let currentCategory = article?.category {
                            selectedCategory = currentCategory
                        }
                    }
                } else {
                    Text("Category: \(article?.category.name ?? "None")")
                        .font(.headline)
                }
                Spacer()
                Button(action: { isEditingCategory.toggle() }) {
                    Image(systemName: "pencil")
                        .foregroundColor(.blue)
                }
            }

            // Rediger notater
            HStack {
                if isEditingNotes {
                    TextField("Update notes...", text: $notes)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onAppear {
                            if notes.isEmpty, let currentNotes = article?.notes {
                                notes = currentNotes
                            }
                        }
                } else {
                    VStack(alignment: .leading) {
                        Text("Notes:")
                            .font(.headline)
                        Text(article?.notes ?? "No notes added")
                            .font(.body)
                    }
                }
                Spacer()
                Button(action: { isEditingNotes.toggle() }) {
                    Image(systemName: "pencil")
                        .foregroundColor(.blue)
                        
                }
            }

            // Lagre endringer
            if isEditingCategory || isEditingNotes {
                Button(action: updateArticle) {
                    Text("Save Changes")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
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
        if !notes.isEmpty {
            article.notes = notes
        }

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
