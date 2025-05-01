//
//  SampleBooks.swift
//  BooksRead
//
//  Created by Linas on 01/05/2025.
//

import Foundation

extension BookModel {
  static let lastWeek = Calendar.current.date(byAdding: .day, value: -7, to: Date.now)
  static let lastMonth = Calendar.current.date(byAdding: .month, value: -1, to: Date.now)
  
  static var sampleBooks: [BookModel] {
    [
      
      BookModel(
        title: "The Midnight Library",
        author: "Matt Haig",
        dateAdded: Calendar.current.date(byAdding: .day, value: -90, to: Date.now)!,
        dateStarted: Calendar.current.date(byAdding: .day, value: -60, to: Date.now)!,
        dateCompleted: Calendar.current.date(byAdding: .day, value: -45, to: Date.now)!,
        summary: "A novel about regret, possibility, and making choices. Protagonist Nora Seed finds herself in a library between life and death with infinite books containing different versions of her life.",
        rating: 4,
        status: .completed
      ),

      
      BookModel(
        title: "Project Hail Mary",
        author: "Andy Weir",
        dateAdded: Calendar.current.date(byAdding: .day, value: -120, to: Date.now)!,
        dateStarted: Calendar.current.date(byAdding: .day, value: -30, to: Date.now)!,
        summary: "A lone astronaut must save Earth from an extinction-level threat with nothing but his ingenuity and remnants of his memory.",
        status: .inProgress
      ),

      
      BookModel(
        title: "Tomorrow, and Tomorrow, and Tomorrow",
        author: "Gabrielle Zevin",
        dateAdded: Calendar.current.date(byAdding: .day, value: -15, to: Date.now)!,
        summary: "A novel spanning thirty years, following two friends who collaborate on video game design while navigating their complex relationship.",
        status: .onShelf
      ),

      
     BookModel(
        title: "Klara and the Sun",
        author: "Kazuo Ishiguro",
        dateAdded: Calendar.current.date(byAdding: .day, value: -200, to: Date.now)!,
        dateStarted: Calendar.current.date(byAdding: .day, value: -180, to: Date.now)!,
        dateCompleted: Calendar.current.date(byAdding: .day, value: -150, to: Date.now)!,
        summary: "Told from the perspective of an Artificial Friend named Klara, this novel explores what it means to love in a technologically advanced world that's becoming increasingly dehumanized.",
        rating: 5,
        status: .completed
      ),
      
      BookModel(
        title: "Sea of Tranquility",
        author: "Emily St. John Mandel",
        dateAdded: Calendar.current.date(byAdding: .day, value: -45, to: Date.now)!,
        dateStarted: Calendar.current.date(byAdding: .day, value: -40, to: Date.now)!,
        summary: "A novel that weaves together characters and stories across time and space, from Vancouver Island in 1912 to a moon colony 500 years later.",
        status: .inProgress
      ),
      
      BookModel(
        title: "The Three-Body Problem",
        author: "Liu Cixin",
        dateAdded: Calendar.current.date(byAdding: .day, value: -10, to: Date.now)!,
        summary: "Set against the backdrop of China's Cultural Revolution, this sci-fi novel explores humanity's first contact with an alien civilization that's on the brink of destruction.",
        status: .onShelf
      ),
      
    ]
  }
}
