import SwiftUI

struct NewsTickerView: View {
    let headlines: [String]
    let duration: Double

    @State private var offsetX: CGFloat = UIScreen.main.bounds.width

    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 50) { // Bruker spacing for å separere titlene
                ForEach(headlines, id: \.self) { headline in
                    Text(headline)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .lineLimit(1) // Sørger for én linje
                        .fixedSize(horizontal: true, vertical: false) // Unngår tekstklipping
                }
            }
            .offset(x: offsetX)
            .onAppear {
                startAnimation(geometry: geometry)
            }
        }
        .frame(height: 50) // Fast høyde for tickeren
    }

    private func startAnimation(geometry: GeometryProxy) {
        let totalWidth = geometry.size.width + CGFloat(headlines.count) * geometry.size.width / 3 // Tilpass til antall overskrifter
        offsetX = geometry.size.width
        withAnimation(Animation.linear(duration: duration).repeatForever(autoreverses: false)) {
            offsetX = -totalWidth // Flytt gjennom alle overskrifter
        }
    }
}
