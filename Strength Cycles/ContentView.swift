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
    @State private var selectedTab = 1

    var body: some View {
        TabView(selection: $selectedTab) {
            ProgressView()
                .tabItem({
                    Text("Progress")
                    Image(systemName: "chart.bar")
                })
                .tag(0)
            CyclesView()
                .tabItem({
                    Text("Cycles")
                    Image(systemName: "arrow.2.circlepath")
                })
                .tag(1)
            SettingsView()
                .tabItem({
                    Text("Settings")
                    Image(systemName: "gear")
                })
                .tag(2)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Cycles.self, inMemory: true)
}
