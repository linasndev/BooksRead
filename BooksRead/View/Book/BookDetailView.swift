//
//  BookDetailView.swift
//  BooksRead
//
//  Created by Linas on 30/04/2025.
//

import SwiftUI
import SwiftData

struct BookDetailView: View {
  
  @Environment(\.dismiss) private var dismiss
  
  @State private var title: String = ""
  @State private var author: String = ""
  @State private var dateAdded: Date = Date.distantPast
  @State private var dateStarted: Date = Date.distantPast
  @State private var dateCompleted: Date = Date.distantPast
  @State private var synopsis: String = "" 
  @State private var rating: Int = 0
  @State private var status: Status = Status.onShelf
  @State private var recommendedBy: String = ""
  
  let book: BookModel
  
  var body: some View {
    HStack {
      Text("Status:")
      Picker("Status", selection: $status) {
        ForEach(Status.allCases) { status in
          Text(status.title).tag(status)
        }
      }
      .buttonStyle(.bordered)
    }
    
    VStack(alignment: .leading) {
      GroupBox {
        LabeledContent {
          DatePicker("", selection: $dateAdded, displayedComponents: .date)
        } label: {
          Text("Date Added")
        }
        
        if status == .inProgress || status == .completed {
          LabeledContent {
            DatePicker("", selection: $dateStarted, in: dateAdded..., displayedComponents: .date)
          } label: {
            Text("Date Started")
          }
        }
        
        if status == .completed {
          LabeledContent {
            DatePicker("", selection: $dateCompleted, in: dateStarted..., displayedComponents: .date)
          } label: {
            Text("Date Completed")
          }
        }
      }
      .foregroundStyle(.secondary)
      .onChange(of: status) { oldValue, newValue in
        if newValue == .onShelf {
          dateStarted = Date.distantPast
          dateCompleted = Date.distantPast
        } else if newValue == .inProgress && oldValue == .completed {
          //from completed to inProgress
          dateCompleted = Date.distantPast
        } else if newValue == .inProgress && oldValue == .onShelf {
          //book has been started
          dateStarted = Date.now
        } else if newValue == .completed && oldValue == .onShelf {
          //forgot to start
          dateCompleted = Date.now
          dateStarted = dateAdded
        } else {
          //completed
          dateCompleted = Date.now
        }
      }
      
      Divider()
      
      
      LabeledContent {
        RatingsView(maxRating: 5, currentRating: $rating, width: 30)
      } label: {
        Text("Rating")
      }
      
      LabeledContent {
        TextField("", text: $title)
      } label: {
        Text("Title")
          .foregroundStyle(.secondary)
      }
      
      LabeledContent {
        TextField("", text: $author)
      } label: {
        Text("Author")
          .foregroundStyle(.secondary)
      }
      
      LabeledContent {
        TextField("", text: $recommendedBy)
      } label: {
        Text("Recommended By")
          .foregroundStyle(.secondary)
      }
      
      Divider()
      
      Text("Synopsis")
        .foregroundStyle(.secondary)
      
      TextEditor(text: $synopsis)
        .padding(5)
        .overlay {
          RoundedRectangle(cornerRadius: 20)
            .stroke(Color(uiColor: .tertiarySystemFill), lineWidth: 2)
        }
      
      NavigationLink(value: book) {
        let count = book.quotes?.count ?? 0
        Label("^[\(count) Quotes](inflect: true)", systemImage: "quote.opening")
      }
      .frame(maxWidth: .infinity, alignment: .trailing)
      .buttonStyle(.bordered)
      .padding(.horizontal)
    }
    .padding()
    .textFieldStyle(.roundedBorder)
    .onAppear(perform: {
      status = Status(rawValue: book.status) ?? Status.onShelf
      rating = book.rating ?? 0
      title = book.title
      author = book.author
      synopsis = book.synopsis
      dateAdded = book.dateAdded
      dateStarted = book.dateStarted
      dateCompleted = book.dateCompleted
      recommendedBy = book.recommendedBy
    })
    .navigationTitle(title)
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        if changed {
          Button("Update") {
            book.status = status.rawValue
            book.rating = rating
            book.title = title
            book.author = author
            book.synopsis = synopsis
            book.dateAdded = dateAdded
            book.dateStarted = dateStarted
            book.dateCompleted = dateCompleted
            book.recommendedBy = recommendedBy
            dismiss()
          }
          .animation(.easeInOut, value: changed)
        }
      }
    }
    .navigationDestination(for: BookModel.self) { book in
      QuoteListView(book: book)
    }
  }
  
  var changed: Bool {
    //ctrl + shift + click for choose each line
    status != Status(rawValue: book.status)
    || rating != book.rating ?? 0
    || title != book.title
    || author != book.author
    || synopsis != book.synopsis
    || dateAdded != book.dateAdded
    || dateStarted != book.dateStarted
    || dateCompleted != book.dateCompleted
    || recommendedBy != book.recommendedBy
  }
}

#Preview {
  let preview = Preview(model: BookModel.self)
  return NavigationStack {
    BookDetailView(book: BookModel.sampleBooks[3])
      .modelContainer(preview.container)
  }
//  let container = BookModel.preview
//  let fetchDescriptor = FetchDescriptor<BookModel>()
//  let book = try! container.mainContext.fetch(fetchDescriptor)[0]
//  return NavigationStack {
//    BookDetailView(book: book)
//      .modelContainer(container)
//  }
}
