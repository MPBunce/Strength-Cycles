//
//  StepsInsights.swift
//  Forge
//
//  The step-specific part of the Step Goal history screen: recent daily
//  totals against the goal, plus how the weekly average has moved.
//

import SwiftUI
import Charts

struct StepsInsightsSection: View {
    /// Daily totals keyed by start of day (missing days had no steps recorded).
    let stepsByDay: [Date: Int]
    let goal: Int

    private let calendar = Calendar.current
    private static let recentDays = 30

    private struct DayTotal: Identifiable {
        let date: Date
        let steps: Int
        var id: Date { date }
    }

    private struct WeekAverage: Identifiable {
        let weekStart: Date
        let average: Int
        var id: Date { weekStart }
    }

    private var today: Date { calendar.startOfDay(for: Date()) }

    /// The last 30 days, oldest first, with zeros for days Health has nothing for.
    private var recent: [DayTotal] {
        (0..<Self.recentDays).reversed().compactMap { offset in
            guard let day = calendar.date(byAdding: .day, value: -offset, to: today) else { return nil }
            return DayTotal(date: day, steps: stepsByDay[day] ?? 0)
        }
    }

    /// Average daily steps per week for the past year, skipping weeks with no data at all.
    private var weekly: [WeekAverage] {
        let byWeek = Dictionary(grouping: stepsByDay) { entry in
            calendar.dateInterval(of: .weekOfYear, for: entry.key)?.start ?? entry.key
        }
        return byWeek.compactMap { weekStart, entries in
            // Average over the days that have passed in that week, so this week isn't understated.
            let elapsed = (0..<7).filter { offset in
                guard let day = calendar.date(byAdding: .day, value: offset, to: weekStart) else { return false }
                return day <= today
            }.count
            let total = entries.reduce(0) { $0 + $1.value }
            guard total > 0, elapsed > 0 else { return nil }
            return WeekAverage(weekStart: weekStart, average: total / elapsed)
        }
        .sorted { $0.weekStart < $1.weekStart }
    }

    private var average: Int {
        recent.isEmpty ? 0 : recent.reduce(0) { $0 + $1.steps } / recent.count
    }

    private var best: DayTotal? {
        stepsByDay.filter { $0.value > 0 }.max { $0.value < $1.value }.map { DayTotal(date: $0.key, steps: $0.value) }
    }

    private var hitRate: Int {
        guard !recent.isEmpty else { return 0 }
        return Int((Double(recent.filter { $0.steps >= goal }.count) / Double(recent.count) * 100).rounded())
    }

    var body: some View {
        Section {
            HStack(alignment: .top) {
                stat("Daily average", value: average.formatted(), caption: "last 30 days")
                Divider()
                stat("Best day", value: best?.steps.formatted() ?? "—",
                     caption: best?.date.formatted(.dateTime.month(.abbreviated).day()) ?? "")
                Divider()
                stat("Goal hit", value: "\(hitRate)%", caption: "last 30 days")
            }
            .padding(.vertical, 4)

            VStack(alignment: .leading, spacing: 8) {
                Text("Last 30 days")
                    .font(.subheadline.weight(.semibold))
                Chart {
                    ForEach(recent) { day in
                        BarMark(
                            x: .value("Day", day.date, unit: .day),
                            y: .value("Steps", day.steps)
                        )
                        .foregroundStyle(day.steps >= goal ? Color.green : Color.green.opacity(0.35))
                        .cornerRadius(2)
                    }
                    RuleMark(y: .value("Goal", goal))
                        .lineStyle(StrokeStyle(lineWidth: 1, dash: [4, 3]))
                        .foregroundStyle(.secondary)
                        .annotation(position: .top, alignment: .leading) {
                            Text("Goal \(goal.formatted())")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                }
                .chartXAxis {
                    AxisMarks(values: .stride(by: .day, count: 7)) { _ in
                        AxisGridLine()
                        AxisValueLabel(format: .dateTime.month(.abbreviated).day())
                    }
                }
                .chartYAxis { AxisMarks(position: .trailing, values: .automatic(desiredCount: 3)) }
                .frame(height: 160)
                .accessibilityLabel("Daily steps for the last 30 days, averaging \(average.formatted())")
            }
            .padding(.vertical, 6)

            if weekly.count > 1 {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Weekly average")
                        .font(.subheadline.weight(.semibold))
                    Chart {
                        ForEach(weekly) { week in
                            AreaMark(
                                x: .value("Week", week.weekStart, unit: .weekOfYear),
                                y: .value("Average", week.average)
                            )
                            .foregroundStyle(Color.green.opacity(0.15))
                            LineMark(
                                x: .value("Week", week.weekStart, unit: .weekOfYear),
                                y: .value("Average", week.average)
                            )
                            .foregroundStyle(Color.green)
                        }
                        RuleMark(y: .value("Goal", goal))
                            .lineStyle(StrokeStyle(lineWidth: 1, dash: [4, 3]))
                            .foregroundStyle(.secondary)
                    }
                    .chartXAxis {
                        AxisMarks(values: .stride(by: .month)) { _ in
                            AxisGridLine()
                            AxisValueLabel(format: .dateTime.month(.abbreviated))
                        }
                    }
                    .chartYAxis { AxisMarks(position: .trailing, values: .automatic(desiredCount: 3)) }
                    .frame(height: 140)
                    .accessibilityLabel("Average daily steps per week over the past year")
                }
                .padding(.vertical, 6)
            }
        } header: {
            Text("Steps")
        } footer: {
            Text("From Apple Health. Bars are solid on days you hit your goal.")
        }
    }

    private func stat(_ title: String, value: String, caption: String) -> some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.title3.weight(.bold).monospacedDigit())
                .foregroundStyle(.green)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(caption)
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .combine)
    }
}
