//
//  ArnoldSplit.swift
//  Forge
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
                    Exercise(exerciseIndex: 0, name: "Squat", sets: SetScheme.straight(4, reps: 6)),
                    Exercise(exerciseIndex: 1, name: "Romanian Deadlift", sets: SetScheme.straight(3, reps: 8)),
                    Exercise(exerciseIndex: 2, name: "Leg Press", sets: SetScheme.straight(3, reps: 10)),
                    Exercise(exerciseIndex: 3, name: "Leg Curls", sets: SetScheme.straight(3, reps: 12)),
                    Exercise(exerciseIndex: 4, name: "Leg Extensions", sets: SetScheme.straight(3, reps: 12)),
                    Exercise(exerciseIndex: 5, name: "Calf Raises", sets: SetScheme.straight(4, reps: 12))
                ],
                completedDate: nil
            ),
            
            // Day 2 Chest n Back
            TrainingDay(
                dayIndex: 1,
                dayName: "Chest & Back",
                day: [
                    Exercise(exerciseIndex: 0, name: "Bench Press", sets: SetScheme.straight(4, reps: 6)),
                    Exercise(exerciseIndex: 1, name: "Barbell Rows", sets: SetScheme.straight(3, reps: 8)),
                    Exercise(exerciseIndex: 2, name: "Incline Dumbbell Press", sets: SetScheme.straight(3, reps: 8)),
                    Exercise(exerciseIndex: 3, name: "Pull-ups", sets: SetScheme.straight(3, reps: 8)),
                    Exercise(exerciseIndex: 4, name: "Dips", sets: SetScheme.straight(3, reps: 8)),
                    Exercise(exerciseIndex: 5, name: "Cable Rows", sets: SetScheme.straight(3, reps: 8))
                ],
                completedDate: nil
            ),
            
            // Day 3: Arms & Shoulders
            TrainingDay(
                dayIndex: 2,
                dayName: "Arms & Shoulders",
                day: [
                    Exercise(exerciseIndex: 0, name: "Overhead Press", sets: SetScheme.straight(4, reps: 6)),
                    Exercise(exerciseIndex: 1, name: "Barbell Curls", sets: SetScheme.straight(3, reps: 12)),
                    Exercise(exerciseIndex: 2, name: "Close Grip Bench Press", sets: SetScheme.straight(4, reps: 6)),
                    Exercise(exerciseIndex: 3, name: "Lateral Raises", sets: SetScheme.straight(3, reps: 15)),
                    Exercise(exerciseIndex: 4, name: "Hammer Curls", sets: SetScheme.straight(3, reps: 12)),
                    Exercise(exerciseIndex: 5, name: "Tricep Extensions", sets: SetScheme.straight(3, reps: 12))
                ],
                completedDate: nil
            )
        ]
    }
}
