import SwiftUI

struct NewsTickerView: View {
    let headlines: [String]
    @Binding var enlargedHeadline: String?
    @AppStorage("tickerFontSize") private var tickerFontSizeValue: Double = 16
    @AppStorage("tickerTextColor") private var tickerTextColorHex: String = "#000000"

    private var tickerFontSize: CGFloat {
        CGFloat(tickerFontSizeValue)
    }

    private var tickerTextColor: Color {
        Color(hex: tickerTextColorHex) ?? .primary
    }

    @State private var offsetX: CGFloat = 0
    @State private var isAnimating: Bool = false
    @State private var contentWidth: CGFloat = 0

    private let tickerSpeed: CGFloat = 100
    private let tickerHeight: CGFloat = 50
    private let headlineSpacing: CGFloat = 50

    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: headlineSpacing) {
                ForEach(headlines, id: \.self) { headline in
                    Text(headline)
                        .font(.system(size: tickerFontSize))
                        .foregroundColor(tickerTextColor)
                        .lineLimit(1)
                        .fixedSize(horizontal: true, vertical: false)
                        .onTapGesture {
                            handleHeadlineTap(headline)
                        }
                }
            }
            .background(
                GeometryReader { geo in
                    Color.clear // trengte denne for å legge til onAppear
                        .onAppear {
                            contentWidth = geo.size.width
                        }
                }
            )
            .offset(x: offsetX)
            .onAppear {
                startTickerAnimation(geometry.size.width)
            }
        }
        .frame(height: tickerHeight)
    }

    private func startTickerAnimation(_ frameWidth: CGFloat) {
        guard !isAnimating else { return }
        isAnimating = true
        offsetX = frameWidth

        animateScrolling(totalWidth: frameWidth)
    }

    private func animateScrolling(totalWidth: CGFloat) {
        let duration = Double((contentWidth + totalWidth) / tickerSpeed)

        withAnimation(Animation.linear(duration: duration)) {
            offsetX = -contentWidth
        }

        //Får animasjonen til å starte på nytt når den er ferdig for å virke som evig loop
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            if isAnimating {
                offsetX = totalWidth
                animateScrolling(totalWidth: totalWidth)
            }
        }
    }

    private func handleHeadlineTap(_ headline: String) {
        enlargedHeadline = headline
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            if enlargedHeadline == headline {
                enlargedHeadline = nil
            }
        }
    }
}
