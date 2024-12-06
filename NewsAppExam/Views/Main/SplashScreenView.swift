import SwiftUI

struct SplashScreenView: View {
    @State private var isAnimating = false
    @State private var opacity = 0.0

    var body: some View {
        ZStack {
            
            Color.black
                .edgesIgnoringSafeArea(.all)

            
            VStack {
                
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                gradient: Gradient(colors: [.purple, .blue, .black]),
                                center: .center,
                                startRadius: 5,
                                endRadius: 500
                            )
                        )
                        .scaleEffect(isAnimating ? 1.2 : 0.8)
                        .opacity(0.8)
                        .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: isAnimating)

                    
                    Image("newscat")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .foregroundColor(.white)
                        .rotationEffect(.degrees(isAnimating ? 360 : 0))
                        .animation(.linear(duration: 3).repeatForever(autoreverses: false), value: isAnimating)
                }

            
                Text("Welcome To My NewsApp")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 30)
                    .opacity(opacity)

                // Undertekst
                Text("All the news, one search away.")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding(.top, 10)
                    .opacity(opacity)
            }
        }
        .onAppear {
            
            isAnimating = true
            withAnimation(.easeIn(duration: 2)) {
                opacity = 1.0
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
