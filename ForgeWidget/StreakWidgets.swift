//
//  StreakWidgets.swift
//  ForgeWidget
//
//  One medium widget per habit: the GitHub-style grid from the Progress tab,
//  with the current streak or this year's count.
//

import SwiftUI
import WidgetKit

struct StreakEntry: TimelineEntry {
    let date: Date
    let completedDays: Set<Date>
}

struct StreakProvider: TimelineProvider {
    let metric: ActivityMetric

    func placeholder(in context: Context) -> StreakEntry {
        StreakEntry(date: Date(), completedDays: Self.sampleDays)
    }

    func getSnapshot(in context: Context, completion: @escaping (StreakEntry) -> Void) {
        let days = ActivitySnapshot.load()?.completedDays(for: metric) ?? []
        // The widget gallery shows sample days until the app has saved real ones.
        completion(StreakEntry(date: Date(), completedDays: context.isPreview && days.isEmpty ? Self.sampleDays : days))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<StreakEntry>) -> Void) {
        let entry = StreakEntry(date: Date(), completedDays: ActivitySnapshot.load()?.completedDays(for: metric) ?? [])
        // Redraw just after midnight so "today" moves along.
        let calendar = Calendar.current
        let midnight = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: Date())) ?? Date().addingTimeInterval(3600)
        completion(Timeline(entries: [entry], policy: .after(midnight.addingTimeInterval(60))))
    }

    private static var sampleDays: Set<Date> {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        return Set((0..<140).filter { $0 % 7 != 3 && $0 % 11 != 5 }.compactMap {
            calendar.date(byAdding: .day, value: -$0, to: today)
        })
    }
}

struct StreakWidgetView: View {
    let metric: ActivityMetric
    let entry: StreakEntry

    private var summary: String {
        if metric.usesYearlyCount {
            return "\(ActivityStats.thisYear(entry.completedDays, now: entry.date)) this year"
        }
        let streak = ActivityStats.currentStreak(entry.completedDays, now: entry.date)
        return streak == 1 ? "1 day streak" : "\(streak) day streak"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: metric.icon)
                    .foregroundStyle(metric.color)
                Text(metric.title)
                    .font(.subheadline.weight(.semibold))
                Spacer()
                Text(summary)
                    .font(.subheadline.monospacedDigit())
                    .foregroundStyle(.secondary)
            }
            // Same header height for every habit, so the grids line up.
            .frame(height: 20)
            StreakGrid(metric: metric, completedDays: entry.completedDays, today: entry.date)
        }
        .containerBackground(for: .widget) {
            Color(.secondarySystemGroupedBackground)
        }
        .widgetURL(metric.url)
    }
}

/// As many whole weeks as fit, oldest on the left, one row per weekday.
private struct StreakGrid: View {
    let metric: ActivityMetric
    let completedDays: Set<Date>
    let today: Date

    private let spacing: CGFloat = 3
    private let calendar = Calendar.current

    var body: some View {
        GeometryReader { proxy in
            let cell = (proxy.size.height - spacing * 6) / 7
            let weekCount = max(1, Int((proxy.size.width + spacing) / (cell + spacing)))
            let weeks = weekColumns(count: weekCount)
            HStack(spacing: spacing) {
                ForEach(Array(weeks.enumerated()), id: \.offset) { _, week in
                    VStack(spacing: spacing) {
                        ForEach(week, id: \.self) { day in
                            square(for: day)
                                .frame(width: cell, height: cell)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }

    private func square(for day: Date) -> some View {
        let shape = RoundedRectangle(cornerRadius: 3, style: .continuous)
        let isFuture = day > today
        return shape
            .fill(completedDays.contains(day)
                  ? metric.color
                  : Color(.tertiarySystemFill).opacity(isFuture ? 0.35 : 1))
            .overlay {
                if calendar.isDate(day, inSameDayAs: today) {
                    shape.strokeBorder(Color.primary.opacity(0.6), lineWidth: 1.2)
                }
            }
    }

    /// Week columns of 7 days, oldest first, ending with the current week.
    private func weekColumns(count: Int) -> [[Date]] {
        guard let thisWeek = calendar.dateInterval(of: .weekOfYear, for: today)?.start,
              let firstWeek = calendar.date(byAdding: .weekOfYear, value: -(count - 1), to: thisWeek) else { return [] }
        return (0..<count).compactMap { week in
            guard let weekStart = calendar.date(byAdding: .weekOfYear, value: week, to: firstWeek) else { return nil }
            return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: weekStart) }
        }
    }
}

private func streakConfiguration(_ metric: ActivityMetric, kind: String) -> some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: StreakProvider(metric: metric)) { entry in
        StreakWidgetView(metric: metric, entry: entry)
    }
    .configurationDisplayName(metric.title)
    .description(metric.usesYearlyCount
                 ? "Days you \(metric.widgetVerb), with this year's total."
                 : "Days you \(metric.widgetVerb), with your current streak.")
    .supportedFamilies([.systemMedium])
}

private extension ActivityMetric {
    var widgetVerb: String {
        switch self {
        case .workout: return "worked out"
        case .running: return "ran"
        case .steps: return "hit your step goal"
        case .dailyWork: return "finished your daily work"
        case .stretching: return "stretched"
        }
    }
}

struct WorkoutStreakWidget: Widget {
    var body: some WidgetConfiguration { streakConfiguration(.workout, kind: "WorkoutStreak") }
}

struct RunningStreakWidget: Widget {
    var body: some WidgetConfiguration { streakConfiguration(.running, kind: "RunningStreak") }
}

struct StepsStreakWidget: Widget {
    var body: some WidgetConfiguration { streakConfiguration(.steps, kind: "StepsStreak") }
}

struct DailyWorkStreakWidget: Widget {
    var body: some WidgetConfiguration { streakConfiguration(.dailyWork, kind: "DailyWorkStreak") }
}

struct StretchingStreakWidget: Widget {
    var body: some WidgetConfiguration { streakConfiguration(.stretching, kind: "StretchingStreak") }
}

#Preview(as: .systemMedium) {
    StretchingStreakWidget()
} timeline: {
    StreakEntry(date: Date(), completedDays: [])
}
