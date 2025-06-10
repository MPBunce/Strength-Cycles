//
//  nSuns4Day.swift
//  Strength Cycles
//
//  Created by Matthew Bunce on 2025-06-09.
//


import SwiftData

@Model
class nSunsFourDayProgram: ProgramProtocol {
    var trainingDays: [TrainingDay]
    var benchTM: Double
    var squatTM: Double
    var deadliftTM: Double
    var ohpTM: Double
    
    func copyTrainingDays() -> [TrainingDay] {
        return trainingDays.map { $0.copy() }
    }
    
    init(benchTM: Double, squatTM: Double, deadliftTM: Double, ohpTM: Double) {
        self.benchTM = benchTM
        self.squatTM = squatTM
        self.deadliftTM = deadliftTM
        self.ohpTM = ohpTM
        
        self.trainingDays = [
            // Monday: Bench + OHP
            TrainingDay(
                dayIndex: 0,
                dayName: "Monday - Bench + OHP",
                day: [
                    Exercise(
                        exerciseIndex: 0,
                        name: "Bench Press",
                        sets: createMondayBenchSets(tm: benchTM)
                    ),
                    Exercise(
                        exerciseIndex: 1,
                        name: "Overhead Press",
                        sets: createMondayOHPSets(tm: ohpTM)
                    ),
                    Exercise(
                        exerciseIndex: 2,
                        name: "Chest Assistance",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 3,
                        name: "Arms Assistance",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 4,
                        name: "Back Assistance",
                        sets: []
                    )
                ],
                completedDate: nil
            ),
            
            // Tuesday: Squat + Sumo Deadlift
            TrainingDay(
                dayIndex: 1,
                dayName: "Tuesday - Squat + Sumo Deadlift",
                day: [
                    Exercise(
                        exerciseIndex: 0,
                        name: "Squat",
                        sets: createTuesdaySquatSets(tm: squatTM)
                    ),
                    Exercise(
                        exerciseIndex: 1,
                        name: "Sumo Deadlift",
                        sets: createTuesdaySumoSets(tm: deadliftTM)
                    ),
                    Exercise(
                        exerciseIndex: 2,
                        name: "Legs Assistance",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 3,
                        name: "Abs",
                        sets: []
                    )
                ],
                completedDate: nil
            ),
            
            // Thursday: Bench + Close Grip Bench
            TrainingDay(
                dayIndex: 2,
                dayName: "Thursday - Bench + Close Grip Bench",
                day: [
                    Exercise(
                        exerciseIndex: 0,
                        name: "Bench Press",
                        sets: createThursdayBenchSets(tm: benchTM)
                    ),
                    Exercise(
                        exerciseIndex: 1,
                        name: "Close Grip Bench Press",
                        sets: createThursdayCloseBenchSets(tm: benchTM)
                    ),
                    Exercise(
                        exerciseIndex: 2,
                        name: "Arms Assistance",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 3,
                        name: "Misc Assistance",
                        sets: []
                    )
                ],
                completedDate: nil
            ),
            
            // Friday: Deadlift + Front Squat
            TrainingDay(
                dayIndex: 3,
                dayName: "Friday - Deadlift + Front Squat",
                day: [
                    Exercise(
                        exerciseIndex: 0,
                        name: "Deadlift",
                        sets: createFridayDeadliftSets(tm: deadliftTM)
                    ),
                    Exercise(
                        exerciseIndex: 1,
                        name: "Front Squat",
                        sets: createFridayFrontSquatSets(tm: squatTM)
                    ),
                    Exercise(
                        exerciseIndex: 2,
                        name: "Back Assistance",
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 3,
                        name: "Abs",
                        sets: []
                    )
                ],
                completedDate: nil
            )
        ]
    }
}

// MARK: - Monday Sets (Bench + OHP)

private func createMondayBenchSets(tm: Double) -> [ExerciseSet] {
    // 60x8, 70x6, 75x4, 75x4, 75x4, 70x5, 70x6, 65x7, 60x8+
    let percentages = [0.60, 0.70, 0.75, 0.75, 0.75, 0.70, 0.70, 0.65, 0.60]
    let reps = [8, 6, 4, 4, 4, 5, 6, 7, 8]
    
    return zip(percentages, reps).enumerated().map { index, data in
        let (percentage, repCount) = data
        return createExerciseSet(
            setIndex: index,
            reps: repCount,
            weight: tm * percentage
        )
    }
}

private func createMondayOHPSets(tm: Double) -> [ExerciseSet] {
    // 45x6, 55x5, 65x3, 65x5, 65x7, 65x4, 65x6, 65x8
    let percentages = [0.45, 0.55, 0.65, 0.65, 0.65, 0.65, 0.65, 0.65]
    let reps = [6, 5, 3, 5, 7, 4, 6, 8]
    
    return zip(percentages, reps).enumerated().map { index, data in
        let (percentage, repCount) = data
        return createExerciseSet(
            setIndex: index,
            reps: repCount,
            weight: tm * percentage
        )
    }
}

// MARK: - Tuesday Sets (Squat + Sumo Deadlift)

private func createTuesdaySquatSets(tm: Double) -> [ExerciseSet] {
    // 70x5, 75x3, 85x1+, 80x3, 75x3, 70x3, 70x5, 65x5, 60x5+
    let percentages = [0.70, 0.75, 0.85, 0.80, 0.75, 0.70, 0.70, 0.65, 0.60]
    let reps = [5, 3, 1, 3, 3, 3, 5, 5, 5]
    
    return zip(percentages, reps).enumerated().map { index, data in
        let (percentage, repCount) = data
        return createExerciseSet(
            setIndex: index,
            reps: repCount,
            weight: tm * percentage
        )
    }
}

private func createTuesdaySumoSets(tm: Double) -> [ExerciseSet] {
    // 45x5, 55x5, 65x3, 65x5, 65x7, 65x4, 65x6, 65x8
    let percentages = [0.45, 0.55, 0.65, 0.65, 0.65, 0.65, 0.65, 0.65]
    let reps = [5, 5, 3, 5, 7, 4, 6, 8]
    
    return zip(percentages, reps).enumerated().map { index, data in
        let (percentage, repCount) = data
        return createExerciseSet(
            setIndex: index,
            reps: repCount,
            weight: tm * percentage
        )
    }
}

// MARK: - Thursday Sets (Bench + Close Grip Bench)

private func createThursdayBenchSets(tm: Double) -> [ExerciseSet] {
    // 70x5, 75x3, 85x1+, 80x3, 75x5, 70x3, 70x5, 65x3, 60x5+
    let percentages = [0.70, 0.75, 0.85, 0.80, 0.75, 0.70, 0.70, 0.65, 0.60]
    let reps = [5, 3, 1, 3, 5, 3, 5, 3, 5]
    
    return zip(percentages, reps).enumerated().map { index, data in
        let (percentage, repCount) = data
        return createExerciseSet(
            setIndex: index,
            reps: repCount,
            weight: tm * percentage
        )
    }
}

private func createThursdayCloseBenchSets(tm: Double) -> [ExerciseSet] {
    // 35x6, 45x5, 55x3, 55x5, 55x7, 55x4, 55x6, 55x8
    let percentages = [0.35, 0.45, 0.55, 0.55, 0.55, 0.55, 0.55, 0.55]
    let reps = [6, 5, 3, 5, 7, 4, 6, 8]
    
    return zip(percentages, reps).enumerated().map { index, data in
        let (percentage, repCount) = data
        return createExerciseSet(
            setIndex: index,
            reps: repCount,
            weight: tm * percentage
        )
    }
}

// MARK: - Friday Sets (Deadlift + Front Squat)

private func createFridayDeadliftSets(tm: Double) -> [ExerciseSet] {
    // 70x5, 75x3, 85x1+, 80x3, 75x3, 70x3, 70x3, 65x3, 60x3+
    let percentages = [0.70, 0.75, 0.85, 0.80, 0.75, 0.70, 0.70, 0.65, 0.60]
    let reps = [5, 3, 1, 3, 3, 3, 3, 3, 3]
    
    return zip(percentages, reps).enumerated().map { index, data in
        let (percentage, repCount) = data
        return createExerciseSet(
            setIndex: index,
            reps: repCount,
            weight: tm * percentage
        )
    }
}

private func createFridayFrontSquatSets(tm: Double) -> [ExerciseSet] {
    // 30x5, 40x5, 50x3, 50x5, 50x7, 50x4, 50x6, 50x8
    let percentages = [0.30, 0.40, 0.50, 0.50, 0.50, 0.50, 0.50, 0.50]
    let reps = [5, 5, 3, 5, 7, 4, 6, 8]
    
    return zip(percentages, reps).enumerated().map { index, data in
        let (percentage, repCount) = data
        return createExerciseSet(
            setIndex: index,
            reps: repCount,
            weight: tm * percentage
        )
    }
}

// MARK: - Helper function to create sets
private func createExerciseSet(setIndex: Int, reps: Int, weight: Double) -> ExerciseSet {
    return ExerciseSet(setIndex: setIndex, weight: weight, reps: reps)
}
