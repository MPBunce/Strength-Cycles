//
//  UpperLower.swift
//  Strength Cycles
//
//  Created by Matthew Bunce on 2025-06-10.
//
import SwiftData

@Model
class UpperLowerProgram: ProgramProtocol {
    var trainingDays: [TrainingDay]
    
    func copyTrainingDays() -> [TrainingDay] {
        return trainingDays.map { $0.copy() }
    }
    
    init() {
        self.trainingDays = [
            TrainingDay(
                dayIndex: 0,
                dayName: "Upper Body",
                day: [
                    Exercise(exerciseIndex: 0, name: "Bench Press", sets: []),
                    Exercise(exerciseIndex: 1, name: "Barbell Rows", sets: []),
                    Exercise(exerciseIndex: 2, name: "Overhead Press", sets: []),
                    Exercise(exerciseIndex: 3, name: "Pull-ups", sets: []),
                    Exercise(exerciseIndex: 4, name: "Barbell Curls", sets: []),
                    Exercise(exerciseIndex: 5, name: "Tricep Extensions", sets: [])
                ],
                completedDate: nil
            ),
            TrainingDay(
                dayIndex: 1,
                dayName: "Lower Body",
                day: [
                    Exercise(exerciseIndex: 0, name: "Squat", sets: []),
                    Exercise(exerciseIndex: 1, name: "Romanian Deadlift", sets: []),
                    Exercise(exerciseIndex: 2, name: "Leg Press", sets: []),
                    Exercise(exerciseIndex: 3, name: "Leg Curls", sets: []),
                    Exercise(exerciseIndex: 4, name: "Calf Raises", sets: [])
                ],
                completedDate: nil
            ),
            TrainingDay(
                dayIndex: 2,
                dayName: "Upper Body",
                day: [
                    Exercise(exerciseIndex: 0, name: "Incline Dumbbell Press", sets: []),
                    Exercise(exerciseIndex: 1, name: "Cable Rows", sets: []),
                    Exercise(exerciseIndex: 2, name: "Dumbbell Press", sets: []),
                    Exercise(exerciseIndex: 3, name: "Lat Pulldowns", sets: []),
                    Exercise(exerciseIndex: 4, name: "Hammer Curls", sets: []),
                    Exercise(exerciseIndex: 5, name: "Overhead Tricep Extension", sets: [])
                ],
                completedDate: nil
            ),
            TrainingDay(
                dayIndex: 3,
                dayName: "Lower Body",
                day: [
                    Exercise(exerciseIndex: 0, name: "Deadlift", sets: []),
                    Exercise(exerciseIndex: 1, name: "Front Squat", sets: []),
                    Exercise(exerciseIndex: 2, name: "Walking Lunges", sets: []),
                    Exercise(exerciseIndex: 3, name: "Leg Extensions", sets: []),
                    Exercise(exerciseIndex: 4, name: "Seated Calf Raises", sets: [])
                ],
                completedDate: nil
            )
        ]
    }
}
