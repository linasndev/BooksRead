//
//  BookDetailView.swift
//  BooksRead
//
//  Created by Linas on 30/04/2025.
//

import SwiftUI
import SwiftData
import PhotosUI

struct BookDetailView: View {
  
  @Environment(\.dismiss) private var dismiss
  
  @State private var status: Status
  
  @State private var title: String = ""
  @State private var author: String = ""
  @State private var dateAdded: Date = Date.distantPast
  @State private var dateStarted: Date = Date.distantPast
  @State private var dateCompleted: Date = Date.distantPast
  @State private var synopsis: String = ""
  @State private var rating: Int = 0
  @State private var recommendedBy: String = ""
  
  @State private var isPresentedGenresListView: Bool = false
  @State private var isPresentedQuotesListView: Bool = false
  
  @State private var selectedBookCover: PhotosPickerItem?
  @State private var selectedBookCoverData: Data?
  
  let book: BookModel
  
  init(book: BookModel) {
    self.book = book
    _status = State(initialValue: Status(rawValue: book.status) ?? Status.onShelf)
  }
  
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
          switch status {
          case .onShelf:
            DatePicker("", selection: $dateAdded, displayedComponents: .date)
          case .inProgress, .completed:
            DatePicker("", selection: $dateAdded, in: ...dateStarted, displayedComponents: .date)
          }
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
      
      
      HStack {
        
        PhotosPicker(selection: $selectedBookCover, matching: .images, photoLibrary: .shared()) {
          Group {
            if let selectedBookCoverData, let uiImage = UIImage(data: selectedBookCoverData) {
              Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
            } else {
              Image(systemName: "photo")
                .resizable()
                .scaledToFit()
            }
          }
          .frame(width: 75, height: 100)
          .overlay(alignment: .bottomTrailing) {
            if selectedBookCoverData != nil {
              Button {
                selectedBookCover = nil
                selectedBookCoverData = nil
              } label: {
                Image(systemName: "x.circle.fill")
                  .foregroundStyle(.red)
              }
            }
          }
        }
        
        VStack {
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
        }
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
      
      if let genres = book.genres {
        ViewThatFits {
          ScrollView(.horizontal) {
            GenresStackView(genres: genres)
          }
          .scrollIndicators(.hidden)
        }
      }
      
      HStack {
        Button("Genres", systemImage: "bookmark.fill") {
          isPresentedGenresListView.toggle()
        }
        
        Button("^[\(book.quotes?.count ?? 0) Quotes](inflect: true)", systemImage: "quote.opening") {
          isPresentedQuotesListView.toggle()
        }
      }
      .frame(maxWidth: .infinity, alignment: .trailing)
      .buttonStyle(.bordered)
      .padding()
    }
    .padding()
    .textFieldStyle(.roundedBorder)
    .navigationTitle(title)
    .navigationBarTitleDisplayMode(.inline)
    .onAppear(perform: {
      rating = book.rating ?? 0
      title = book.title
      author = book.author
      synopsis = book.synopsis
      dateAdded = book.dateAdded
      dateStarted = book.dateStarted
      dateCompleted = book.dateCompleted
      recommendedBy = book.recommendedBy
      selectedBookCoverData = book.bookCover
    })
    .task(id: selectedBookCover) {
      if let data = try? await selectedBookCover?.loadTransferable(type: Data.self) {
        selectedBookCoverData = data
      }
    }
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
            book.bookCover = selectedBookCoverData
            dismiss()
          }
          .animation(.easeInOut, value: changed)
        }
      }
    }
    .popover(isPresented: $isPresentedQuotesListView) {
      QuoteListView(book: book)
        .presentationCompactAdaptation(.sheet)
    }
    .popover(isPresented: $isPresentedGenresListView) {
      GenresListView(book: book)
        .presentationCompactAdaptation(.sheet)
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
    || selectedBookCoverData != book.bookCover
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
