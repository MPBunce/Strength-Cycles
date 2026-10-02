//
//  ActivityView.swift
//  Forge
//
//  Week-by-week grids, one per habit, in the style of the GitHub widget:
//  a square is filled when that habit was completed that day (no heat shading).
//

import SwiftUI
import SwiftData

enum ActivityMetric: CaseIterable, Identifiable {
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
}

// MARK: - Completion records

/// Works out which days each habit was completed from the app's data.
struct ActivityRecords {
    let cycles: [Cycles]
    var runPlans: [RunPlan] = []
    var races: [RaceResult] = []
    let dailyItems: [DailyWorkItem]
    let dailyEntries: [DailyWorkEntry]
    let stretchEntries: [StretchEntry]
    let stepsByDay: [Date: Int]
    let stepGoal: Int

    private var calendar: Calendar { .current }

    func completedDays(for metric: ActivityMetric) -> Set<Date> {
        switch metric {
        case .workout:
            return Set(cycles.flatMap { $0.trainingDays.compactMap(\.completedDate) }.map(calendar.startOfDay))
        case .running:
            let planRuns = runPlans.flatMap { $0.sessions.compactMap(\.completedDate) }
            return Set((planRuns + races.map(\.date)).map(calendar.startOfDay))
        case .steps:
            return Set(stepsByDay.filter { $0.value >= stepGoal }.keys)
        case .stretching:
            return Set(stretchEntries.map { calendar.startOfDay(for: $0.day) })
        case .dailyWork:
            return dailyWorkCompletedDays
        }
    }

    private func itemsExisting(on day: Date) -> [DailyWorkItem] {
        dailyItems
            .filter { calendar.startOfDay(for: $0.createdAt) <= day }
            .sorted { $0.order < $1.order }
    }

    /// A day counts when every daily-work item that existed that day hit its target.
    private var dailyWorkCompletedDays: Set<Date> {
        let byDay = Dictionary(grouping: dailyEntries) { calendar.startOfDay(for: $0.day) }
        var done = Set<Date>()
        for (day, entries) in byDay {
            let items = itemsExisting(on: day)
            guard !items.isEmpty else { continue }
            let allHit = items.allSatisfy { item in
                (entries.first { $0.itemID == item.id }?.reps ?? 0) >= item.dailyTarget
            }
            if allHit { done.insert(day) }
        }
        return done
    }
}

/// Week columns of 7 days, oldest first, ending with the current week.
private func weekColumns(count: Int, endingWeeksAgo offset: Int = 0) -> [[Date]] {
    let calendar = Calendar.current
    guard let thisWeek = calendar.dateInterval(of: .weekOfYear, for: Date())?.start,
          let lastWeek = calendar.date(byAdding: .weekOfYear, value: -offset, to: thisWeek),
          let firstWeek = calendar.date(byAdding: .weekOfYear, value: -(count - 1), to: lastWeek) else { return [] }
    return (0..<count).compactMap { week in
        guard let weekStart = calendar.date(byAdding: .weekOfYear, value: week, to: firstWeek) else { return nil }
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: weekStart) }
    }
}

// MARK: - Activity overview

struct ActivityView: View {
    @Query private var cycles: [Cycles]
    @Query private var runPlans: [RunPlan]
    @Query private var races: [RaceResult]
    @Query private var dailyItems: [DailyWorkItem]
    @Query private var dailyEntries: [DailyWorkEntry]
    @Query private var stretchEntries: [StretchEntry]
    @Query private var settings: [Settings]

    /// How many weeks each grid shows, like GitHub's medium widget.
    static let weekCount = 16

    @State private var stepsByDay: [Date: Int] = [:]
    @State private var stepCounter = StepCounter()

    private var stepGoal: Int { settings.first?.dailyStepGoal ?? 10000 }

    private var records: ActivityRecords {
        ActivityRecords(cycles: cycles, runPlans: runPlans, races: races, dailyItems: dailyItems, dailyEntries: dailyEntries,
                        stretchEntries: stretchEntries, stepsByDay: stepsByDay, stepGoal: stepGoal)
    }

    var body: some View {
        let weeks = weekColumns(count: Self.weekCount)
        let records = records
        ScrollView {
            VStack(spacing: 16) {
                ForEach(ActivityMetric.allCases) { metric in
                    NavigationLink {
                        ActivityHistoryView(metric: metric)
                    } label: {
                        WeekGridCard(metric: metric, weeks: weeks, completedDays: records.completedDays(for: metric))
                    }
                    .buttonStyle(.plain)
                }

                Text("Tap a card to see its full history. Step Goal uses your current goal of \(stepGoal.formatted()) steps.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .task {
            let calendar = Calendar.current
            guard let start = weeks.first?.first,
                  let end = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: Date())) else { return }
            stepsByDay = await stepCounter.dailySteps(from: start, to: end)
        }
    }
}

// MARK: - Full history for one habit

struct ActivityHistoryView: View {
    let metric: ActivityMetric

    @Query private var cycles: [Cycles]
    @Query private var runPlans: [RunPlan]
    @Query private var races: [RaceResult]
    @Query private var dailyItems: [DailyWorkItem]
    @Query private var dailyEntries: [DailyWorkEntry]
    @Query private var stretchEntries: [StretchEntry]
    @Query private var settings: [Settings]

    @State private var stepsByDay: [Date: Int] = [:]
    @State private var stepCounter = StepCounter()

    /// Steps come from Apple Health rather than the app, so their history is capped at a year.
    private static let stepHistoryWeeks = 52

    private let calendar = Calendar.current

    var body: some View {
        let records = ActivityRecords(cycles: cycles, runPlans: runPlans, races: races, dailyItems: dailyItems, dailyEntries: dailyEntries,
                                      stretchEntries: stretchEntries, stepsByDay: stepsByDay,
                                      stepGoal: settings.first?.dailyStepGoal ?? 10000)
        let completed = records.completedDays(for: metric)
        let days = completed.sorted(by: >)
        let current = currentStreak(completed)
        let longest = longestStreak(days)
        let thisYear = count(completed, in: .year)

        List {
            Section {
                HStack {
                    stat(metric == .running ? "Run days" : "Total", value: completed.count)
                    Divider()
                    if metric.badgesUseDistance {
                        stat("km this year", value: Int(runKilometres(in: .year)))
                        Divider()
                        stat("km this month", value: Int(runKilometres(in: .month)))
                    } else if metric.usesYearlyCount {
                        stat("This year", value: thisYear)
                        Divider()
                        stat("This month", value: count(completed, in: .month))
                    } else {
                        stat("Current streak", value: current)
                        Divider()
                        stat("Longest streak", value: longest)
                    }
                }
                .padding(.vertical, 4)
            }

            if metric == .steps {
                StepsInsightsSection(stepsByDay: stepsByDay, goal: settings.first?.dailyStepGoal ?? 10000)
            }

            let badgeProgress = metric.badgesUseDistance ? Int(runKilometres(in: .year))
                : metric.usesYearlyCount ? thisYear : current
            StreakBadgesSection(metric: metric,
                                progress: badgeProgress,
                                best: metric.usesYearlyCount ? badgeProgress : longest)

            Section("History") {
                ForEach(historyChunks(earliest: days.last), id: \.self) { offset in
                    WeekGrid(metric: metric,
                             weeks: weekColumns(count: ActivityView.weekCount, endingWeeksAgo: offset),
                             completedDays: completed)
                        .padding(.vertical, 6)
                }
            }
        }
        .navigationTitle(metric.title)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            guard metric == .steps,
                  let start = weekColumns(count: Self.stepHistoryWeeks).first?.first,
                  let end = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: Date())) else { return }
            stepsByDay = await stepCounter.dailySteps(from: start, to: end)
        }
    }

    private func stat(_ title: String, value: Int) -> some View {
        VStack(spacing: 2) {
            Text("\(value)")
                .font(.title2.weight(.bold).monospacedDigit())
                .foregroundStyle(metric.color)
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .combine)
    }

    /// Week offsets for each 16-week block, newest first, going back to the first entry.
    private func historyChunks(earliest: Date?) -> [Int] {
        guard let earliest,
              let thisWeek = calendar.dateInterval(of: .weekOfYear, for: Date())?.start,
              let firstWeek = calendar.dateInterval(of: .weekOfYear, for: earliest)?.start else { return [0] }
        let weeks = (calendar.dateComponents([.weekOfYear], from: firstWeek, to: thisWeek).weekOfYear ?? 0) + 1
        let blocks = max(1, Int((Double(weeks) / Double(ActivityView.weekCount)).rounded(.up)))
        return (0..<blocks).map { $0 * ActivityView.weekCount }
    }

    /// Kilometres from runs completed in the current calendar year or month.
    private func runKilometres(in component: Calendar.Component) -> Double {
        let inPeriod: (Date) -> Bool = { calendar.isDate($0, equalTo: Date(), toGranularity: component) }
        let planKm = runPlans.flatMap(\.sessions)
            .filter { $0.completedDate.map(inPeriod) ?? false }
            .reduce(0) { $0 + $1.coveredKilometres }
        let raceKm = races.filter { inPeriod($0.date) }.reduce(0) { $0 + $1.distance.kilometres }
        return planKm + raceKm
    }

    /// Completed days in the current calendar year or month.
    private func count(_ completed: Set<Date>, in component: Calendar.Component) -> Int {
        completed.filter { calendar.isDate($0, equalTo: Date(), toGranularity: component) }.count
    }

    /// Days in a row up to today (or yesterday, so an unfinished today doesn't break it).
    private func currentStreak(_ completed: Set<Date>) -> Int {
        var day = calendar.startOfDay(for: Date())
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

    private func longestStreak(_ daysNewestFirst: [Date]) -> Int {
        var longest = 0, run = 0
        var previous: Date?
        for day in daysNewestFirst.reversed() {
            if let previous, calendar.date(byAdding: .day, value: 1, to: previous) == day {
                run += 1
            } else {
                run = 1
            }
            longest = max(longest, run)
            previous = day
        }
        return longest
    }
}

// MARK: - Grids

/// Card on the overview: header plus the last 16 weeks.
private struct WeekGridCard: View {
    let metric: ActivityMetric
    let weeks: [[Date]]
    let completedDays: Set<Date>

    private var pastDays: [Date] {
        weeks.flatMap { $0 }.filter { $0 <= Date() }
    }

    private var completedCount: Int {
        pastDays.filter { completedDays.contains($0) }.count
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: metric.icon)
                    .foregroundStyle(metric.color)
                Text(metric.title)
                    .font(.subheadline.weight(.semibold))
                Spacer()
                Text(completedCount == 1 ? "1 day" : "\(completedCount) days")
                    .font(.subheadline.monospacedDigit())
                    .foregroundStyle(.secondary)
                Image(systemName: "chevron.right")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.tertiary)
            }
            WeekGrid(metric: metric, weeks: weeks, completedDays: completedDays)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(.secondarySystemGroupedBackground))
        )
        .contentShape(Rectangle())
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(metric.title): completed on \(completedCount) of the last \(pastDays.count) days")
        .accessibilityHint("Shows full history")
    }
}

/// GitHub-style grid: one column per week (oldest on the left), one row per weekday.
private struct WeekGrid: View {
    let metric: ActivityMetric
    let weeks: [[Date]]
    let completedDays: Set<Date>

    private let calendar = Calendar.current
    private let spacing: CGFloat = 3

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Month labels above the first week of each month.
            HStack(spacing: spacing) {
                ForEach(Array(weeks.enumerated()), id: \.offset) { index, week in
                    Text(monthLabel(for: week, at: index))
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .fixedSize()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }

            HStack(spacing: spacing) {
                ForEach(Array(weeks.enumerated()), id: \.offset) { _, week in
                    VStack(spacing: spacing) {
                        ForEach(week, id: \.self) { date in
                            cell(for: date)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }

    private func monthLabel(for week: [Date], at index: Int) -> String {
        guard let first = week.first else { return "" }
        if let firstOfMonth = week.first(where: { calendar.component(.day, from: $0) == 1 }) {
            return firstOfMonth.formatted(.dateTime.month(.abbreviated))
        }
        // Label the first column too, unless a new month starts right after it (avoids overlap).
        if index == 0, weeks.count > 1, !weeks[1].contains(where: { calendar.component(.day, from: $0) == 1 }) {
            return first.formatted(.dateTime.month(.abbreviated))
        }
        return ""
    }

    private func cell(for date: Date) -> some View {
        let shape = RoundedRectangle(cornerRadius: 4, style: .continuous)
        let isFuture = date > Date()
        return shape
            .fill(completedDays.contains(date)
                  ? metric.color
                  : Color(.tertiarySystemFill).opacity(isFuture ? 0.35 : 1))
            .overlay {
                if calendar.isDateInToday(date) {
                    shape.strokeBorder(Color.primary.opacity(0.6), lineWidth: 1.5)
                }
            }
            .aspectRatio(1, contentMode: .fit)
    }
}

#Preview {
    NavigationStack {
        ActivityView()
    }
    .modelContainer(for: [Cycles.self, DailyWorkItem.self, DailyWorkEntry.self, StretchEntry.self, Settings.self], inMemory: true)
}
