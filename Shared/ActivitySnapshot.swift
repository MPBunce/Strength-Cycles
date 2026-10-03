//
//  ActivitySnapshot.swift
//  Shared between Forge and its widgets.
//
//  The app saves which days each habit was done into the shared App Group;
//  the streak widgets read it back. Widgets can't open the app's database or
//  Apple Health directly, so this summary is all they see.
//

import SwiftUI

enum AppGroup {
    static let identifier = "group.mpbunce.Strength-Cycles"
    static var defaults: UserDefaults { UserDefaults(suiteName: identifier) ?? .standard }
}

enum ActivityMetric: String, CaseIterable, Identifiable, Codable {
    case workout, running, steps, dailyWork, stretching

    var id: Self { self }

    var title: String {
        switch self {
        case .workout: return "Worked Out"
        case .running: return "Ran"
        case .steps: return "Step Goal"
        case .dailyWork: return "Daily Work"
        case .stretching: return "Stretching"
        }
    }

    var icon: String {
        switch self {
        case .workout: return "dumbbell.fill"
        case .running: return "figure.run"
        case .steps: return "figure.walk"
        case .dailyWork: return "checklist"
        case .stretching: return "figure.flexibility"
        }
    }

    var color: Color {
        switch self {
        case .workout: return .orange
        case .running: return .red
        case .steps: return .green
        case .dailyWork: return .blue
        case .stretching: return .purple
        }
    }

    /// Workouts, runs and steps are counted per year; daily habits are about unbroken streaks.
    var usesYearlyCount: Bool {
        self == .workout || self == .running || self == .steps
    }

    /// Link the widgets open: the habit's history on the Progress tab.
    var url: URL { URL(string: "forge://activity/\(rawValue)")! }

    init?(url: URL) {
        guard url.scheme == "forge", url.host == "activity",
              let metric = ActivityMetric(rawValue: url.lastPathComponent) else { return nil }
        self = metric
    }
}

/// Completed days per habit (start of day), covering a little over the last year.
struct ActivitySnapshot: Codable, Equatable {
    static let historyDays = 400
    private static let key = "activitySnapshot"

    var days: [ActivityMetric: [Date]] = [:]

    func completedDays(for metric: ActivityMetric) -> Set<Date> {
        Set(days[metric] ?? [])
    }

    static func load() -> ActivitySnapshot? {
        guard let data = AppGroup.defaults.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(ActivitySnapshot.self, from: data)
    }

    /// Saves the snapshot; returns false when nothing changed.
    @discardableResult
    func save() -> Bool {
        guard self != ActivitySnapshot.load(), let data = try? JSONEncoder().encode(self) else { return false }
        AppGroup.defaults.set(data, forKey: Self.key)
        return true
    }
}

enum ActivityStats {
    /// Days in a row up to today (or yesterday, so an unfinished today doesn't break it).
    static func currentStreak(_ completed: Set<Date>, calendar: Calendar = .current, now: Date = Date()) -> Int {
        var day = calendar.startOfDay(for: now)
        if !completed.contains(day) {
            day = calendar.date(byAdding: .day, value: -1, to: day) ?? day
        }
        var streak = 0
        while completed.contains(day) {
            streak += 1
            guard let previous = calendar.date(byAdding: .day, value: -1, to: day) else { break }
            day = previous
        }
        return streak
    }

    /// Completed days in the current calendar year.
    static func thisYear(_ completed: Set<Date>, calendar: Calendar = .current, now: Date = Date()) -> Int {
        completed.filter { calendar.isDate($0, equalTo: now, toGranularity: .year) }.count
    }
}
