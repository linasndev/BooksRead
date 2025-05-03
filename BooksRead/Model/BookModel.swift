//
//  BookModel.swift
//  BooksRead
//
//  Created by Linas on 29/04/2025.
//

import SwiftUI
import SwiftData

@Model
class BookModel {
  var title: String
  var author: String
  var dateAdded: Date
  var dateStarted: Date
  var dateCompleted: Date
  @Attribute(originalName: "summary") var synopsis: String //Light Weight migration
  var rating: Int?
  var status: Status.RawValue
  var recommendedBy: String = ""
  
  //One To Many Relationship - One Book can have many Quote's - Explicit
  @Relationship(deleteRule: .cascade, inverse: \QuoteModel.book) var quotes: [QuoteModel]?
  
  
  
  init(
    title: String,
    author: String,
    dateAdded: Date = Date.now,
    dateStarted: Date = Date.distantPast,
    dateCompleted: Date = Date.distantPast,
    summary: String = "",
    rating: Int? = nil,
    status: Status = .onShelf,
    recommendedBy: String = ""
  ) {
    self.title = title
    self.author = author
    self.dateAdded = dateAdded
    self.dateStarted = dateStarted
    self.dateCompleted = dateCompleted
    self.synopsis = summary
    self.rating = rating
    self.status = status.rawValue
    self.recommendedBy = recommendedBy
  }
  
  var icon: Image {
    switch Status(rawValue: status) {
    case .onShelf:
      Image(systemName: "books.vertical")
    case .inProgress:
      Image(systemName: "book")
    case .completed:
      Image(systemName: "book.closed")
    case .none:
      Image(systemName: "questionmark")
    }
  }
}

enum Status: Int, Codable, Identifiable, CaseIterable {
  case onShelf, inProgress, completed
  
  var id: Self {
    return self
  }
  
  var title: String {
    switch self {
    case .onShelf:
      "On Shelf"
    case .inProgress:
      "In Progress"
    case .completed:
      "Completed"
    }
  }
}

//MOCK DATA
//extension BookModel {
//  
//  @MainActor
//  static var preview: ModelContainer {
//    let container = try! ModelContainer(for: BookModel.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
//    
//    let midnightBook = BookModel(
//      title: "The Midnight Library",
//      author: "Matt Haig",
//      dateAdded: Calendar.current.date(byAdding: .day, value: -90, to: Date.now)!,
//      dateStarted: Calendar.current.date(byAdding: .day, value: -60, to: Date.now)!,
//      dateCompleted: Calendar.current.date(byAdding: .day, value: -45, to: Date.now)!,
//      synopsis: "A novel about regret, possibility, and making choices. Protagonist Nora Seed finds herself in a library between life and death with infinite books containing different versions of her life.",
//      rating: 4,
//      status: .completed
//    )
//    container.mainContext.insert(midnightBook)
//    
//    let projectHailBook = BookModel(
//      title: "Project Hail Mary",
//      author: "Andy Weir",
//      dateAdded: Calendar.current.date(byAdding: .day, value: -120, to: Date.now)!,
//      dateStarted: Calendar.current.date(byAdding: .day, value: -30, to: Date.now)!,
//      synopsis: "A lone astronaut must save Earth from an extinction-level threat with nothing but his ingenuity and remnants of his memory.",
//      status: .inProgress
//    )
//    container.mainContext.insert(projectHailBook)
//    
//    let tomorrowBook = BookModel(
//      title: "Tomorrow, and Tomorrow, and Tomorrow",
//      author: "Gabrielle Zevin",
//      dateAdded: Calendar.current.date(byAdding: .day, value: -15, to: Date.now)!,
//      synopsis: "A novel spanning thirty years, following two friends who collaborate on video game design while navigating their complex relationship.",
//      status: .onShelf
//    )
//    container.mainContext.insert(tomorrowBook)
//    
//    let klaraBook = BookModel(
//      title: "Klara and the Sun",
//      author: "Kazuo Ishiguro",
//      dateAdded: Calendar.current.date(byAdding: .day, value: -200, to: Date.now)!,
//      dateStarted: Calendar.current.date(byAdding: .day, value: -180, to: Date.now)!,
//      dateCompleted: Calendar.current.date(byAdding: .day, value: -150, to: Date.now)!,
//      synopsis: "Told from the perspective of an Artificial Friend named Klara, this novel explores what it means to love in a technologically advanced world that's becoming increasingly dehumanized.",
//      rating: 5,
//      status: .completed
//    )
//    container.mainContext.insert(klaraBook)
//    
//    let seaBook = BookModel(
//      title: "Sea of Tranquility",
//      author: "Emily St. John Mandel",
//      dateAdded: Calendar.current.date(byAdding: .day, value: -45, to: Date.now)!,
//      dateStarted: Calendar.current.date(byAdding: .day, value: -40, to: Date.now)!,
//      synopsis: "A novel that weaves together characters and stories across time and space, from Vancouver Island in 1912 to a moon colony 500 years later.",
//      status: .inProgress
//    )
//    container.mainContext.insert(seaBook)
//    
//    let threeBodyBook = BookModel(
//      title: "The Three-Body Problem",
//      author: "Liu Cixin",
//      dateAdded: Calendar.current.date(byAdding: .day, value: -10, to: Date.now)!,
//      synopsis: "Set against the backdrop of China's Cultural Revolution, this sci-fi novel explores humanity's first contact with an alien civilization that's on the brink of destruction.",
//      status: .onShelf
//    )
//    container.mainContext.insert(threeBodyBook)
//    
//    return container
//  }
//}
