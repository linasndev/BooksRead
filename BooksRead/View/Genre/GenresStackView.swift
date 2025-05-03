//
//  GenresStackView.swift
//  BooksRead
//
//  Created by Linas on 04/05/2025.
//

import SwiftUI

struct GenresStackView: View {
  
  var genres: [GenreModel]
  
  var body: some View {
    HStack {
      let sortedGenres = genres.sorted(using: KeyPathComparator(\GenreModel.name))
      ForEach(sortedGenres) { genre in
        Text(genre.name)
          .font(.caption)
          .foregroundStyle(.white)
          .padding(5)
          .background {
            RoundedRectangle(cornerRadius: 5)
              .fill(genre.hexColor)
          }
      }
    }
  }
}

#Preview {
  let preview = Preview(model: GenreModel.self)
  let genres = GenreModel.sampleGenres
  preview.addExamples(genres)
  return GenresStackView(genres: genres)
    .modelContainer(preview.container)
}
