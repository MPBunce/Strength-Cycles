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
                        sets: SetScheme.straight(3, reps: 5)
                    ),
                    Exercise(
                        exerciseIndex: 1,
                        name: "Bench Press",
                        sets: SetScheme.straight(3, reps: 5)
                    ),
                    Exercise(
                        exerciseIndex: 2,
                        name: "Squat",
                        sets: SetScheme.straight(3, reps: 5)
                    ),
                    Exercise(
                        exerciseIndex: 3,
                        name: "Close Grip Bench Press",
                        sets: SetScheme.straight(4, reps: 6)
                    ),
                    Exercise(
                        exerciseIndex: 4,
                        name: "EZ Bar Curls",
                        sets: SetScheme.straight(3, reps: 12)
                    ),
                    Exercise(
                        exerciseIndex: 5,
                        name: "Barbell Row",
                        sets: SetScheme.straight(3, reps: 5)
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
                        sets: SetScheme.straight(3, reps: 5)
                    ),
                    Exercise(
                        exerciseIndex: 1,
                        name: "Overhead Press",
                        sets: SetScheme.straight(3, reps: 5)
                    ),
                    Exercise(
                        exerciseIndex: 2,
                        name: "Deadlift",
                        sets: SetScheme.straight(1, reps: 5)
                    ),
                    Exercise(
                        exerciseIndex: 3,
                        name: "Lateral Raises",
                        sets: SetScheme.straight(3, reps: 15)
                    ),
                    Exercise(
                        exerciseIndex: 4,
                        name: "Rear Delt Flys",
                        sets: SetScheme.straight(3, reps: 15)
                    ),
                    Exercise(
                        exerciseIndex: 5,
                        name: "Skullcrushers",
                        sets: SetScheme.straight(3, reps: 12)
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
                        sets: SetScheme.straight(3, reps: 5)
                    ),
                    Exercise(
                        exerciseIndex: 1,
                        name: "Bench Press",
                        sets: SetScheme.straight(3, reps: 5)
                    ),
                    Exercise(
                        exerciseIndex: 2,
                        name: "Squat",
                        sets: SetScheme.straight(3, reps: 5)
                    ),
                    Exercise(
                        exerciseIndex: 3,
                        name: "Close Grip Bench Press",
                        sets: SetScheme.straight(4, reps: 6)
                    ),
                    Exercise(
                        exerciseIndex: 4,
                        name: "EZ Bar Curls",
                        sets: SetScheme.straight(3, reps: 12)
                    ),
                    Exercise(
                        exerciseIndex: 5,
                        name: "Barbell Row",
                        sets: SetScheme.straight(3, reps: 5)
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
                        sets: SetScheme.straight(3, reps: 5)
                    ),
                    Exercise(
                        exerciseIndex: 1,
                        name: "Overhead Press",
                        sets: SetScheme.straight(3, reps: 5)
                    ),
                    Exercise(
                        exerciseIndex: 2,
                        name: "Deadlift",
                        sets: SetScheme.straight(1, reps: 5)
                    ),
                    Exercise(
                        exerciseIndex: 3,
                        name: "Lateral Raises",
                        sets: SetScheme.straight(3, reps: 15)
                    ),
                    Exercise(
                        exerciseIndex: 4,
                        name: "Rear Delt Flys",
                        sets: SetScheme.straight(3, reps: 15)
                    ),
                    Exercise(
                        exerciseIndex: 5,
                        name: "Skullcrushers",
                        sets: SetScheme.straight(3, reps: 12)
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
                        sets: SetScheme.straight(3, reps: 5)
                    ),
                    Exercise(
                        exerciseIndex: 1,
                        name: "Bench Press",
                        sets: SetScheme.straight(3, reps: 5)
                    ),
                    Exercise(
                        exerciseIndex: 2,
                        name: "Squat",
                        sets: SetScheme.straight(3, reps: 5)
                    ),
                    Exercise(
                        exerciseIndex: 3,
                        name: "Close Grip Bench Press",
                        sets: SetScheme.straight(4, reps: 6)
                    ),
                    Exercise(
                        exerciseIndex: 4,
                        name: "EZ Bar Curls",
                        sets: SetScheme.straight(3, reps: 12)
                    ),
                    Exercise(
                        exerciseIndex: 5,
                        name: "Barbell Row",
                        sets: SetScheme.straight(3, reps: 5)
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
                        sets: SetScheme.straight(3, reps: 5)
                    ),
                    Exercise(
                        exerciseIndex: 1,
                        name: "Overhead Press",
                        sets: SetScheme.straight(3, reps: 5)
                    ),
                    Exercise(
                        exerciseIndex: 2,
                        name: "Deadlift",
                        sets: SetScheme.straight(1, reps: 5)
                    ),
                    Exercise(
                        exerciseIndex: 3,
                        name: "Lateral Raises",
                        sets: SetScheme.straight(3, reps: 15)
                    ),
                    Exercise(
                        exerciseIndex: 4,
                        name: "Rear Delt Flys",
                        sets: SetScheme.straight(3, reps: 15)
                    ),
                    Exercise(
                        exerciseIndex: 5,
                        name: "Skullcrushers",
                        sets: SetScheme.straight(3, reps: 12)
                    )
                ],
                completedDate: nil
            )
        ]
    }
}
