//
//  NewBookView.swift
//  BooksRead
//
//  Created by Linas on 29/04/2025.
//

import SwiftUI
import SwiftData

struct NewBookView: View {
  @Environment(\.modelContext) private var modelContext
  @Environment(\.dismiss) private var dismiss
  
  @State private var title: String = ""
  @State private var author: String = ""
  
  var body: some View {
    NavigationStack {
      Form {
        TextField("Book Title", text: $title)
        TextField("Author", text: $author)
        
        Button("Create") {
          let newBook = BookModel(title: title, author: author)
          
          do {
            modelContext.insert(newBook)
            try modelContext.save()
          } catch {
            print("❌ Can't save book")
          }
          
          dismiss()
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .buttonStyle(.borderedProminent)
        .padding(.vertical)
        .disabled(title.isEmpty || author.isEmpty)
        .navigationTitle("New Book")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
          ToolbarItem(placement: .topBarLeading) {
            Button("Cancel") {
              dismiss()
            }
          }
        }
      }
    }
  }
}

#Preview {
  NewBookView()
}
