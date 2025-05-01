//
//  PreviewContainer.swift
//  BooksRead
//
//  Created by Linas on 01/05/2025.
//

import Foundation
import SwiftData

struct Preview {
  let container: ModelContainer
  
  init(model: any PersistentModel.Type...) {
    
    let schema = Schema(model)
    
    do {
      container = try ModelContainer(for: schema, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    } catch {
      fatalError("Could not configure the container for Preview")
    }
  }
  
  func addExamples(_ expamples: [any PersistentModel]) {
    Task { @MainActor in
      expamples.forEach { example in
        container.mainContext.insert(example)
      }
    }
  }
}
