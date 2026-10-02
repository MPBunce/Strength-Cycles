//
//  Challenge.swift
//  Forge
//

import Foundation
import SwiftData

/// A one-off goal the user works toward and ticks off when done.
@Model
class Challenge {
    var title: String = ""
    var details: String = ""
    var createdAt: Date = Date()
    var completedAt: Date?

    init(title: String, details: String = "") {
        self.title = title
        self.details = details
        self.createdAt = Date()
    }

    var isCompleted: Bool { completedAt != nil }

    static let presets: [(title: String, details: String)] = [
        ("Villain Challenge 1: Stage 1", "3 × 10 burpees in 30 sec per set, working toward 1 minute rest between sets."),
        ("Villain Challenge 1: Stage 2", "3 sets of burpees, building toward 30 reps in 90 sec per set with 1 minute rest."),
        ("Villain Challenge 1: Stage 3", "2 × 50 burpees in 2:30 per set with 1 minute rest."),
        ("Villain Challenge 1: Stage 4", "1 × 100 burpees in 5:00."),
        ("20-Minute Aerobic Solution", "20 minutes of cardio climbing an effort ladder from 5 to 10 out of 10, finishing with a cool-down."),
        ("60s Dead Hang", "Hang from a bar for a full minute without letting go.")
    ]
}
