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

    var body: some View {
        TabView {
            ProgressView()
                .tabItem({
                    Text("Progress")
                    Image(systemName: "chart.bar")
                })
            CyclesView()
                .tabItem({
                    Text("Cycles")
                    Image(systemName: "arrow.2.circlepath")
                })
            SettingsView()
                .tabItem({
                    Text("Settings")
                    Image(systemName: "gear")
                })
        }
    }

}

#Preview {
    ContentView()
        .modelContainer(for: Cycles.self, inMemory: true)
}
