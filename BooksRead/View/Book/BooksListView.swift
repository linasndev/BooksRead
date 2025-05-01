//
//  ContentView.swift
//  BooksRead
//
//  Created by Linas on 29/04/2025.
//

import SwiftUI
import SwiftData

struct BooksListView: View {
  
  @Environment(\.modelContext) private var modelContext
  
  @Query(sort: \BookModel.title) private var books: [BookModel]
  
  @State private var isPresentedNewBookSheet: Bool = false
  
  var body: some View {
    NavigationStack {
      Group {
        if books.isEmpty {
          ContentUnavailableView("Enter your first book", systemImage: "book")
        } else {
          List {
            ForEach(books) { book in
              NavigationLink(value: book) {
                HStack {
                  book.icon
                  
                  VStack(alignment: .leading) {
                    Text(book.title)
                      .font(.title3)
                    Text(book.author)
                      .foregroundStyle(.secondary)
                    
                    if let rating = book.rating {
                      HStack {
                        ForEach(0..<rating, id: \.self) { _ in
                          Image(systemName: "star.fill")
                            .imageScale(.small)
                            .foregroundStyle(.orange)
                        }
                      }
                    }
                  }
                }
              }
            }
            .onDelete { indexSet in
              indexSet.forEach { index in
                let deleteBook = books[index]
                modelContext.delete(deleteBook)
              }
            }
          }
          .listStyle(.plain)
        }
      }
      .navigationTitle("My Books")
      .navigationDestination(for: BookModel.self, destination: { book in
        BookDetailView(book: book)
      })
      .toolbar {
        Button {
          isPresentedNewBookSheet.toggle()
        } label: {
          Image(systemName: "plus.circle.fill")
            .imageScale(.large)
        }
      }
      .popover(isPresented: $isPresentedNewBookSheet) {
        NewBookView()
          .presentationCompactAdaptation(.sheet)
          .presentationDetents([.medium])
      }
    }
  }
}

#Preview {
  let preview = Preview(model: BookModel.self)
  preview.addExamples(BookModel.sampleBooks)
  return BooksListView()
    .modelContainer(preview.container)
}
