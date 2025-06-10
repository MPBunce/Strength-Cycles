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
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 1,
                        name: "Incline Dumbbell Press",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 2,
                        name: "Dumbbell Pullovers",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 3,
                        name: "Supinated Lat Pulldowns",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 4,
                        name: "Deadlift",
                        sets: []
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
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 1,
                        name: "Abs",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 2,
                        name: "Calf Raises",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 3,
                        name: "Hamstring Curls",
                        sets: []
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
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 1,
                        name: "Lateral Raises",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 2,
                        name: "Rear Delt Flyes",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 3,
                        name: "Barbell Curls",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 4,
                        name: "Tricep Pushdowns",
                        sets: []
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
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 1,
                        name: "Abs",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 2,
                        name: "Calf Raises",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 3,
                        name: "Leg Extensions",
                        sets: []
                    )
                ],
                completedDate: nil
            )
        ]
    }
}
