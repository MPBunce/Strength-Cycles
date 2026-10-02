//
//  RunningGoals.swift
//  Forge
//
//  Running goals on the Goals screen: finish each race distance, then beat a
//  top-5% time. Both tick themselves off from logged races.
//

import SwiftUI
import SwiftData

struct RunningGoalsSection: View {
    @Query private var races: [RaceResult]
    @State private var editing: RaceDistance?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Running Goals")
                .font(.title2)
                .bold()
            Text("Log races in Cycles › Running. Finishing a distance and beating its target time tick off automatically. Tap a time goal to change the target.")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 16)

        LazyVStack(spacing: 12) {
            ForEach(RaceDistance.allCases) { distance in
                RaceGoalCard(distance: distance,
                             results: races.filter { $0.distance == distance },
                             onEditTarget: { editing = distance })
            }
        }
        .sheet(item: $editing) { distance in
            TargetTimeSheet(distance: distance)
        }
    }
}

private struct RaceGoalCard: View {
    let distance: RaceDistance
    let results: [RaceResult]
    let onEditTarget: () -> Void

    @AppStorage private var targetSeconds: Int

    init(distance: RaceDistance, results: [RaceResult], onEditTarget: @escaping () -> Void) {
        self.distance = distance
        self.results = results
        self.onEditTarget = onEditTarget
        _targetSeconds = AppStorage(wrappedValue: distance.defaultTopFivePercentSeconds, distance.targetKey)
    }

    private var best: RaceResult? { results.min { $0.seconds < $1.seconds } }
    private var firstFinish: RaceResult? { results.min { $0.date < $1.date } }

    /// First race that beat the current target.
    private var targetHit: RaceResult? {
        results.filter { $0.seconds <= targetSeconds }.min { $0.date < $1.date }
    }

    private var isDefaultTarget: Bool { targetSeconds == distance.defaultTopFivePercentSeconds }

    var body: some View {
        VStack(spacing: 0) {
            goalRow(done: firstFinish != nil,
                    title: "Finish a \(distance.name)",
                    detail: firstFinish.map { "Completed \($0.date.formatted(date: .abbreviated, time: .omitted))" })

            Divider().padding(.leading, 48)

            Button(action: onEditTarget) {
                goalRow(done: targetHit != nil,
                        title: "\(distance.name) in \(RaceTime.format(targetSeconds))\(isDefaultTarget ? " (top 5%)" : "")",
                        detail: timeDetail,
                        showsChevron: true)
            }
            .buttonStyle(.plain)
        }
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }

    private var timeDetail: String? {
        if let hit = targetHit {
            return "Completed \(hit.date.formatted(date: .abbreviated, time: .omitted)) · PB \(RaceTime.format(best?.seconds ?? hit.seconds))"
        }
        guard let best else { return "No \(distance.name) logged yet" }
        let gap = best.seconds - targetSeconds
        return "PB \(RaceTime.format(best.seconds)) · \(RaceTime.format(gap)) to go"
    }

    private func goalRow(done: Bool, title: String, detail: String?, showsChevron: Bool = false) -> some View {
        HStack(spacing: 12) {
            Image(systemName: done ? "checkmark.circle.fill" : "circle")
                .font(.title2)
                .foregroundColor(done ? .green : .gray)
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .strikethrough(done)
                    .foregroundColor(done ? .secondary : .primary)
                if let detail {
                    Text(detail)
                        .font(.caption)
                        .foregroundColor(done ? .green : .secondary)
                }
            }
            Spacer()
            if showsChevron {
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
        }
        .padding()
        .contentShape(Rectangle())
    }
}

/// Change the target time for one distance.
private struct TargetTimeSheet: View {
    @Environment(\.dismiss) private var dismiss
    let distance: RaceDistance
    @AppStorage private var targetSeconds: Int
    @State private var hours = 0
    @State private var minutes = 0
    @State private var seconds = 0

    init(distance: RaceDistance) {
        self.distance = distance
        _targetSeconds = AppStorage(wrappedValue: distance.defaultTopFivePercentSeconds, distance.targetKey)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack(spacing: 0) {
                        wheel($hours, 0..<10, "h")
                        wheel($minutes, 0..<60, "m")
                        wheel($seconds, 0..<60, "s")
                    }
                    .frame(height: 150)
                } footer: {
                    Text("The default, \(RaceTime.format(distance.defaultTopFivePercentSeconds)), is a rough top-5% time across all finishers in large public races. Real cut-offs depend a lot on age and sex, so set whatever target suits you.")
                }
                Section {
                    Button("Reset to \(RaceTime.format(distance.defaultTopFivePercentSeconds))") {
                        set(distance.defaultTopFivePercentSeconds)
                    }
                }
            }
            .navigationTitle("\(distance.name) Target")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        targetSeconds = hours * 3600 + minutes * 60 + seconds
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .disabled(hours * 3600 + minutes * 60 + seconds == 0)
                }
            }
            .onAppear { set(targetSeconds) }
        }
        .presentationDetents([.medium, .large])
    }

    private func set(_ total: Int) {
        hours = total / 3600
        minutes = (total % 3600) / 60
        seconds = total % 60
    }

    private func wheel(_ value: Binding<Int>, _ range: Range<Int>, _ unit: String) -> some View {
        Picker(unit, selection: value) {
            ForEach(range, id: \.self) { Text("\($0) \(unit)").tag($0) }
        }
        .pickerStyle(.wheel)
        .frame(maxWidth: .infinity)
        .clipped()
    }
}
