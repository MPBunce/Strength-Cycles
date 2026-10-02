//
//  UpperLower.swift
//  Strength Cycles
//
//  Created by Matthew Bunce on 2025-06-10.
//
import SwiftData

@Model
class UpperLowerProgram: ProgramProtocol {
    var trainingDays: [TrainingDay]
    
    func copyTrainingDays() -> [TrainingDay] {
        return trainingDays.map { $0.copy() }
    }
    
    init() {
        self.trainingDays = [
            TrainingDay(
                dayIndex: 0,
                dayName: "Upper Body",
                day: [
                    Exercise(exerciseIndex: 0, name: "Bench Press", sets: SetScheme.straight(4, reps: 6)),
                    Exercise(exerciseIndex: 1, name: "Barbell Rows", sets: SetScheme.straight(3, reps: 8)),
                    Exercise(exerciseIndex: 2, name: "Overhead Press", sets: SetScheme.straight(4, reps: 6)),
                    Exercise(exerciseIndex: 3, name: "Pull-ups", sets: SetScheme.straight(3, reps: 8)),
                    Exercise(exerciseIndex: 4, name: "Barbell Curls", sets: SetScheme.straight(3, reps: 12)),
                    Exercise(exerciseIndex: 5, name: "Tricep Extensions", sets: SetScheme.straight(3, reps: 12))
                ],
                completedDate: nil
            ),
            TrainingDay(
                dayIndex: 1,
                dayName: "Lower Body",
                day: [
                    Exercise(exerciseIndex: 0, name: "Squat", sets: SetScheme.straight(4, reps: 6)),
                    Exercise(exerciseIndex: 1, name: "Romanian Deadlift", sets: SetScheme.straight(3, reps: 8)),
                    Exercise(exerciseIndex: 2, name: "Leg Press", sets: SetScheme.straight(3, reps: 10)),
                    Exercise(exerciseIndex: 3, name: "Abs", sets: SetScheme.straight(3, reps: 15)),
                    Exercise(exerciseIndex: 4, name: "Calf Raises", sets: SetScheme.straight(4, reps: 12))
                ],
                completedDate: nil
            ),
            TrainingDay(
                dayIndex: 2,
                dayName: "Upper Body",
                day: [
                    Exercise(exerciseIndex: 0, name: "Incline Dumbbell Press", sets: SetScheme.straight(3, reps: 8)),
                    Exercise(exerciseIndex: 1, name: "Cable Rows", sets: SetScheme.straight(3, reps: 8)),
                    Exercise(exerciseIndex: 2, name: "Dumbbell Press", sets: SetScheme.straight(3, reps: 8)),
                    Exercise(exerciseIndex: 3, name: "Lat Pulldowns", sets: SetScheme.straight(3, reps: 8)),
                    Exercise(exerciseIndex: 4, name: "Hammer Curls", sets: SetScheme.straight(3, reps: 12)),
                    Exercise(exerciseIndex: 5, name: "Overhead Tricep Extension", sets: SetScheme.straight(3, reps: 12))
                ],
                completedDate: nil
            ),
            TrainingDay(
                dayIndex: 3,
                dayName: "Lower Body",
                day: [
                    Exercise(exerciseIndex: 0, name: "Deadlift", sets: SetScheme.straight(3, reps: 5)),
                    Exercise(exerciseIndex: 1, name: "Front Squat", sets: SetScheme.straight(4, reps: 6)),
                    Exercise(exerciseIndex: 2, name: "Walking Lunges", sets: SetScheme.straight(3, reps: 10)),
                    Exercise(exerciseIndex: 3, name: "Abs", sets: SetScheme.straight(3, reps: 15)),
                    Exercise(exerciseIndex: 4, name: "Seated Calf Raises", sets: SetScheme.straight(4, reps: 12))
                ],
                completedDate: nil
            )
        ]
    }
}
