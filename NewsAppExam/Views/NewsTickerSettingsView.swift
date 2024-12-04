import SwiftUI
import SwiftData

struct NewsTickerSettingsView: View {
    @AppStorage("tickerPosition") private var tickerPosition: String = "top"
    @AppStorage("isTickerEnabled") private var isTickerEnabled: Bool = true
    @AppStorage("tickerNewsCount") private var tickerNewsCount: Int = 5
    @AppStorage("tickerFontSize") private var tickerFontSizeValue: Double = 16
    @AppStorage("tickerTextColor") private var tickerTextColorHex: String = "#000000"
    @AppStorage("tickerCountry") private var tickerCountry: String = "us"
    @AppStorage("tickerCategory") private var tickerCategory: String = "general"
    
    @Query private var countries: [Country]
    @State private var showAlert: Bool = false
     
    var body: some View {
        Form {
            Section(header: Text("Ticker Options")) {
                Toggle("Enable Ticker", isOn: $isTickerEnabled)
                
                Picker("Ticker Position", selection: $tickerPosition) {
                    Text("Top").tag("top")
                    Text("Bottom").tag("bottom")
                }
                .pickerStyle(SegmentedPickerStyle())
                
                Stepper("News Count: \(tickerNewsCount)", value: $tickerNewsCount, in: 1...20)
                
                Picker("Country", selection: $tickerCountry) {
                    Text("All").tag("")
                    ForEach(countries) { country in
                        Text(country.name).tag(country.code)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .onChange(of: tickerCountry) {
                    if tickerCountry == "" {
                        if tickerCategory.isEmpty {
                            tickerCategory = "general"
                        }
                    }
                    if tickerCountry != "us" {
                        showAlert = true
                        }
                    }
                    
                    Picker("Category", selection: $tickerCategory) {
                        Text("All").tag("")
                        Text("General").tag("general")
                        Text("Business").tag("business")
                        Text("Entertainment").tag("entertainment")
                        Text("Health").tag("health")
                        Text("Science").tag("science")
                        Text("Sports").tag("sports")
                        Text("Technology").tag("technology")
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                
                Section(header: Text("Font Size")) {
                    Slider(value: $tickerFontSizeValue, in: 10...30, step: 1) {
                        Text("Font Size")
                    }
                    Text("Font Size: \(Int(tickerFontSizeValue))")
                        .font(.system(size: CGFloat(tickerFontSizeValue)))
                }
                
                Section(header: Text("Text Color")) {
                    ColorPicker("Pick Text Color", selection: Binding(
                        get: { Color(hex: tickerTextColorHex) ?? .primary },
                        set: { newColor in tickerTextColorHex = newColor.hex }
                    ))
                }
            }
            .alert("Country Not Supported", isPresented: $showAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Currently, the API only supports 'United States'. Other countries will not display any headlines.")
            }
            .navigationTitle("News Ticker Settings")
        }
    }
    
    
    extension Color {
        init?(hex: String) {
            let r, g, b: CGFloat
            
            if hex.hasPrefix("#") {
                let start = hex.index(hex.startIndex, offsetBy: 1)
                let hexColor = String(hex[start...])
                
                if hexColor.count == 6,
                   let rgbValue = Int(hexColor, radix: 16) {
                    r = CGFloat((rgbValue >> 16) & 0xFF) / 255
                    g = CGFloat((rgbValue >> 8) & 0xFF) / 255
                    b = CGFloat(rgbValue & 0xFF) / 255
                    self = Color(red: r, green: g, blue: b)
                    return
                }
            }
            return nil
        }
        
        var hex: String {
            let components = UIColor(self).cgColor.components
            let r = Float(components?[0] ?? 0) * 255
            let g = Float(components?[1] ?? 0) * 255
            let b = Float(components?[2] ?? 0) * 255
            return String(format: "#%02lX%02lX%02lX", Int(r), Int(g), Int(b))
        }
    }
    

