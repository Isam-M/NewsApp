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
    private let scrollSpeed: CGFloat = 100 // Adjust speed here
    @State private var contentWidth: CGFloat = 0
    @State private var timer: Timer?

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Ticker Content
                HStack(spacing: 50) {
                    ForEach(0..<2) { _ in
                        ForEach(headlines, id: \.self) { headline in
                            Text(headline)
                                .font(.system(size: tickerFontSize))
                                .foregroundColor(tickerTextColor)
                                .lineLimit(1)
                                .fixedSize(horizontal: true, vertical: false)
                                .onTapGesture {
                                    print("Tapped headline: \(headline)")
                                    enlargedHeadline = headline

                                    // Forsinkelse før den går tilbake
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                        if enlargedHeadline == headline {
                                            enlargedHeadline = nil
                                        }
                                    }
                                }
                        }
                    }
                }
                .background(
                    GeometryReader { geo in
                        Color.clear
                            .onAppear {
                                contentWidth = geo.size.width / 2
                            }
                    }
                )
                .offset(x: offsetX)
                .onAppear {
                    startScrolling()
                }
                .onDisappear {
                    stopScrolling()
                }
            }
        }
        .frame(height: 50)
    }

    func startScrolling() {
        stopScrolling() // Ensure any existing timer is invalidated
        timer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { _ in
            offsetX -= scrollSpeed * 0.02
            if abs(offsetX) >= contentWidth {
                offsetX = 0
            }
        }
    }

    func stopScrolling() {
        timer?.invalidate()
        timer = nil
    }
}
