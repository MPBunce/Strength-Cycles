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

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Running Goals")
                .font(.title2)
                .bold()
            Text("Log races in Training › Running. Finishing a distance and running a top-5% time tick off automatically.")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 16)

        LazyVStack(spacing: 12) {
            ForEach(RaceDistance.allCases) { distance in
                RaceGoalCard(distance: distance,
                             results: races.filter { $0.distance == distance })
            }
        }
    }
}

private struct RaceGoalCard: View {
    let distance: RaceDistance
    let results: [RaceResult]

    /// The fixed "big goal": a rough top-5% finish time.
    private var targetSeconds: Int { distance.defaultTopFivePercentSeconds }

    private var best: RaceResult? { results.min { $0.seconds < $1.seconds } }
    private var firstFinish: RaceResult? { results.min { $0.date < $1.date } }

    /// First race that beat the current target.
    private var targetHit: RaceResult? {
        results.filter { $0.seconds <= targetSeconds }.min { $0.date < $1.date }
    }

    var body: some View {
        VStack(spacing: 0) {
            goalRow(done: firstFinish != nil,
                    title: "Finish a \(distance.name)",
                    detail: firstFinish.map { "Completed \($0.date.formatted(date: .abbreviated, time: .omitted))" })

            Divider().padding(.leading, 48)

            goalRow(done: targetHit != nil,
                    title: "\(distance.name) in \(RaceTime.format(targetSeconds)) (top 5%)",
                    detail: timeDetail)
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

    private func goalRow(done: Bool, title: String, detail: String?) -> some View {
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
        }
        .padding()
        .contentShape(Rectangle())
    }
}
