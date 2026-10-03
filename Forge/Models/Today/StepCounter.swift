//
//  StepCounter.swift
//  Forge
//
//  Reads daily step counts from Apple Health.
//

import Foundation
import HealthKit
import Observation

@MainActor
@Observable
final class StepCounter {
    struct Day: Identifiable {
        let date: Date
        let steps: Int
        var id: Date { date }
    }

    enum State: Equatable {
        case idle
        case loading
        case loaded
        case unavailable
        case failed(String)
    }

    private(set) var state: State = .idle
    /// Oldest first, ending with today.
    private(set) var lastSevenDays: [Day] = []

    var today: Int { lastSevenDays.last?.steps ?? 0 }

    private let store = HKHealthStore()
    private let stepType = HKQuantityType(.stepCount)

    /// Asks for read access the first time (iOS only shows the prompt once), then loads the last week.
    func refresh() async {
        #if DEBUG
        if DemoData.isEnabled {
            let totals = DemoData.steps(days: 7)
            lastSevenDays = totals.keys.sorted().map { Day(date: $0, steps: totals[$0] ?? 0) }
            state = .loaded
            return
        }
        #endif
        guard HKHealthStore.isHealthDataAvailable() else {
            state = .unavailable
            return
        }
        if lastSevenDays.isEmpty { state = .loading }
        do {
            try await store.requestAuthorization(toShare: [], read: [stepType])
            lastSevenDays = try await fetchLastSevenDays()
            state = .loaded
        } catch {
            state = .failed(error.localizedDescription)
        }
    }

    /// Step totals per day (keyed by start of day) for any range, e.g. a month on the Activity grid.
    /// Returns an empty result if Health isn't available or access was declined.
    func dailySteps(from start: Date, to end: Date) async -> [Date: Int] {
        #if DEBUG
        if DemoData.isEnabled {
            let days = (Calendar.current.dateComponents([.day], from: start, to: end).day ?? 0)
            return DemoData.steps(days: max(days, 1))
        }
        #endif
        guard HKHealthStore.isHealthDataAvailable(), start < end else { return [:] }
        do {
            try await store.requestAuthorization(toShare: [], read: [stepType])
            return try await stepTotals(from: start, to: end)
        } catch {
            return [:]
        }
    }

    private func fetchLastSevenDays() async throws -> [Day] {
        let calendar = Calendar.current
        let todayStart = calendar.startOfDay(for: Date())
        guard let start = calendar.date(byAdding: .day, value: -6, to: todayStart),
              let end = calendar.date(byAdding: .day, value: 1, to: todayStart) else { return [] }

        let totals = try await stepTotals(from: start, to: end)
        // Health only returns days that have samples; fill the gaps with zero.
        return (0..<7).compactMap { offset in
            guard let date = calendar.date(byAdding: .day, value: offset, to: start) else { return nil }
            return Day(date: date, steps: totals[date] ?? 0)
        }
    }

    private func stepTotals(from start: Date, to end: Date) async throws -> [Date: Int] {
        let calendar = Calendar.current
        let descriptor = HKStatisticsCollectionQueryDescriptor(
            predicate: HKSamplePredicate.quantitySample(
                type: stepType,
                predicate: HKQuery.predicateForSamples(withStart: start, end: end)
            ),
            options: .cumulativeSum,
            anchorDate: calendar.startOfDay(for: start),
            intervalComponents: DateComponents(day: 1)
        )
        let collection = try await descriptor.result(for: store)

        var totals: [Date: Int] = [:]
        collection.enumerateStatistics(from: start, to: end) { statistics, _ in
            let steps = statistics.sumQuantity()?.doubleValue(for: .count()) ?? 0
            totals[calendar.startOfDay(for: statistics.startDate)] = Int(steps)
        }
        return totals
    }
}
