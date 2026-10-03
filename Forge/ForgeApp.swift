//
//  ForgeApp.swift
//  Forge
//
//  Created by Matthew Bunce on 2025-05-28.
//

import SwiftUI
import SwiftData

@main
struct ForgeApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Cycles.self,
            Goal.self,
            Settings.self,
            CustomTemplate.self,
            DailyWorkItem.self,
            DailyWorkEntry.self,
            StretchEntry.self,
            RunPlan.self,
            RaceResult.self,
            CustomRunPlan.self,
            LoggedRun.self,
            Challenge.self
        ])
        #if DEBUG
        // Screenshot demo data lives in memory only, so it never touches the real store.
        let inMemory = DemoData.isEnabled
        #else
        let inMemory = false
        #endif
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: inMemory)

        do {
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            #if DEBUG
            if DemoData.isEnabled {
                MainActor.assumeIsolated { DemoData.seed(into: container.mainContext) }
            }
            #endif
            return container
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    @State private var showingSplash = true
    @AppStorage(PreferenceKeys.appearance) private var appearance = AppearanceMode.system.rawValue

    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView()
                if showingSplash {
                    SplashView()
                        .transition(.opacity)
                        .zIndex(1)
                        .onTapGesture { dismissSplash() }
                }
            }
            .preferredColorScheme(AppearanceMode(rawValue: appearance)?.colorScheme)
            .task {
                try? await Task.sleep(for: .seconds(3))
                dismissSplash()
            }
        }
        .modelContainer(sharedModelContainer)
    }

    private func dismissSplash() {
        withAnimation(.easeInOut(duration: 0.6)) { showingSplash = false }
    }
}
