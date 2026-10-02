//
//  CustomTemplate.swift
//  Forge
//
//  A cycle template the user builds themselves. Days and exercises are stored
//  as plain value arrays so their order is kept exactly as entered.
//

import Foundation
import SwiftData

struct CustomTemplateExercise: Codable, Hashable, Identifiable {
    var id = UUID()
    var name: String = ""
    var sets: Int = 3
    var reps: Int = 8
    /// Take the last set to as many reps as possible.
    var lastSetAmrap: Bool = false
}

struct CustomTemplateDay: Codable, Hashable, Identifiable {
    var id = UUID()
    var name: String = ""
    var exercises: [CustomTemplateExercise] = []
}

@Model
class CustomTemplate {
    var id: UUID = UUID()
    var name: String = ""
    var details: String = ""
    var createdAt: Date = Date()
    var days: [CustomTemplateDay] = []

    init(name: String, details: String = "", days: [CustomTemplateDay] = []) {
        self.id = UUID()
        self.name = name
        self.details = details
        self.createdAt = Date()
        self.days = days
    }

    /// Builds a cycle with blank, editable weights for the lifter to fill in.
    func createCycle(usesKilograms: Bool, startDate: Date = Date()) -> Cycles {
        let trainingDays = days.enumerated().map { dayIndex, day in
            TrainingDay(
                dayIndex: dayIndex,
                dayName: day.name.isEmpty ? "Day \(dayIndex + 1)" : day.name,
                day: day.exercises.enumerated().map { exerciseIndex, exercise in
                    Exercise(
                        exerciseIndex: exerciseIndex,
                        name: exercise.name,
                        sets: exercise.lastSetAmrap
                            ? SetScheme.lastSetAmrap(exercise.sets, reps: exercise.reps)
                            : SetScheme.straight(exercise.sets, reps: exercise.reps)
                    )
                }
            )
        }
        return Cycles(startDate: startDate, template: name, usesKilograms: usesKilograms, trainingDays: trainingDays)
    }
}
