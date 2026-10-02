//
//  CustomRunPlan.swift
//  Forge
//
//  A running plan the user builds themselves (Forge Plus): an ordered list of
//  runs, grouped into weeks by how many runs a week they choose.
//

import Foundation
import SwiftData

struct CustomRun: Codable, Hashable, Identifiable {
    enum Kind: String, Codable, CaseIterable, Identifiable {
        case intervals, steady, distance
        var id: Self { self }
        var title: String {
            switch self {
            case .intervals: return "Intervals"
            case .steady: return "Timed"
            case .distance: return "Distance"
            }
        }
    }

    var id = UUID()
    var kind: Kind = .intervals
    /// Intervals: run and walk lengths in seconds, repeated.
    var runSeconds: Int = 60
    var walkSeconds: Int = 90
    var repeats: Int = 8
    /// Timed: minutes of continuous running.
    var minutes: Int = 20
    /// Distance: kilometres.
    var kilometres: Double = 5
    /// Add a 5-minute warm-up and cool-down walk to timed runs.
    var warmUpAndCoolDown: Bool = true

    var segments: [RunSegment] {
        switch kind {
        case .distance:
            return [.runKm(kilometres)]
        case .steady:
            return wrapped([.run(minutes * 60)])
        case .intervals:
            let pair: [RunSegment] = walkSeconds > 0 ? [.run(runSeconds), .walk(walkSeconds)] : [.run(runSeconds)]
            return wrapped(Array(repeating: pair, count: max(repeats, 1)).flatMap { $0 })
        }
    }

    private func wrapped(_ core: [RunSegment]) -> [RunSegment] {
        warmUpAndCoolDown ? [.warmUp] + core + [.coolDown] : core
    }

    /// Short description for the editor list, using the same wording as plan sessions.
    var summary: String {
        RunSession(week: 1, number: 1, title: "", segments: segments).summary
    }
}

@Model
class CustomRunPlan {
    var id: UUID = UUID()
    var name: String = ""
    var details: String = ""
    var createdAt: Date = Date()
    var runsPerWeek: Int = 3
    var runs: [CustomRun] = []

    init(name: String, details: String = "", runsPerWeek: Int = 3, runs: [CustomRun] = []) {
        self.id = UUID()
        self.name = name
        self.details = details
        self.createdAt = Date()
        self.runsPerWeek = runsPerWeek
        self.runs = runs
    }

    var weekCount: Int {
        runs.isEmpty ? 0 : (runs.count - 1) / max(runsPerWeek, 1) + 1
    }

    /// Builds a plan to follow, numbering runs into weeks.
    func createPlan(startDate: Date = Date()) -> RunPlan {
        let perWeek = max(runsPerWeek, 1)
        let sessions = runs.enumerated().map { index, run in
            let week = index / perWeek + 1
            let number = index % perWeek + 1
            return RunSession(week: week, number: number,
                              title: "Week \(week) · Run \(number)",
                              segments: run.segments)
        }
        return RunPlan(name: name, sessions: sessions, startDate: startDate)
    }
}
