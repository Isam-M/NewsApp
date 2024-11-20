import SwiftUI

struct ArticleDetailView: View {
    let article: ArticleResponse

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Bilde
                if let imageUrl = article.urlToImage, let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(8)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(maxWidth: .infinity)
                }

                // Tittel
                Text(article.title)
                    .font(.largeTitle)
                    .bold()
                    .multilineTextAlignment(.leading)

                // Kilde
                Text("Source: \(article.source.name)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                // Publiseringsdato
                if let publishedAt = article.publishedAt {
                    Text("Published: \(formatDate(publishedAt))")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                // Beskrivelse
                if let description = article.description {
                    Text(description)
                        .font(.body)
                        .multilineTextAlignment(.leading)
                }

                // Innhold
                if let content = article.content {
                    Text(content)
                        .font(.body)
                        .multilineTextAlignment(.leading)
                        .padding(.top)
                }

                // Lenke til full artikkel
                if let articleUrl = article.url, let url = URL(string: articleUrl) {
                    Link("Read full article", destination: url)
                        .font(.headline)
                        .foregroundColor(.blue)
                        .padding(.top)
                }

            }
            .padding()
        }
        .navigationTitle("Article Details")
        .navigationBarTitleDisplayMode(.inline)
    }

    // Formatterer dato til en lesbar stil
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
