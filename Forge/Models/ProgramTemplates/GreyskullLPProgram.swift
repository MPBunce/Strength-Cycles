//
//  GreyskullLPProgram.swift
//  Forge
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
                        sets: SetScheme.lastSetAmrap(3, reps: 5)
                    ),
                    Exercise(
                        exerciseIndex: 1,
                        name: "Squat",
                        sets: SetScheme.lastSetAmrap(3, reps: 5)
                    ),
                    Exercise(
                        exerciseIndex: 2,
                        name: "Barbell Row",
                        sets: SetScheme.lastSetAmrap(3, reps: 5)
                    ),
                    Exercise(
                        exerciseIndex: 3,
                        name: "Bicep Curl",
                        sets: SetScheme.straight(3, reps: 12)
                    ),
                    Exercise(
                        exerciseIndex: 4,
                        name: "Tricep Pushdown",
                        sets: SetScheme.straight(3, reps: 12)
                    ),
                    Exercise(
                        exerciseIndex: 5,
                        name: "Abs",
                        sets: SetScheme.straight(3, reps: 15)
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
                        sets: SetScheme.lastSetAmrap(3, reps: 5)
                    ),
                    Exercise(
                        exerciseIndex: 1,
                        name: "Weighted Pullup",
                        sets: SetScheme.lastSetAmrap(3, reps: 5)
                    ),
                    Exercise(
                        exerciseIndex: 2,
                        name: "Deadlift",
                        sets: SetScheme.lastSetAmrap(1, reps: 5)
                    ),
                    Exercise(
                        exerciseIndex: 3,
                        name: "Lateral Raise",
                        sets: SetScheme.straight(3, reps: 15)
                    ),
                    Exercise(
                        exerciseIndex: 4,
                        name: "Rear Delt",
                        sets: SetScheme.straight(3, reps: 15)
                    ),
                    Exercise(
                        exerciseIndex: 5,
                        name: "Split Squat",
                        sets: SetScheme.straight(3, reps: 10)
                    ),
                    Exercise(
                        exerciseIndex: 6,
                        name: "Abs",
                        sets: SetScheme.straight(3, reps: 15)
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
                        sets: SetScheme.lastSetAmrap(3, reps: 5)
                    ),
                    Exercise(
                        exerciseIndex: 1,
                        name: "Squat",
                        sets: SetScheme.lastSetAmrap(3, reps: 5)
                    ),
                    Exercise(
                        exerciseIndex: 2,
                        name: "Barbell Row",
                        sets: SetScheme.lastSetAmrap(3, reps: 5)
                    ),
                    Exercise(
                        exerciseIndex: 3,
                        name: "Bicep Curl",
                        sets: SetScheme.straight(3, reps: 12)
                    ),
                    Exercise(
                        exerciseIndex: 4,
                        name: "Tricep Pushdown",
                        sets: SetScheme.straight(3, reps: 12)
                    ),
                    Exercise(
                        exerciseIndex: 5,
                        name: "Abs",
                        sets: SetScheme.straight(3, reps: 15)
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
                        sets: SetScheme.lastSetAmrap(3, reps: 5)
                    ),
                    Exercise(
                        exerciseIndex: 1,
                        name: "Weighted Pullup",
                        sets: SetScheme.lastSetAmrap(3, reps: 5)
                    ),
                    Exercise(
                        exerciseIndex: 2,
                        name: "Deadlift",
                        sets: SetScheme.lastSetAmrap(1, reps: 5)
                    ),
                    Exercise(
                        exerciseIndex: 3,
                        name: "Lateral Raise",
                        sets: SetScheme.straight(3, reps: 15)
                    ),
                    Exercise(
                        exerciseIndex: 4,
                        name: "Rear Delt",
                        sets: SetScheme.straight(3, reps: 15)
                    ),
                    Exercise(
                        exerciseIndex: 5,
                        name: "Split Squat",
                        sets: SetScheme.straight(3, reps: 10)
                    ),
                    Exercise(
                        exerciseIndex: 6,
                        name: "Abs",
                        sets: SetScheme.straight(3, reps: 15)
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
                        sets: SetScheme.lastSetAmrap(3, reps: 5)
                    ),
                    Exercise(
                        exerciseIndex: 1,
                        name: "Squat",
                        sets: SetScheme.lastSetAmrap(3, reps: 5)
                    ),
                    Exercise(
                        exerciseIndex: 2,
                        name: "Barbell Row",
                        sets: SetScheme.lastSetAmrap(3, reps: 5)
                    ),
                    Exercise(
                        exerciseIndex: 3,
                        name: "Bicep Curl",
                        sets: SetScheme.straight(3, reps: 12)
                    ),
                    Exercise(
                        exerciseIndex: 4,
                        name: "Tricep Pushdown",
                        sets: SetScheme.straight(3, reps: 12)
                    ),
                    Exercise(
                        exerciseIndex: 5,
                        name: "Abs",
                        sets: SetScheme.straight(3, reps: 15)
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
                        sets: SetScheme.lastSetAmrap(3, reps: 5)
                    ),
                    Exercise(
                        exerciseIndex: 1,
                        name: "Weighted Pullup",
                        sets: SetScheme.lastSetAmrap(3, reps: 5)
                    ),
                    Exercise(
                        exerciseIndex: 2,
                        name: "Deadlift",
                        sets: SetScheme.lastSetAmrap(1, reps: 5)
                    ),
                    Exercise(
                        exerciseIndex: 3,
                        name: "Lateral Raise",
                        sets: SetScheme.straight(3, reps: 15)
                    ),
                    Exercise(
                        exerciseIndex: 4,
                        name: "Rear Delt",
                        sets: SetScheme.straight(3, reps: 15)
                    ),
                    Exercise(
                        exerciseIndex: 5,
                        name: "Split Squat",
                        sets: SetScheme.straight(3, reps: 10)
                    ),
                    Exercise(
                        exerciseIndex: 6,
                        name: "Abs",
                        sets: SetScheme.straight(3, reps: 15)
                    )
                ],
                completedDate: nil
            )
        ]
    }
}
