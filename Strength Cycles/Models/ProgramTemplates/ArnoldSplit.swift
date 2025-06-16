//
//  ArnoldSplit.swift
//  Strength Cycles
//
//  Created by Matthew Bunce on 2025-06-15.
//


import Foundation
import SwiftData

@Model
class ArnoldSplit: ProgramProtocol {
    var trainingDays: [TrainingDay]
    
    func copyTrainingDays() -> [TrainingDay] {
        return trainingDays.map { $0.copy() }
    }
    
    init() {
        self.trainingDays = [
            // Day 1: Legs
            TrainingDay(
                dayIndex: 0,
                dayName: "Legs",
                day: [
                    Exercise(exerciseIndex: 0, name: "Squat", sets: []),
                    Exercise(exerciseIndex: 1, name: "Romanian Deadlift", sets: []),
                    Exercise(exerciseIndex: 2, name: "Leg Press", sets: []),
                    Exercise(exerciseIndex: 3, name: "Leg Curls", sets: []),
                    Exercise(exerciseIndex: 4, name: "Leg Extensions", sets: []),
                    Exercise(exerciseIndex: 5, name: "Calf Raises", sets: [])
                ],
                completedDate: nil
            ),
            
            // Day 2 Chest n Back
            TrainingDay(
                dayIndex: 1,
                dayName: "Chest & Back",
                day: [
                    Exercise(exerciseIndex: 0, name: "Bench Press", sets: []),
                    Exercise(exerciseIndex: 1, name: "Barbell Rows", sets: []),
                    Exercise(exerciseIndex: 2, name: "Incline Dumbbell Press", sets: []),
                    Exercise(exerciseIndex: 3, name: "Pull-ups", sets: []),
                    Exercise(exerciseIndex: 4, name: "Dips", sets: []),
                    Exercise(exerciseIndex: 5, name: "Cable Rows", sets: [])
                ],
                completedDate: nil
            ),
            
            // Day 3: Arms & Shoulders
            TrainingDay(
                dayIndex: 2,
                dayName: "Arms & Shoulders",
                day: [
                    Exercise(exerciseIndex: 0, name: "Overhead Press", sets: []),
                    Exercise(exerciseIndex: 1, name: "Barbell Curls", sets: []),
                    Exercise(exerciseIndex: 2, name: "Close Grip Bench Press", sets: []),
                    Exercise(exerciseIndex: 3, name: "Lateral Raises", sets: []),
                    Exercise(exerciseIndex: 4, name: "Hammer Curls", sets: []),
                    Exercise(exerciseIndex: 5, name: "Tricep Extensions", sets: [])
                ],
                completedDate: nil
            )
        ]
    }
}
