//
//  WidgetSync.swift
//  Forge
//
//  Keeps the streak widgets up to date: saves each habit's completed days to the
//  App Group when the app opens and when it goes to the background.
//

import SwiftUI
import SwiftData
import WidgetKit

private struct WidgetSyncModifier: ViewModifier {
    @Environment(\.scenePhase) private var scenePhase
    @AppStorage(PreferenceKeys.hasSeenSplash) private var hasSeenSplash = false

    @Query private var cycles: [Cycles]
    @Query private var runPlans: [RunPlan]
    @Query private var races: [RaceResult]
    @Query private var singleRuns: [LoggedRun]
    @Query private var dailyItems: [DailyWorkItem]
    @Query private var dailyEntries: [DailyWorkEntry]
    @Query private var stretchEntries: [StretchEntry]
    @Query private var settings: [Settings]

    @State private var stepsByDay: [Date: Int] = [:]
    @State private var stepCounter = StepCounter()

    func body(content: Content) -> some View {
        content
            // Steps need Health access, so wait until the first-launch quote has gone.
            .task(id: hasSeenSplash) {
                guard hasSeenSplash else { return }
                await loadSteps()
                save()
            }
            .onChange(of: scenePhase) { _, phase in
                switch phase {
                case .background, .inactive:
                    save()
                case .active:
                    guard hasSeenSplash else { return }
                    Task {
                        await loadSteps()
                        save()
                    }
                @unknown default:
                    break
                }
            }
    }

    private func loadSteps() async {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        guard let start = calendar.date(byAdding: .day, value: -ActivitySnapshot.historyDays, to: today),
              let end = calendar.date(byAdding: .day, value: 1, to: today) else { return }
        stepsByDay = await stepCounter.dailySteps(from: start, to: end)
    }

    private func save() {
        let records = ActivityRecords(cycles: cycles, runPlans: runPlans, races: races, singleRuns: singleRuns,
                                      dailyItems: dailyItems, dailyEntries: dailyEntries,
                                      stretchEntries: stretchEntries, stepsByDay: stepsByDay,
                                      stepGoal: settings.first?.dailyStepGoal ?? 10000)
        let cutoff = Calendar.current.date(byAdding: .day, value: -ActivitySnapshot.historyDays, to: Date()) ?? .distantPast
        var snapshot = ActivitySnapshot()
        for metric in ActivityMetric.allCases {
            snapshot.days[metric] = records.completedDays(for: metric).filter { $0 >= cutoff }.sorted()
        }
        if snapshot.save() {
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
}

extension View {
    /// Saves habit history for the streak widgets.
    func syncsActivityWidgets() -> some View {
        modifier(WidgetSyncModifier())
    }
}
