//
//  GreyskullLPProgram.swift
//  Strength Cycles
//
//  Created by Matthew Bunce on 2025-06-15.
//

import Foundation
import SwiftData

@Model
class GreyskullLPProgram: ProgramProtocol {
    var trainingDays: [TrainingDay]
    
    func copyTrainingDays() -> [TrainingDay] {
        return trainingDays.map { $0.copy() }
    }
    
    init() {
        self.trainingDays = [
            // Week 1 - Day 1 (Workout A)
            TrainingDay(
                dayIndex: 0,
                dayName: "Week 1 - Day 1 (A)",
                day: [
                    Exercise(
                        exerciseIndex: 0,
                        name: "Bench Press",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 1,
                        name: "Bent Over Row",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 2,
                        name: "Squat",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 3,
                        name: "Barbell Curls",
                        sets: []
                    )
                ],
                completedDate: nil
            ),
            
            // Week 1 - Day 2 (Workout B)
            TrainingDay(
                dayIndex: 1,
                dayName: "Week 1 - Day 2 (B)",
                day: [
                    Exercise(
                        exerciseIndex: 0,
                        name: "Overhead Press",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 1,
                        name: "Chin-ups",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 2,
                        name: "Deadlift",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 3,
                        name: "Close Grip Bench Press",
                        sets: []
                    )
                ],
                completedDate: nil
            ),
            
            // Week 1 - Day 3 (Workout A)
            TrainingDay(
                dayIndex: 2,
                dayName: "Week 1 - Day 3 (A)",
                day: [
                    Exercise(
                        exerciseIndex: 0,
                        name: "Bench Press",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 1,
                        name: "Bent Over Row",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 2,
                        name: "Squat",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 3,
                        name: "Barbell Curls",
                        sets: []
                    )
                ],
                completedDate: nil
            ),
            
            // Week 2 - Day 1 (Workout B)
            TrainingDay(
                dayIndex: 3,
                dayName: "Week 2 - Day 1 (B)",
                day: [
                    Exercise(
                        exerciseIndex: 0,
                        name: "Overhead Press",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 1,
                        name: "Chin-ups",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 2,
                        name: "Deadlift",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 3,
                        name: "Close Grip Bench Press",
                        sets: []
                    )
                ],
                completedDate: nil
            ),
            
            // Week 2 - Day 2 (Workout A)
            TrainingDay(
                dayIndex: 4,
                dayName: "Week 2 - Day 2 (A)",
                day: [
                    Exercise(
                        exerciseIndex: 0,
                        name: "Bench Press",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 1,
                        name: "Bent Over Row",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 2,
                        name: "Squat",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 3,
                        name: "Barbell Curls",
                        sets: []
                    )
                ],
                completedDate: nil
            ),
            
            // Week 2 - Day 3 (Workout B)
            TrainingDay(
                dayIndex: 5,
                dayName: "Week 2 - Day 3 (B)",
                day: [
                    Exercise(
                        exerciseIndex: 0,
                        name: "Overhead Press",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 1,
                        name: "Chin-ups",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 2,
                        name: "Deadlift",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 3,
                        name: "Close Grip Bench Press",
                        sets: []
                    )
                ],
                completedDate: nil
            )
        ]
    }
}
