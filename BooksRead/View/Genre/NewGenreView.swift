//
//  NewGenreView.swift
//  BooksRead
//
//  Created by Linas on 03/05/2025.
//

import SwiftUI
import SwiftData

struct NewGenreView: View {
  
  @Environment(\.dismiss) private var dismiss
  @Environment(\.modelContext) private var modelContext
  
  @State private var name: String = ""
  @State private var color: Color = Color.blue
  
  var body: some View {
    NavigationStack {
      Form {
        TextField("Name", text: $name)
        
        ColorPicker("Set the genre color", selection: $color, supportsOpacity: false)
        
        Button("Create") {
          let newGenre = GenreModel(name: name, color: color.toHexString() ?? "")
          modelContext.insert(newGenre)
          dismiss()
        }
        .buttonStyle(.borderedProminent)
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding()
        .disabled(name.isEmpty)
      }
      .navigationTitle("New Genre")
      .navigationBarTitleDisplayMode(.inline)
    }
  }
}

#Preview {
  let preview = Preview(model: BookModel.self)
  NewGenreView()
    .modelContainer(preview.container)
}
