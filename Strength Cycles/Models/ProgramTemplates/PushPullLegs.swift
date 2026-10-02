//
//  PushPullLegs.swift
//  Strength Cycles
//
//  Created by Matthew Bunce on 2025-06-06.
//

import SwiftData

@Model
class PPLProgram: ProgramProtocol {
    var trainingDays: [TrainingDay]
    
    func copyTrainingDays() -> [TrainingDay] {
        return trainingDays.map { $0.copy() }
    }
    
    init() {
        self.trainingDays = [
            TrainingDay(
                dayIndex: 0,
                dayName: "Push",
                day: [
                    Exercise(exerciseIndex: 0, name: "Bench Press", sets: SetScheme.straight(4, reps: 6)),
                    Exercise(exerciseIndex: 1, name: "Overhead Press", sets: SetScheme.straight(4, reps: 6)),
                    Exercise(exerciseIndex: 2, name: "Incline Dumbbell Press", sets: SetScheme.straight(3, reps: 8)),
                    Exercise(exerciseIndex: 3, name: "Tricep Pushdowns", sets: SetScheme.straight(3, reps: 12)),
                    Exercise(exerciseIndex: 4, name: "Lateral Raises", sets: SetScheme.straight(3, reps: 15)),
                    Exercise(exerciseIndex: 5, name: "Front Raises", sets: SetScheme.straight(3, reps: 15))
                ],
                completedDate: nil
            ),
            TrainingDay(
                dayIndex: 1,
                dayName: "Pull",
                day: [
                    Exercise(exerciseIndex: 0, name: "Deadlift", sets: SetScheme.straight(3, reps: 5)),
                    Exercise(exerciseIndex: 1, name: "Pull-ups", sets: SetScheme.straight(3, reps: 8)),
                    Exercise(exerciseIndex: 2, name: "Barbell Rows", sets: SetScheme.straight(3, reps: 8)),
                    Exercise(exerciseIndex: 3, name: "Barbell Curls", sets: SetScheme.straight(3, reps: 12)),
                    Exercise(exerciseIndex: 4, name: "Rear Delt Flys", sets: SetScheme.straight(3, reps: 15))
                ],
                completedDate: nil
            ),
            TrainingDay(
                dayIndex: 2,
                dayName: "Legs",
                day: [
                    Exercise(exerciseIndex: 0, name: "Squat", sets: SetScheme.straight(4, reps: 6)),
                    Exercise(exerciseIndex: 1, name: "Romanian Deadlift", sets: SetScheme.straight(3, reps: 8)),
                    Exercise(exerciseIndex: 2, name: "Leg Press", sets: SetScheme.straight(3, reps: 10)),
                    Exercise(exerciseIndex: 3, name: "Leg Curls", sets: SetScheme.straight(3, reps: 12)),
                    Exercise(exerciseIndex: 4, name: "Calf Raises", sets: SetScheme.straight(4, reps: 12)),
                    Exercise(exerciseIndex: 5, name: "Abs", sets: SetScheme.straight(3, reps: 15))
                ],
                completedDate: nil
            )
        ]
    }
}
