//
//  BooksReadApp.swift
//  BooksRead
//
//  Created by Linas on 29/04/2025.
//

import SwiftUI
import SwiftData

@main
struct BooksReadApp: App {
  
  let container: ModelContainer
  
  init() {
    let schema = Schema([BookModel.self])
    let config = ModelConfiguration("My Books", schema: schema)
    
    do {
      container = try ModelContainer(for: schema, configurations: config)
    } catch {
      fatalError("Could not configure the container")
    }
    
    print(URL.applicationSupportDirectory.path(percentEncoded: false))
  }
  
  var body: some Scene {
    WindowGroup {
      BooksListView()
        .modelContainer(for: BookModel.self)
    }
  }
}
