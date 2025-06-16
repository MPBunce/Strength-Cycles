//
//  GarciaProgram.swift
//  Strength Cycles
//
//  Created by Matthew Bunce on 2025-06-15.
//

import Foundation
import SwiftData

@Model
class GarciaProgram: ProgramProtocol {
    var trainingDays: [TrainingDay]
    
    func copyTrainingDays() -> [TrainingDay] {
        return trainingDays.map { $0.copy() }
    }
    
    init() {
        self.trainingDays = [
            // Day 1: A
            TrainingDay(
                dayIndex: 0,
                dayName: "Day A",
                day: [
                    Exercise(
                        exerciseIndex: 0,
                        name: "Weighted Pull Ups",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 1,
                        name: "Bench Press",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 2,
                        name: "Squat",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 3,
                        name: "Close Grip Bench Press",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 4,
                        name: "EZ Bar Curls",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 5,
                        name: "Barbell Row",
                        sets: []
                    )
                ],
                completedDate: nil
            ),
            
            // Day 2: B
            TrainingDay(
                dayIndex: 1,
                dayName: "Day B",
                day: [
                    Exercise(
                        exerciseIndex: 0,
                        name: "Weighted Dips",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 1,
                        name: "Overhead Press",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 2,
                        name: "Deadlift",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 3,
                        name: "Lateral Raises",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 4,
                        name: "Rear Delt Flys",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 5,
                        name: "Skullcrushers",
                        sets: []
                    )
                ],
                completedDate: nil
            ),
            
            // Day 3: A
            TrainingDay(
                dayIndex: 2,
                dayName: "Day A",
                day: [
                    Exercise(
                        exerciseIndex: 0,
                        name: "Weighted Pull Ups",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 1,
                        name: "Bench Press",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 2,
                        name: "Squat",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 3,
                        name: "Close Grip Bench Press",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 4,
                        name: "EZ Bar Curls",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 5,
                        name: "Barbell Row",
                        sets: []
                    )
                ],
                completedDate: nil
            ),
            
            // Day 4: B
            TrainingDay(
                dayIndex: 3,
                dayName: "Day B",
                day: [
                    Exercise(
                        exerciseIndex: 0,
                        name: "Weighted Dips",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 1,
                        name: "Overhead Press",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 2,
                        name: "Deadlift",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 3,
                        name: "Lateral Raises",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 4,
                        name: "Rear Delt Flys",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 5,
                        name: "Skullcrushers",
                        sets: []
                    )
                ],
                completedDate: nil
            ),
            
            // Day 5: A
            TrainingDay(
                dayIndex: 4,
                dayName: "Day A",
                day: [
                    Exercise(
                        exerciseIndex: 0,
                        name: "Weighted Pull Ups",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 1,
                        name: "Bench Press",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 2,
                        name: "Squat",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 3,
                        name: "Close Grip Bench Press",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 4,
                        name: "EZ Bar Curls",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 5,
                        name: "Barbell Row",
                        sets: []
                    )
                ],
                completedDate: nil
            ),
            
            // Day 6: B
            TrainingDay(
                dayIndex: 5,
                dayName: "Day B",
                day: [
                    Exercise(
                        exerciseIndex: 0,
                        name: "Weighted Dips",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 1,
                        name: "Overhead Press",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 2,
                        name: "Deadlift",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 3,
                        name: "Lateral Raises",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 4,
                        name: "Rear Delt Flys",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 5,
                        name: "Skullcrushers",
                        sets: []
                    )
                ],
                completedDate: nil
            )
        ]
    }
}
