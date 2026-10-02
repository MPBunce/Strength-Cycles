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

    private func fetchLastSevenDays() async throws -> [Day] {
        let calendar = Calendar.current
        let todayStart = calendar.startOfDay(for: Date())
        guard let start = calendar.date(byAdding: .day, value: -6, to: todayStart),
              let end = calendar.date(byAdding: .day, value: 1, to: todayStart) else { return [] }

        let descriptor = HKStatisticsCollectionQueryDescriptor(
            predicate: HKSamplePredicate.quantitySample(
                type: stepType,
                predicate: HKQuery.predicateForSamples(withStart: start, end: end)
            ),
            options: .cumulativeSum,
            anchorDate: todayStart,
            intervalComponents: DateComponents(day: 1)
        )
        let collection = try await descriptor.result(for: store)

        var days: [Day] = []
        collection.enumerateStatistics(from: start, to: end) { statistics, _ in
            let steps = statistics.sumQuantity()?.doubleValue(for: .count()) ?? 0
            days.append(Day(date: statistics.startDate, steps: Int(steps)))
        }
        // Health only returns days that have samples; fill the gaps with zero.
        return (0..<7).compactMap { offset in
            guard let date = calendar.date(byAdding: .day, value: offset, to: start) else { return nil }
            return days.first { calendar.isDate($0.date, inSameDayAs: date) } ?? Day(date: date, steps: 0)
        }
    }
}
