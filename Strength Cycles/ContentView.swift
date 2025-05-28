//
//  ContentView.swift
//  Strength Cycles
//
//  Created by Matthew Bunce on 2025-05-28.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    var body: some View {
        TabView {
            Progress()
                .tabItem({
                    Text("Progress")
                    Image(systemName: "chart.bar")
                })
            Cycles()
                .tabItem({
                    Text("Cycles")
                    Image(systemName: "arrow.2.circlepath")
                })
            Settings()
                .tabItem({
                    Text("Settings")
                    Image(systemName: "gear")
                })
        }
    }

}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
