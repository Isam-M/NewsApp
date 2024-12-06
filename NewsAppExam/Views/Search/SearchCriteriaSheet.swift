import SwiftUI

struct SearchCriteriaSheet: View {
    @Binding var sortBy: String
    @Binding var language: String
    @Binding var fromDate: Date
    @Binding var toDate: Date
    
    let onApply: () -> Void
    let onReset: () -> Void

    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Sort By")) {
                    Picker("Sort By", selection: $sortBy) {
                        Text("Relevance").tag("relevancy")
                        Text("Popularity").tag("popularity")
                        Text("Published Date").tag("publishedAt")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                Section(header: Text("Language")){
                    Picker("Language", selection: $language){
                        Text("All Languages").tag("")
                        Text("Arabic").tag("ar")
                        Text("German").tag("de")
                        Text("English").tag("en")
                        Text("Spanish").tag("es")
                        Text("French").tag("fr")
                        Text("Hebrew").tag("he")
                        Text("Italian").tag("it")
                        Text("Dutch").tag("nl")
                        Text("Norwegian").tag("no")
                        Text("Portuguese").tag("pt")
                        Text("Russian").tag("ru")
                        Text("Swedish").tag("sv")
                        Text("Ukrainian").tag("uk")
                        Text("Chinese").tag("zh")
                    }
                }
                Section(header: Text("Date Range")) {
                    DatePicker("From", selection: $fromDate, displayedComponents: .date)
                    DatePicker("To", selection: $toDate, displayedComponents: .date)
                }
            }
            .navigationTitle("Search Criteria")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Reset") {
                        onReset()
                    }
                    .foregroundColor(.red)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Apply") {
                        onApply()
                        dismiss()
                    }
                }
            }
        }
    }
}
