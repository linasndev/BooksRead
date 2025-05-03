//
//  BookList.swift
//  BooksRead
//
//  Created by Linas on 02/05/2025.
//

import SwiftUI
import SwiftData

enum SortOrder: String, Identifiable, CaseIterable {
  case status, title, author
  
  var id: Self {
    return self
  }
}

struct BookList: View {
  
  @Environment(\.modelContext) private var modelContext
  
  @Query private var books: [BookModel]
  
  init(sortOrder: SortOrder, searchText: String) {
    
    let sortDescriptor: [SortDescriptor<BookModel>] = switch sortOrder {
    case .status:
      [SortDescriptor(\BookModel.status), SortDescriptor(\BookModel.title)]
    case .title:
      [SortDescriptor(\BookModel.title)]
    case .author:
      [SortDescriptor(\BookModel.author)]
    }
    
    let predicate = #Predicate<BookModel> { book in
      book.title.localizedStandardContains(searchText) || book.author.localizedStandardContains(searchText) || searchText.isEmpty
    }
    
    _books = Query(filter: predicate ,sort: sortDescriptor, animation: .bouncy)
  }
  
  var body: some View {
    if books.isEmpty {
      ContentUnavailableView("Enter your first book", systemImage: "book")
    } else {
      List {
        ForEach(books) { book in
          NavigationLink {
            BookDetailView(book: book)
          } label: {
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
                
                if let genres = book.genres {
                  ViewThatFits {
                    ScrollView(.horizontal) {
                      GenresStackView(genres: genres)
                    }
                    .scrollIndicators(.hidden)
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
}

#Preview {
  let preview = Preview(model: BookModel.self)
  preview.addExamples(BookModel.sampleBooks)
  
  return NavigationStack {
    BookList(sortOrder: .status, searchText: "")
      .modelContainer(preview.container)
  }
}
