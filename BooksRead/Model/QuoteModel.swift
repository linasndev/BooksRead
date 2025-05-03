//
//  Quote.swift
//  BooksRead
//
//  Created by Linas on 03/05/2025.
//

import Foundation
import SwiftData

@Model
class QuoteModel {
  var creationDate: Date = Date.now
  var text: String
  var page: String?
  var book: BookModel? //It's associated with just ONE BookModel.
  
  init(text: String, page: String? = nil) {
    self.text = text
    self.page = page
  }
}
