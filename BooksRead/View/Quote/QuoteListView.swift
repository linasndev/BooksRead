//
//  QuoteListView.swift
//  BooksRead
//
//  Created by Linas on 03/05/2025.
//

import SwiftUI
import SwiftData

struct QuoteListView: View {
  
  @Environment(\.modelContext) private var modelContext
  
  @State private var text: String = ""
  @State private var page: String = ""
  @State private var selectedQuote: QuoteModel?
  
  let book: BookModel
  
  var body: some View {
    GroupBox {
      HStack {
        LabeledContent("Page") {
          TextField("page #", text: $page)
            .autocorrectionDisabled()
            .textFieldStyle(.roundedBorder)
            .frame(width: 150)
          Spacer()
        }
        
        if isEditingQuote {
          Button("Cancel") {
            text = ""
            page = ""
            selectedQuote = nil
          }
          .buttonStyle(.bordered)
        }
        
        Button(isEditingQuote ? "Update" : "Create") {
          if isEditingQuote {
            selectedQuote?.text = text
            selectedQuote?.page = page.isEmpty ? nil : page
            page = ""
            text = ""
            selectedQuote = nil
          } else {
            let quote = page.isEmpty ? QuoteModel(text: text) : QuoteModel(text: text, page: page)
            book.quotes?.append(quote)
            text = ""
            page = ""
          }
        }
        .buttonStyle(.borderedProminent)
        .disabled(text.isEmpty)
      }
      
      TextEditor(text: $text)
        .border(Color.secondary)
        .frame(height: 100)
    }
    .padding(.horizontal)
    
    List {
      let sortedQuotes = book.quotes?.sorted(using: KeyPathComparator(\QuoteModel.creationDate)) ?? []
      
      ForEach(sortedQuotes) { quote in
        VStack(alignment: .leading) {
          Text(quote.creationDate, format: .dateTime.month().day().year())
            .foregroundStyle(.secondary)
            .font(.caption)
          
          Text(quote.text)
          
          HStack {
            Spacer()
            if let page = quote.page, !page.isEmpty {
              Text("Page: \(page)")
            }
          }
        }
        .contentShape(Rectangle())
        .onTapGesture {
          selectedQuote = quote
          text = quote.text
          page = quote.page ?? ""
        }
      }
      .onDelete { indexSet in
        withAnimation {
          indexSet.forEach { index in
            if let quote = book.quotes?[index] {
              modelContext.delete(quote)
            }
          }
        }
      }
    }
    .listStyle(.plain)
    .navigationTitle("Quotes")
    .navigationBarTitleDisplayMode(.inline)
  }
  
  var isEditingQuote: Bool {
    selectedQuote != nil
  }
}

#Preview {
  let preview = Preview(model: BookModel.self)
  let books = BookModel.sampleBooks
  preview.addExamples(books)
  return NavigationStack {
    QuoteListView(book: books[2])
      .modelContainer(preview.container)
  }
}
