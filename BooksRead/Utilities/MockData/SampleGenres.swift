//
//  SampleGenres.swift
//  BooksRead
//
//  Created by Linas on 03/05/2025.
//

import Foundation

extension GenreModel {
  static var sampleGenres: [GenreModel] {
    [
      GenreModel(name: "Fiction", color: "00FF00"),
      GenreModel(name: "Non Fiction", color: "0000FF"),
      GenreModel(name: "Romance", color: "FF0000"),
      GenreModel(name: "Science Fiction", color: "6a5acd"),
      GenreModel(name: "Fantasy", color: "FF6347"),
    ]
  }
}
