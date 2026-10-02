//
//  TodayView.swift
//  Forge
//
//  Home screen for the day: step count, daily bodyweight work and challenges.
//

import SwiftUI
import SwiftData

struct TodayView: View {
    @Environment(\.scenePhase) private var scenePhase
    @State private var steps = StepCounter()
    /// Start of the current day; refreshed when the app comes back so logs roll over at midnight.
    @State private var today = Calendar.current.startOfDay(for: Date())

    var body: some View {
        NavigationStack {
            List {
                Text(today, format: .dateTime.weekday(.wide).month(.wide).day())
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 0))
                StepsSection(steps: steps)
                DailyWorkSection(day: today)
                StretchingSection(day: today)
                ChallengesSection()
            }
            .navigationTitle("Today")
            .refreshable { await steps.refresh() }
            .task { await steps.refresh() }
            .onChange(of: scenePhase) { _, phase in
                guard phase == .active else { return }
                today = Calendar.current.startOfDay(for: Date())
                Task { await steps.refresh() }
            }
        }
    }
}

#Preview {
    TodayView()
        .modelContainer(for: [Settings.self, DailyWorkItem.self, DailyWorkEntry.self, StretchEntry.self, Challenge.self], inMemory: true)
}
