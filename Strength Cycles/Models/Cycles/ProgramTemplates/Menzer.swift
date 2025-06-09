//
//  ModernMenzer.swift
//  Strength Cycles
//
//  Created by Matthew Bunce on 2025-06-06.
//

import Foundation
import SwiftData

@Model
class MenzerProgram {
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
                        sets: [
                            ExerciseSet(setIndex: 0),
                            ExerciseSet(setIndex: 1)
                        ]
                    ),
                    Exercise(
                        exerciseIndex: 1,
                        name: "Incline Dumbbell Press",
                        sets: [
                            ExerciseSet(setIndex: 0),
                            ExerciseSet(setIndex: 1)
                        ]
                    ),
                    Exercise(
                        exerciseIndex: 2,
                        name: "Dumbbell Pullovers",
                        sets: [
                            ExerciseSet(setIndex: 0),
                            ExerciseSet(setIndex: 1)
                        ]
                    ),
                    Exercise(
                        exerciseIndex: 3,
                        name: "Supinated Lat Pulldowns",
                        sets: [
                            ExerciseSet(setIndex: 0),
                            ExerciseSet(setIndex: 1)
                        ]
                    ),
                    Exercise(
                        exerciseIndex: 4,
                        name: "Deadlift",
                        sets: [
                            ExerciseSet(setIndex: 0),
                            ExerciseSet(setIndex: 1),
                            ExerciseSet(setIndex: 2)
                        ]
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
                        name: "Barbell Squat",
                        sets: [
                            ExerciseSet(setIndex: 0),
                            ExerciseSet(setIndex: 1),
                            ExerciseSet(setIndex: 2)
                        ]
                    ),
                    Exercise(
                        exerciseIndex: 1,
                        name: "Abs",
                        sets: [
                            ExerciseSet(setIndex: 0),
                            ExerciseSet(setIndex: 1)
                        ]
                    ),
                    Exercise(
                        exerciseIndex: 2,
                        name: "Calf Raises",
                        sets: [
                            ExerciseSet(setIndex: 0),
                            ExerciseSet(setIndex: 1)
                        ]
                    ),
                    Exercise(
                        exerciseIndex: 3,
                        name: "Hamstring Curls",
                        sets: [
                            ExerciseSet(setIndex: 0),
                            ExerciseSet(setIndex: 1)
                        ]
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
                        sets: [
                            ExerciseSet(setIndex: 0),
                            ExerciseSet(setIndex: 1)
                        ]
                    ),
                    Exercise(
                        exerciseIndex: 1,
                        name: "Lateral Raises",
                        sets: [
                            ExerciseSet(setIndex: 0),
                            ExerciseSet(setIndex: 1)
                        ]
                    ),
                    Exercise(
                        exerciseIndex: 2,
                        name: "Rear Delt Flyes",
                        sets: [
                            ExerciseSet(setIndex: 0),
                            ExerciseSet(setIndex: 1)
                        ]
                    ),
                    Exercise(
                        exerciseIndex: 3,
                        name: "Barbell Curls",
                        sets: [
                            ExerciseSet(setIndex: 0),
                            ExerciseSet(setIndex: 1)
                        ]
                    ),
                    Exercise(
                        exerciseIndex: 4,
                        name: "Tricep Pushdowns",
                        sets: [
                            ExerciseSet(setIndex: 0),
                            ExerciseSet(setIndex: 1)
                        ]
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
                        name: "Barbell Squat",
                        sets: [
                            ExerciseSet(setIndex: 0),
                            ExerciseSet(setIndex: 1),
                            ExerciseSet(setIndex: 2)
                        ]
                    ),
                    Exercise(
                        exerciseIndex: 1,
                        name: "Abs",
                        sets: [
                            ExerciseSet(setIndex: 0),
                            ExerciseSet(setIndex: 1)
                        ]
                    ),
                    Exercise(
                        exerciseIndex: 2,
                        name: "Calf Raises",
                        sets: [
                            ExerciseSet(setIndex: 0),
                            ExerciseSet(setIndex: 1)
                        ]
                    ),
                    Exercise(
                        exerciseIndex: 3,
                        name: "Leg Extensions",
                        sets: [
                            ExerciseSet(setIndex: 0),
                            ExerciseSet(setIndex: 1)
                        ]
                    )
                ],
                completedDate: nil
            )
        ]
    }
}
