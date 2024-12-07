




import SwiftUI
import SwiftData

struct SaveArticleSection: View {
    @Binding var selectedCategory: Category?
    @Binding var notes: String
    var categories: [Category]
    var onSave: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Select a category:")
                .font(.headline)
            Picker("Category", selection: $selectedCategory) {
                Text("None").tag(nil as Category?)
                ForEach(categories, id: \.self) { category in
                    Text(category.name).tag(category as Category?)
                }
            }
            .pickerStyle(MenuPickerStyle())

            TextField("Add notes...", text: $notes)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.top)

            Button(action: onSave) {
                Text("Save Article")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }
}
