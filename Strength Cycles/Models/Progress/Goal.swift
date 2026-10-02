//
//  Goal.swift
//  Strength Cycles
//
//  Created by Matthew Bunce on 2025-06-08.
//
import Foundation
import SwiftData

@Model
class Goal {
    var goal: String
    var completionDate: Date?
    var isCompleted: Bool
    /// Display position; SwiftData doesn't keep insertion order.
    var order: Int = 0

    init(goal: String, order: Int = 0, completionDate: Date? = nil, isCompleted: Bool = false) {
        self.goal = goal
        self.order = order
        self.completionDate = completionDate
        self.isCompleted = isCompleted
    }
}

extension Goal {
    static var defaultGoals: [Goal] {
        [
            "135lbs OHP",
            "225lbs Bench",
            "315lbs Squat",
            "405lbs Deadlift",
            "1000lbs total (Total of your 1 rep max on Squat, Bench, and Deadlift)",
            "Sub 6-minute mile",
            "60s Dead Hang",
            "Bodyweight farmers walk for 100m (e.g., 200lbs = 100lbs per hand)"
        ].enumerated().map { Goal(goal: $1, order: $0) }
    }
}
