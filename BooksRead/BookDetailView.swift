//
//  BookDetailView.swift
//  BooksRead
//
//  Created by Linas on 29/04/2025.
//

import SwiftUI
import SwiftData

struct BookDetailView: View {
  
  let book: BookModel
  
    var body: some View {
      Form {
        Text(book.title)
      }
      .navigationTitle("Book Detail")
      .toolbar {
        Button("Test") {
          
        }
      }
    }
}

#Preview {
  let container = BookModel.preview
  let fetchDescriptor = FetchDescriptor<BookModel>()
  let book = try! container.mainContext.fetch(fetchDescriptor)[0]
  BookDetailView(book: book)
    .modelContainer(container)
}
