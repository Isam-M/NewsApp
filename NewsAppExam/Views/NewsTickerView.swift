import SwiftUI

struct NewsTickerView: View {
    let headlines: [String]

    @AppStorage("tickerFontSize") private var tickerFontSizeValue: Double = 16
    //Måtte ha string pga appstorage
    @AppStorage("tickerTextColor") private var tickerTextColorHex: String = "#000000"

    private var tickerFontSize: CGFloat {
        CGFloat(tickerFontSizeValue)
    }

    private var tickerTextColor: Color {
        Color(hex: tickerTextColorHex) ?? .primary
    }

    @State private var offsetX: CGFloat = UIScreen.main.bounds.width
    private let scrollSpeed: CGFloat = 80
 
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 50) {
                ForEach(headlines, id: \.self) { headline in
                    Text(headline)
                        .font(.system(size: tickerFontSize))
                        .foregroundColor(tickerTextColor)
                        .lineLimit(1)
                        .fixedSize(horizontal: true, vertical: false)
                }
            }
            .frame(width: geometry.size.width * CGFloat(headlines.count + 1))
            .offset(x: offsetX)
            .onAppear {
                startAnimation(screenWidth: geometry.size.width)
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 15)
            .background(
                RoundedRectangle(cornerRadius: 0)
                    .fill(Color(UIColor.systemBackground))
                    .shadow(color: Color(UIColor.label).opacity(0.2), radius: 6, x: 2, y: 2)
            )
        }
        .frame(height: 50)
    }

    private func startAnimation(screenWidth: CGFloat) {
        offsetX = screenWidth
        let totalWidth = screenWidth * CGFloat(headlines.count + 2)
        let animationDuration = totalWidth / scrollSpeed

        withAnimation(Animation.linear(duration: animationDuration).repeatForever(autoreverses: false)) {
            offsetX = -totalWidth
        }
    }
}
