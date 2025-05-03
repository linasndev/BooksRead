//
//  GenresListView.swift
//  BooksRead
//
//  Created by Linas on 03/05/2025.
//

import SwiftUI
import SwiftData

struct GenresListView: View {
  
  @Environment(\.dismiss) private var dismiss
  @Environment(\.modelContext) private var modelContext
  
  @Query(sort: \GenreModel.name) private var genres: [GenreModel]
  
  @Bindable var book: BookModel
  
  @State private var isPresentedNewGenreView: Bool = false
  
  var body: some View {
    NavigationStack {
      Group {
        if genres.isEmpty {
          ContentUnavailableView {
            Image(systemName: "bookmark")
              .font(.largeTitle)
          } description: {
            Text("You need to create some genres first")
          } actions: {
            Button("Create Genre") {
              isPresentedNewGenreView.toggle()
            }
            .buttonStyle(.borderedProminent)
          }
        } else {
          List {
            ForEach(genres) { genre in
              HStack {
                if let bookGenres = book.genres {
                  if bookGenres.isEmpty {
                    Button {
                      addRemoveGenre(genre)
                    } label: {
                      Image(systemName: "circle")
                    }
                    .foregroundColor(genre.hexColor)
                  } else {
                    Button {
                      addRemoveGenre(genre)
                    } label: {
                      Image(systemName: bookGenres.contains(genre) ? "circle.fill" : "circle")
                    }
                    .foregroundColor(genre.hexColor)
                  }
                }
                Text(genre.name)
              }
            }
            .onDelete { indexSet in
              indexSet.forEach { index in
                let deleteGenre = genres[index]
                if let bookGenres = book.genres, bookGenres.contains(deleteGenre), let bookGenreIndex = genres.firstIndex(where: { $0.id == deleteGenre.id }) {
                  book.genres?.remove(at: bookGenreIndex)
                }
                modelContext.delete(deleteGenre)
              }
            }
            
            
            LabeledContent {
              Button {
                isPresentedNewGenreView.toggle()
              } label: {
                Image(systemName: "plus.circle.fill")
                  .imageScale(.large)
              }
              .buttonStyle(.borderedProminent)
            } label: {
              Text("Create new genre")
                .font(.caption)
                .foregroundStyle(Color.secondary)
            }
          }
          .listStyle(.plain)
        }
      }
      .navigationTitle(book.title)
      .navigationBarTitleDisplayMode(.inline)
      .popover(isPresented: $isPresentedNewGenreView) {
        NewGenreView()
          .presentationCompactAdaptation(.sheet)
      }
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          Button("Dismiss") {
            dismiss()
          }
        }
      }
    }
  }
  
  private func addRemoveGenre(_ genre: GenreModel) {
    if let bookGenres = book.genres {
      if bookGenres.isEmpty {
        book.genres?.append(genre)
      } else {
        if bookGenres.contains(genre), let index = bookGenres.firstIndex(where: { $0.id == genre.id }) {
          book.genres?.remove(at: index)
        } else {
          book.genres?.append(genre)
        }
      }
    }
  }
}

#Preview {
  let preview = Preview(model: BookModel.self)
  let books = BookModel.sampleBooks
  let genres = GenreModel.sampleGenres
  preview.addExamples(genres)
  preview.addExamples(books)
  books[1].genres?.append(genres[0])
  return NavigationStack {
    GenresListView(book: books[1])
      .modelContainer(preview.container)
  }
}
