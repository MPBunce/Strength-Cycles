//
//  StepsSection.swift
//  Forge
//

import SwiftUI
import SwiftData
import Charts

struct StepsSection: View {
    let steps: StepCounter
    @Query private var settings: [Settings]

    private var goal: Int { settings.first?.dailyStepGoal ?? 10000 }

    var body: some View {
        Section {
            switch steps.state {
            case .unavailable:
                Label("Step tracking needs Apple Health, which isn't available on this device.", systemImage: "heart.slash")
                    .foregroundStyle(.secondary)
            case .failed(let message):
                VStack(alignment: .leading, spacing: 8) {
                    Label("Couldn't read steps from Apple Health.", systemImage: "exclamationmark.triangle")
                    Text(message).font(.caption).foregroundStyle(.secondary)
                    Button("Try Again") { Task { await steps.refresh() } }
                }
            case .idle, .loading where steps.lastSevenDays.isEmpty:
                HStack {
                    SwiftUI.ProgressView()
                    Text("Loading steps…").foregroundStyle(.secondary)
                }
            default:
                todayProgress
                weekChart
            }
        } header: {
            Text("Steps")
        } footer: {
            if steps.state == .loaded && steps.today == 0 {
                Text("No steps yet today. If this stays at zero, check Forge is allowed to read Steps in the Health app under Sharing › Apps.")
            }
        }
    }

    private var todayProgress: some View {
        let fraction = min(Double(steps.today) / Double(max(goal, 1)), 1)
        return VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .firstTextBaseline) {
                Text(steps.today, format: .number)
                    .font(.system(.largeTitle, design: .rounded, weight: .bold))
                    .monospacedDigit()
                Text("/ \(goal.formatted()) steps")
                    .foregroundStyle(.secondary)
                Spacer()
                if steps.today >= goal {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.title2)
                        .foregroundStyle(.green)
                        .accessibilityLabel("Goal reached")
                }
            }
            SwiftUI.ProgressView(value: fraction)
                .tint(steps.today >= goal ? .green : .accentColor)
        }
        .padding(.vertical, 4)
    }

    private var weekChart: some View {
        Chart {
            ForEach(steps.lastSevenDays) { day in
                BarMark(
                    x: .value("Day", day.date, unit: .day),
                    y: .value("Steps", day.steps)
                )
                .foregroundStyle(day.steps >= goal ? Color.green : Color.accentColor.opacity(0.6))
                .cornerRadius(3)
            }
            RuleMark(y: .value("Goal", goal))
                .lineStyle(StrokeStyle(lineWidth: 1, dash: [4, 3]))
                .foregroundStyle(.secondary)
        }
        .chartXAxis {
            AxisMarks(values: .stride(by: .day)) { _ in
                AxisValueLabel(format: .dateTime.weekday(.narrow), centered: true)
            }
        }
        .chartYAxis {
            AxisMarks(position: .trailing, values: .automatic(desiredCount: 3))
        }
        .frame(height: 120)
        .padding(.vertical, 4)
        .accessibilityLabel("Steps over the last seven days")
    }
}
