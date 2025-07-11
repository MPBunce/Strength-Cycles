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
            // Week 1 - Day 1 (W1.1)
            TrainingDay(
                dayIndex: 0,
                dayName: "Week 1 - Day 1 (W1.1)",
                day: [
                    Exercise(
                        exerciseIndex: 0,
                        name: "Bench Press",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 1,
                        name: "Squat",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 2,
                        name: "Barbell Row",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 3,
                        name: "Bicep Curl",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 4,
                        name: "Tricep Pushdown",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 5,
                        name: "Abs",
                        sets: []
                    )
                ],
                completedDate: nil
            ),
            
            // Week 1 - Day 2 (W1.2)
            TrainingDay(
                dayIndex: 1,
                dayName: "Week 1 - Day 2 (W1.2)",
                day: [
                    Exercise(
                        exerciseIndex: 0,
                        name: "Overhead Press",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 1,
                        name: "Weighted Pullup",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 2,
                        name: "Deadlift",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 3,
                        name: "Lateral Raise",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 4,
                        name: "Rear Delt",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 5,
                        name: "Split Squat",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 6,
                        name: "Abs",
                        sets: []
                    )
                ],
                completedDate: nil
            ),
            
            // Week 1 - Day 3 (W1.1)
            TrainingDay(
                dayIndex: 2,
                dayName: "Week 1 - Day 3 (W1.1)",
                day: [
                    Exercise(
                        exerciseIndex: 0,
                        name: "Bench Press",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 1,
                        name: "Squat",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 2,
                        name: "Barbell Row",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 3,
                        name: "Bicep Curl",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 4,
                        name: "Tricep Pushdown",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 5,
                        name: "Abs",
                        sets: []
                    )
                ],
                completedDate: nil
            ),
            
            // Week 2 - Day 1 (W1.2)
            TrainingDay(
                dayIndex: 3,
                dayName: "Week 2 - Day 1 (W1.2)",
                day: [
                    Exercise(
                        exerciseIndex: 0,
                        name: "Overhead Press",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 1,
                        name: "Weighted Pullup",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 2,
                        name: "Deadlift",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 3,
                        name: "Lateral Raise",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 4,
                        name: "Rear Delt",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 5,
                        name: "Split Squat",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 6,
                        name: "Abs",
                        sets: []
                    )
                ],
                completedDate: nil
            ),
            
            // Week 2 - Day 2 (W1.1)
            TrainingDay(
                dayIndex: 4,
                dayName: "Week 2 - Day 2 (W1.1)",
                day: [
                    Exercise(
                        exerciseIndex: 0,
                        name: "Bench Press",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 1,
                        name: "Squat",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 2,
                        name: "Barbell Row",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 3,
                        name: "Bicep Curl",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 4,
                        name: "Tricep Pushdown",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 5,
                        name: "Abs",
                        sets: []
                    )
                ],
                completedDate: nil
            ),
            
            // Week 2 - Day 3 (W1.2)
            TrainingDay(
                dayIndex: 5,
                dayName: "Week 2 - Day 3 (W1.2)",
                day: [
                    Exercise(
                        exerciseIndex: 0,
                        name: "Overhead Press",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 1,
                        name: "Weighted Pullup",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 2,
                        name: "Deadlift",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 3,
                        name: "Lateral Raise",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 4,
                        name: "Rear Delt",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 5,
                        name: "Split Squat",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 6,
                        name: "Abs",
                        sets: []
                    )
                ],
                completedDate: nil
            )
        ]
    }
}
