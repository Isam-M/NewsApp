import SwiftUI

struct APIKeySettingsView: View {
    @State private var apiKey: String = ""
    private let defaultApiKey = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Enter your personal API Key for NewsAPI.org")
                .font(.headline)
                .padding(.bottom)

            TextField("API Key", text: $apiKey)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.bottom)

            HStack {
                Button(action: saveAPIKey) {
                    Text("Save API Key")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(apiKey.isEmpty ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(apiKey.isEmpty)

                Button(action: resetToDefault) {
                    Text("Reset to Default")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
        .padding()
        .navigationTitle("Set API Key")
        .onAppear(perform: loadAPIKey)
    }

    private func loadAPIKey() {
        apiKey = UserDefaults.standard.string(forKey: "apiKey") ?? defaultApiKey
    }

    private func saveAPIKey() {
        UserDefaults.standard.set(apiKey, forKey: "apiKey")
        print("API Key saved: \(apiKey)")
    }

    private func resetToDefault() {
        apiKey = defaultApiKey
        saveAPIKey()
        print("API Key reset to default: \(defaultApiKey)")
    }
}
