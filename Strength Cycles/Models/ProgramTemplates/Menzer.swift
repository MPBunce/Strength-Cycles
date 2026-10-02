//
//  ModernMenzer.swift
//  Strength Cycles
//
//  Created by Matthew Bunce on 2025-06-06.
//

import Foundation
import SwiftData

@Model
class MenzerProgram: ProgramProtocol {
    var trainingDays: [TrainingDay]
    
    func copyTrainingDays() -> [TrainingDay] {
        return trainingDays.map { $0.copy() }
    }
    
    init() {
        self.trainingDays = [
            TrainingDay(
                dayIndex: 0,
                dayName: "Chest & Back",
                day: [
                    Exercise(
                        exerciseIndex: 0,
                        name: "Dips",
                        sets: SetScheme.lastSetAmrap(1, reps: 6)
                    ),
                    Exercise(
                        exerciseIndex: 1,
                        name: "Incline Dumbbell Press",
                        sets: SetScheme.lastSetAmrap(1, reps: 6)
                    ),
                    Exercise(
                        exerciseIndex: 2,
                        name: "Dumbbell Pullovers",
                        sets: SetScheme.lastSetAmrap(1, reps: 6)
                    ),
                    Exercise(
                        exerciseIndex: 3,
                        name: "Supinated Lat Pulldowns",
                        sets: SetScheme.lastSetAmrap(1, reps: 6)
                    ),
                    Exercise(
                        exerciseIndex: 4,
                        name: "Deadlift",
                        sets: SetScheme.lastSetAmrap(1, reps: 6)
                    )
                ],
                completedDate: nil
            ),
            
            // Day 2: Legs
            TrainingDay(
                dayIndex: 1,
                dayName: "Legs",
                day: [
                    Exercise(
                        exerciseIndex: 0,
                        name: "Squat",
                        sets: SetScheme.lastSetAmrap(1, reps: 8)
                    ),
                    Exercise(
                        exerciseIndex: 1,
                        name: "Abs",
                        sets: SetScheme.lastSetAmrap(1, reps: 8)
                    ),
                    Exercise(
                        exerciseIndex: 2,
                        name: "Calf Raises",
                        sets: SetScheme.lastSetAmrap(1, reps: 8)
                    ),
                    Exercise(
                        exerciseIndex: 3,
                        name: "Hamstring Curls",
                        sets: SetScheme.lastSetAmrap(1, reps: 8)
                    )
                ],
                completedDate: nil
            ),
            
            // Day 3: Shoulders & Arms
            TrainingDay(
                dayIndex: 2,
                dayName: "Shoulders & Arms",
                day: [
                    Exercise(
                        exerciseIndex: 0,
                        name: "Dips",
                        sets: SetScheme.lastSetAmrap(1, reps: 6)
                    ),
                    Exercise(
                        exerciseIndex: 1,
                        name: "Lateral Raises",
                        sets: SetScheme.lastSetAmrap(1, reps: 6)
                    ),
                    Exercise(
                        exerciseIndex: 2,
                        name: "Rear Delt Flyes",
                        sets: SetScheme.lastSetAmrap(1, reps: 6)
                    ),
                    Exercise(
                        exerciseIndex: 3,
                        name: "Barbell Curls",
                        sets: SetScheme.lastSetAmrap(1, reps: 8)
                    ),
                    Exercise(
                        exerciseIndex: 4,
                        name: "Tricep Pushdowns",
                        sets: SetScheme.lastSetAmrap(1, reps: 6)
                    )
                ],
                completedDate: nil
            ),
            
            // Day 4: Legs
            TrainingDay(
                dayIndex: 3,
                dayName: "Legs",
                day: [
                    Exercise(
                        exerciseIndex: 0,
                        name: "Squat",
                        sets: SetScheme.lastSetAmrap(1, reps: 8)
                    ),
                    Exercise(
                        exerciseIndex: 1,
                        name: "Abs",
                        sets: SetScheme.lastSetAmrap(1, reps: 8)
                    ),
                    Exercise(
                        exerciseIndex: 2,
                        name: "Calf Raises",
                        sets: SetScheme.lastSetAmrap(1, reps: 8)
                    ),
                    Exercise(
                        exerciseIndex: 3,
                        name: "Leg Extensions",
                        sets: SetScheme.lastSetAmrap(1, reps: 8)
                    )
                ],
                completedDate: nil
            )
        ]
    }
}
