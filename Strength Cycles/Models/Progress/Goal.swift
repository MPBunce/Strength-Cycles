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

    init(goal: String, completionDate: Date? = nil, isCompleted: Bool = false) {
        self.goal = goal
        self.completionDate = completionDate
        self.isCompleted = isCompleted
    }
}

extension Goal {
    static var defaultGoals: [Goal] = [
        Goal(goal: "135lbs OHP"),
        Goal(goal: "225lbs Bench"),
        Goal(goal: "315lbs Squat"),
        Goal(goal: "405lbs Deadlift"),
        Goal(goal: "1000lbs total (Total of your 1 rep max on Squat, Bench, and Deadlift)"),
        Goal(goal: "Sub 6-minute mile"),
        Goal(goal: "60s Dead Hang"),
        Goal(goal: "Bodyweight farmers walk for 100m (e.g., 200lbs = 100lbs per hand)")
    ]
}
