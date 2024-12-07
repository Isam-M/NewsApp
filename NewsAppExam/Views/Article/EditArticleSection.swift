





import SwiftUI
import SwiftData

struct EditArticleSection: View {
    @Binding var selectedCategory: Category?
    @Binding var notes: String
    @Binding  var isEditingCategory: Bool
    @Binding  var isEditingNotes: Bool
    var categories: [Category]
    var onSave: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            HStack {
                if isEditingCategory {
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(categories, id: \.self) { category in
                            Text(category.name).tag(category)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                } else {
                    Text("Category: \(selectedCategory?.name ?? "None")")
                        .font(.headline)
                }
                Spacer()
                Button(action: { isEditingCategory.toggle() }) {
                    Image(systemName: "pencil")
                        .foregroundColor(.blue)
                }
            }

            
            HStack {
                if isEditingNotes {
                    TextField("Update notes...", text: $notes)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                } else {
                    VStack(alignment: .leading) {
                        Text("Notes:")
                            .font(.headline)
                        Text(notes.isEmpty ? "No notes added" : notes)
                            .font(.body)
                    }
                }
                Spacer()
                Button(action: { isEditingNotes.toggle() }) {
                    Image(systemName: "pencil")
                        .foregroundColor(.blue)
                }
            }

            
            if isEditingCategory || isEditingNotes {
                Button(action: onSave) {
                    Text("Save Changes")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
    }
}
