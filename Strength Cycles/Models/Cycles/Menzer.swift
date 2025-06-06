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
            // Day 1: Chest & Triceps
            TrainingDay(
                day: [
                    Exercise(
                        name: "Bench Press",
                        sets: [
                            ExerciseSet(weight: 135.0, reps: 8),
                            ExerciseSet(weight: 155.0, reps: 6),
                            ExerciseSet(weight: 175.0, reps: 4)
                        ]
                    ),
                    Exercise(
                        name: "Incline Dumbbell Press",
                        sets: [
                            ExerciseSet(weight: 60.0, reps: 8),
                            ExerciseSet(weight: 70.0, reps: 6)
                        ]
                    ),
                    Exercise(
                        name: "Dips",
                        sets: [
                            ExerciseSet(weight: 0.0, reps: 12),
                            ExerciseSet(weight: 25.0, reps: 8)
                        ]
                    ),
                    Exercise(
                        name: "Tricep Pushdowns",
                        sets: [
                            ExerciseSet(weight: 80.0, reps: 10),
                            ExerciseSet(weight: 90.0, reps: 8)
                        ]
                    )
                ],
                completedDate: nil
            ),
            
            // Day 2: Back & Biceps
            TrainingDay(
                day: [
                    Exercise(
                        name: "Deadlift",
                        sets: [
                            ExerciseSet(weight: 185.0, reps: 8),
                            ExerciseSet(weight: 225.0, reps: 5),
                            ExerciseSet(weight: 245.0, reps: 3)
                        ]
                    ),
                    Exercise(
                        name: "Pull-ups",
                        sets: [
                            ExerciseSet(weight: 0.0, reps: 10),
                            ExerciseSet(weight: 0.0, reps: 8),
                            ExerciseSet(weight: 25.0, reps: 6)
                        ]
                    ),
                    Exercise(
                        name: "Barbell Rows",
                        sets: [
                            ExerciseSet(weight: 135.0, reps: 10),
                            ExerciseSet(weight: 155.0, reps: 8)
                        ]
                    ),
                    Exercise(
                        name: "Barbell Curls",
                        sets: [
                            ExerciseSet(weight: 70.0, reps: 10),
                            ExerciseSet(weight: 80.0, reps: 8)
                        ]
                    )
                ],
                completedDate: nil
            ),
            
            // Day 3: Legs
            TrainingDay(
                day: [
                    Exercise(
                        name: "Squats",
                        sets: [
                            ExerciseSet(weight: 185.0, reps: 10),
                            ExerciseSet(weight: 225.0, reps: 8),
                            ExerciseSet(weight: 245.0, reps: 6)
                        ]
                    ),
                    Exercise(
                        name: "Leg Press",
                        sets: [
                            ExerciseSet(weight: 360.0, reps: 12),
                            ExerciseSet(weight: 450.0, reps: 10)
                        ]
                    ),
                    Exercise(
                        name: "Romanian Deadlifts",
                        sets: [
                            ExerciseSet(weight: 135.0, reps: 12),
                            ExerciseSet(weight: 155.0, reps: 10)
                        ]
                    ),
                    Exercise(
                        name: "Calf Raises",
                        sets: [
                            ExerciseSet(weight: 225.0, reps: 15),
                            ExerciseSet(weight: 245.0, reps: 12)
                        ]
                    )
                ],
                completedDate: nil
            ),
            
            // Day 4: Shoulders
            TrainingDay(
                day: [
                    Exercise(
                        name: "Overhead Press",
                        sets: [
                            ExerciseSet(weight: 95.0, reps: 8),
                            ExerciseSet(weight: 115.0, reps: 6),
                            ExerciseSet(weight: 125.0, reps: 4)
                        ]
                    ),
                    Exercise(
                        name: "Lateral Raises",
                        sets: [
                            ExerciseSet(weight: 20.0, reps: 12),
                            ExerciseSet(weight: 25.0, reps: 10)
                        ]
                    ),
                    Exercise(
                        name: "Rear Delt Flyes",
                        sets: [
                            ExerciseSet(weight: 15.0, reps: 15),
                            ExerciseSet(weight: 20.0, reps: 12)
                        ]
                    ),
                    Exercise(
                        name: "Shrugs",
                        sets: [
                            ExerciseSet(weight: 135.0, reps: 12),
                            ExerciseSet(weight: 155.0, reps: 10)
                        ]
                    )
                ],
                completedDate: nil
            )
        ]
    }
}
