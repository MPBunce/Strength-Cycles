//
//  StreakBadges.swift
//  Forge
//
//  Milestone badges on each habit's history screen: days per year for workouts
//  and steps, unbroken streaks for daily work and stretching.
//

import SwiftUI

extension ActivityMetric {
    /// Workouts and steps are counted per year; daily habits are about unbroken streaks.
    var usesYearlyCount: Bool {
        self == .workout || self == .running || self == .steps
    }

    /// Running badges are kilometres this year rather than days.
    var badgesUseDistance: Bool { self == .running }

    /// Badge thresholds: days completed this year, km run this year, or days in a row.
    var badgeMilestones: [Int] {
        switch self {
        case .workout: return [10, 25, 50, 75, 100, 150, 200, 250]
        case .running: return [10, 25, 50, 100, 250, 500, 750, 1000]
        case .steps: return [10, 30, 60, 100, 150, 200, 300, 365]
        case .dailyWork, .stretching: return [3, 7, 14, 30, 60, 100, 180, 365]
        }
    }
}

struct StreakBadgesSection: View {
    let metric: ActivityMetric
    /// Days completed this calendar year (yearly metrics) or the current streak (streak metrics).
    let progress: Int
    /// What earns badges: this year's count, or the longest streak.
    let best: Int

    private var milestones: [Int] { metric.badgeMilestones }

    private var nextMilestone: Int? {
        milestones.first { $0 > progress }
    }

    private var year: String {
        Date().formatted(.dateTime.year())
    }

    var body: some View {
        Section {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 4), spacing: 14) {
                ForEach(milestones, id: \.self) { days in
                    StreakBadge(days: days,
                                earned: best >= days,
                                color: metric.color,
                                icon: metric.usesYearlyCount ? metric.icon : "flame.fill",
                                caption: caption(for: days))
                }
            }
            .padding(.vertical, 8)
        } header: {
            Text(metric.usesYearlyCount ? "\(year) Badges" : "Streak Badges")
        } footer: {
            Text(footer)
        }
    }

    private func caption(for days: Int) -> String {
        if metric.badgesUseDistance { return "\(days) km" }
        if metric.usesYearlyCount { return "\(days) days" }
        return days == 365 ? "1 year" : "\(days) in a row"
    }

    private var footer: String {
        let unit: String
        switch metric {
        case .workout: unit = "workout"
        case .running: unit = "run"
        default: unit = "goal"
        }
        if metric.badgesUseDistance {
            guard let next = nextMilestone else { return "Every \(year) badge earned. Distance resets on January 1." }
            return "\(progress) km run so far in \(year). \(next - progress) km more for the \(next) km badge. Distance resets on January 1."
        }
        if metric.usesYearlyCount {
            guard let next = nextMilestone else { return "Every \(year) badge earned. Counts reset on January 1." }
            let toGo = next - progress
            return "\(progress) \(unit) \(progress == 1 ? "day" : "days") so far in \(year). \(toGo) more for the \(next)-day badge. Counts reset on January 1."
        }
        guard let next = nextMilestone else { return "Every badge earned. Badges are earned by your longest streak." }
        let toGo = next - progress
        return "\(toGo) more \(toGo == 1 ? "day" : "days") in a row for the \(next)-day badge. Badges are earned by your longest streak."
    }
}

private struct StreakBadge: View {
    let days: Int
    let earned: Bool
    let color: Color
    let icon: String
    let caption: String

    var body: some View {
        VStack(spacing: 6) {
            ZStack {
                Circle()
                    .fill(earned ? color.opacity(0.18) : Color(.tertiarySystemFill))
                Circle()
                    .strokeBorder(earned ? color : Color.secondary.opacity(0.3), lineWidth: 2)
                VStack(spacing: 0) {
                    Image(systemName: earned ? icon : "lock.fill")
                        .font(earned ? .body : .caption)
                        .foregroundStyle(earned ? color : .secondary)
                    Text("\(days)")
                        .font(.headline.monospacedDigit())
                        .foregroundStyle(earned ? .primary : .secondary)
                }
            }
            .frame(width: 58, height: 58)

            Text(caption)
                .font(.caption2)
                .foregroundStyle(earned ? .primary : .secondary)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(caption) badge, \(earned ? "earned" : "not earned yet")")
    }
}
