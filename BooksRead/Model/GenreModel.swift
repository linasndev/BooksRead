//
//  GenreModel.swift
//  BooksRead
//
//  Created by Linas on 03/05/2025.
//

import SwiftUI
import SwiftData

@Model
class GenreModel {
  var name: String = ""
  var color: String = "FFFFFF"
  var books: [BookModel]?
  
  init(name: String, color: String) {
    self.name = name
    self.color = color
  }
  
  var hexColor: Color {
    Color(hex: self.color) ?? .blue
  }
}
