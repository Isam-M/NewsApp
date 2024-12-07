

import SwiftUI
import SwiftData

struct CountryManagerview: View {
    @Query private var countries: [Country]
    @Environment(\.modelContext) private var context

    @State private var showingAddCountrySheet = false
    @State private var newCountryName = ""
    @State private var newCountryCode = ""

    var body: some View {
        List {
            ForEach(countries) { country in
                HStack {
                    Text(country.name)
                    Spacer()
                    Text(country.code)
                        .foregroundColor(.secondary)
                }
            }
            .onDelete { i in
                for index in i {
                    let country = countries[index]
                    context.delete(country)
                }
                try? context.save()
            }
        }
        .navigationTitle("Manage Countries")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingAddCountrySheet = true }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddCountrySheet) {
            NavigationStack {
                Form {
                    TextField("Country Name", text: $newCountryName)
                    TextField("Country Code", text: $newCountryCode)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
                .navigationTitle("Add New Country")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            showingAddCountrySheet = false
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            guard !newCountryName.isEmpty && !newCountryCode.isEmpty else {
                                return
                            }
                            let code = newCountryCode.lowercased()
                            let newCountry = Country(name: newCountryName, code: code)
                            context.insert(newCountry)
                            try? context.save()
                            showingAddCountrySheet = false
                            newCountryName = ""
                            newCountryCode = ""
                        }
                    }
                }
            }
        }
    }
}
