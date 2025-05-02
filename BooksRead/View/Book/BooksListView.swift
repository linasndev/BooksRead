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
  
  @State private var isPresentedNewBookSheet: Bool = false
  @State private var sortOrder = SortOrder.status
  @State private var searchText: String = ""
  
  var body: some View {
    NavigationStack {
      Picker("", selection: $sortOrder) {
        ForEach(SortOrder.allCases) { sortOrder in
          Text("Sort by: \(sortOrder.rawValue)").tag(sortOrder)
        }
      }
      
      Group {
        BookList(sortOrder: sortOrder, searchText: searchText)
          .searchable(text: $searchText)
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
