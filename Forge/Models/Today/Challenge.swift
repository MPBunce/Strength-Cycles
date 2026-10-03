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
        ("60s Dead Hang", "Hang from a bar for a full minute without letting go."),
        ("100 Push-ups in One Set", "Unbroken, chest to the floor every rep. Rest in the top position only."),
        ("20 Strict Pull-ups", "Dead hang to chin over the bar, no kipping, in one set."),
        ("2-Minute Plank", "Forearm plank, straight line from head to heels, for 2 minutes."),
        ("5 Pistol Squats Each Leg", "Full-depth single-leg squats, heel down, no support."),
        ("30s Handstand Hold", "Against a wall is fine. Arms locked, 30 seconds."),
        ("Bodyweight Bench Press", "Bench your own bodyweight for a clean single."),
        ("Double Bodyweight Deadlift", "Pull twice your bodyweight for one rep."),
        ("Murph", "1 mile run, 100 pull-ups, 200 push-ups, 300 squats, 1 mile run. Split the middle part however you like."),
        ("Deck of Cards", "Draw from a shuffled deck: the card's value in push-ups (face cards 10, aces 11). Clear the whole deck."),
        ("10,000 Swings", "Dan John's challenge: 10,000 kettlebell swings over 4 weeks, about 500 a session, 5 sessions a week.")
    ]
}
