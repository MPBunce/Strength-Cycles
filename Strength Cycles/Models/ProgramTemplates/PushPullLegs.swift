//
//  PushPullLegs.swift
//  Strength Cycles
//
//  Created by Matthew Bunce on 2025-06-06.
//

import SwiftData

@Model
class PPLProgram: ProgramProtocol {
    var trainingDays: [TrainingDay]
    
    func copyTrainingDays() -> [TrainingDay] {
        return trainingDays.map { $0.copy() }
    }
    
    init() {
        self.trainingDays = [
            TrainingDay(
                dayIndex: 0,
                dayName: "Push",
                day: [
                    Exercise(exerciseIndex: 0, name: "Bench Press", sets: []),
                    Exercise(exerciseIndex: 1, name: "Overhead Press", sets: []),
                    Exercise(exerciseIndex: 2, name: "Incline Dumbbell Press", sets: []),
                    Exercise(exerciseIndex: 3, name: "Tricep Pushdowns", sets: []),
                    Exercise(exerciseIndex: 4, name: "Lateral Raises", sets: [])
                ],
                completedDate: nil
            ),
            TrainingDay(
                dayIndex: 1,
                dayName: "Pull",
                day: [
                    Exercise(exerciseIndex: 0, name: "Deadlift", sets: []),
                    Exercise(exerciseIndex: 1, name: "Pull-ups", sets: []),
                    Exercise(exerciseIndex: 2, name: "Barbell Rows", sets: []),
                    Exercise(exerciseIndex: 3, name: "Barbell Curls", sets: []),
                    Exercise(exerciseIndex: 4, name: "Face Pulls", sets: [])
                ],
                completedDate: nil
            ),
            TrainingDay(
                dayIndex: 2,
                dayName: "Legs",
                day: [
                    Exercise(exerciseIndex: 0, name: "Squat", sets: []),
                    Exercise(exerciseIndex: 1, name: "Romanian Deadlift", sets: []),
                    Exercise(exerciseIndex: 2, name: "Leg Press", sets: []),
                    Exercise(exerciseIndex: 3, name: "Leg Curls", sets: []),
                    Exercise(exerciseIndex: 4, name: "Calf Raises", sets: [])
                ],
                completedDate: nil
            )
        ]
    }
}
