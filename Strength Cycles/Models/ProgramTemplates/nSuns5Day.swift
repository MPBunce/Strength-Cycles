//
//  nSuns5Day.swift
//  Strength Cycles
//
//  Created by Matthew Bunce on 2025-06-15.
//

import Foundation
import SwiftData

@Model
class nSunsFiveDayProgram: ProgramProtocol {
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
                dayName: "Bench + OHP",
                day: [
                    Exercise(
                        exerciseIndex: 0,
                        name: "Bench Press",
                        canAlterSets: false,
                        sets: createMondayBenchSets(tm: benchTM)
                    ),
                    Exercise(
                        exerciseIndex: 1,
                        name: "Overhead Press",
                        canAlterSets: false,
                        sets: createMondayOHPSets(tm: ohpTM)
                    ),
                    Exercise(
                        exerciseIndex: 2,
                        name: "Chin Ups",
                        canAlterSets: true,
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 3,
                        name: "Barbell Curls",
                        canAlterSets: true,
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 4,
                        name: "Tricep Push Downs",
                        canAlterSets: true,
                        sets: []
                    )
                ],
                completedDate: nil
            ),
            
            // Tuesday: Squat + Sumo Deadlift
            TrainingDay(
                dayIndex: 1,
                dayName: "Squat + Sumo Deadlift",
                day: [
                    Exercise(
                        exerciseIndex: 0,
                        name: "Squat",
                        canAlterSets: false,
                        sets: createTuesdaySquatSets(tm: squatTM)
                    ),
                    Exercise(
                        exerciseIndex: 1,
                        name: "Sumo Deadlift",
                        canAlterSets: false,
                        sets: createTuesdaySumoSets(tm: deadliftTM)
                    ),
                    Exercise(
                        exerciseIndex: 2,
                        name: "Dumbbell Row",
                        canAlterSets: true,
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 3,
                        name: "Abs",
                        canAlterSets: true,
                        sets: []
                    )
                ],
                completedDate: nil
            ),
            
            // Wednesday: OHP + Incline Bench
            TrainingDay(
                dayIndex: 2,
                dayName: "OHP + Incline Bench",
                day: [
                    Exercise(
                        exerciseIndex: 0,
                        name: "Overhead Press",
                        canAlterSets: false,
                        sets: createWednesdayOHPSets(tm: ohpTM)
                    ),
                    Exercise(
                        exerciseIndex: 1,
                        name: "Incline Bench Press",
                        canAlterSets: false,
                        sets: createWednesdayInclineSets(tm: benchTM)
                    ),
                    Exercise(
                        exerciseIndex: 2,
                        name: "Lateral Raises",
                        canAlterSets: true,
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 3,
                        name: "Dips",
                        canAlterSets: true,
                        sets: []
                    )
                ],
                completedDate: nil
            ),
            
            // Thursday: Deadlift + Front Squat
            TrainingDay(
                dayIndex: 3,
                dayName: "Deadlift + Front Squat",
                day: [
                    Exercise(
                        exerciseIndex: 0,
                        name: "Deadlift",
                        canAlterSets: false,
                        sets: createThursdayDeadliftSets(tm: deadliftTM)
                    ),
                    Exercise(
                        exerciseIndex: 1,
                        name: "Front Squat",
                        canAlterSets: false,
                        sets: createThursdayFrontSquatSets(tm: squatTM)
                    ),
                    Exercise(
                        exerciseIndex: 2,
                        name: "Dumbbell Row",
                        canAlterSets: true,
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 3,
                        name: "Abs",
                        canAlterSets: true,
                        sets: []
                    )
                ],
                completedDate: nil
            ),
            
            // Friday: Bench + Close Grip Bench
            TrainingDay(
                dayIndex: 4,
                dayName: "Bench + Close Grip Bench",
                day: [
                    Exercise(
                        exerciseIndex: 0,
                        name: "Bench Press",
                        canAlterSets: false,
                        sets: createFridayBenchSets(tm: benchTM)
                    ),
                    Exercise(
                        exerciseIndex: 1,
                        name: "Close Grip Bench Press",
                        canAlterSets: false,
                        sets: createFridayCloseBenchSets(tm: benchTM)
                    ),
                    Exercise(
                        exerciseIndex: 2,
                        name: "Barbell Curls",
                        canAlterSets: true,
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 3,
                        name: "Tricep Push Downs",
                        canAlterSets: true,
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
    // 55x8, 65x6, 75x4, 75x4, 75x4, 70x5, 65x6, 60x7, 55x8+
    let percentages = [0.55, 0.65, 0.75, 0.75, 0.75, 0.70, 0.65, 0.60, 0.55]
    let reps = [8, 6, 4, 4, 4, 5, 6, 7, 8]
    
    return zip(percentages, reps).enumerated().map { index, data in
        let (percentage, repCount) = data
        let isAmrap = (index == 8) // Last set is AMRAP
        return createExerciseSet(
            setIndex: index,
            reps: repCount,
            weight: tm * percentage,
            isAmrap: isAmrap,
            amrapTargetReps: isAmrap ? repCount : nil
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
            weight: tm * percentage,
            isAmrap: false,
            amrapTargetReps: nil
        )
    }
}

// MARK: - Tuesday Sets (Squat + Sumo Deadlift)

private func createTuesdaySquatSets(tm: Double) -> [ExerciseSet] {
    // 75x5, 85x3, 95x1+, 90x3, 85x3, 80x3, 75x5, 70x5, 65x5+
    let percentages = [0.75, 0.85, 0.95, 0.90, 0.85, 0.80, 0.75, 0.70, 0.65]
    let reps = [5, 3, 1, 3, 3, 3, 5, 5, 5]
    
    return zip(percentages, reps).enumerated().map { index, data in
        let (percentage, repCount) = data
        let isAmrap = (index == 2 || index == 8) // 1+ and 5+ sets are AMRAP
        return createExerciseSet(
            setIndex: index,
            reps: repCount,
            weight: tm * percentage,
            isAmrap: isAmrap,
            amrapTargetReps: isAmrap ? repCount : nil
        )
    }
}

private func createTuesdaySumoSets(tm: Double) -> [ExerciseSet] {
    // 50x5, 60x5, 70x3, 70x5, 70x7, 70x4, 70x6, 70x8
    let percentages = [0.50, 0.60, 0.70, 0.70, 0.70, 0.70, 0.70, 0.70]
    let reps = [5, 5, 3, 5, 7, 4, 6, 8]
    
    return zip(percentages, reps).enumerated().map { index, data in
        let (percentage, repCount) = data
        return createExerciseSet(
            setIndex: index,
            reps: repCount,
            weight: tm * percentage,
            isAmrap: false,
            amrapTargetReps: nil
        )
    }
}

// MARK: - Wednesday Sets (OHP + Incline Bench)

private func createWednesdayOHPSets(tm: Double) -> [ExerciseSet] {
    // 70x5, 80x3, 90x1+, 85x3, 80x3, 75x3, 70x5, 65x5, 60x5+
    let percentages = [0.70, 0.80, 0.90, 0.85, 0.80, 0.75, 0.70, 0.65, 0.60]
    let reps = [5, 3, 1, 3, 3, 3, 5, 5, 5]
    
    return zip(percentages, reps).enumerated().map { index, data in
        let (percentage, repCount) = data
        let isAmrap = (index == 2 || index == 8) // 1+ and 5+ sets are AMRAP
        return createExerciseSet(
            setIndex: index,
            reps: repCount,
            weight: tm * percentage,
            isAmrap: isAmrap,
            amrapTargetReps: isAmrap ? repCount : nil
        )
    }
}

private func createWednesdayInclineSets(tm: Double) -> [ExerciseSet] {
    // 40x6, 50x5, 60x3, 60x5, 60x7, 60x4, 60x6, 60x8
    let percentages = [0.40, 0.50, 0.60, 0.60, 0.60, 0.60, 0.60, 0.60]
    let reps = [6, 5, 3, 5, 7, 4, 6, 8]
    
    return zip(percentages, reps).enumerated().map { index, data in
        let (percentage, repCount) = data
        return createExerciseSet(
            setIndex: index,
            reps: repCount,
            weight: tm * percentage,
            isAmrap: false,
            amrapTargetReps: nil
        )
    }
}

// MARK: - Thursday Sets (Deadlift + Front Squat)

private func createThursdayDeadliftSets(tm: Double) -> [ExerciseSet] {
    // 75x5, 85x3, 95x1+, 90x3, 85x3, 80x3, 75x3, 70x3, 65x3+
    let percentages = [0.75, 0.85, 0.95, 0.90, 0.85, 0.80, 0.75, 0.70, 0.65]
    let reps = [5, 3, 1, 3, 3, 3, 3, 3, 3]
    
    return zip(percentages, reps).enumerated().map { index, data in
        let (percentage, repCount) = data
        let isAmrap = (index == 2 || index == 8) // 1+ and 3+ sets are AMRAP
        return createExerciseSet(
            setIndex: index,
            reps: repCount,
            weight: tm * percentage,
            isAmrap: isAmrap,
            amrapTargetReps: isAmrap ? repCount : nil
        )
    }
}

private func createThursdayFrontSquatSets(tm: Double) -> [ExerciseSet] {
    // 35x5, 45x5, 55x3, 55x5, 55x7, 55x4, 55x6, 55x8
    let percentages = [0.35, 0.45, 0.55, 0.55, 0.55, 0.55, 0.55, 0.55]
    let reps = [5, 5, 3, 5, 7, 4, 6, 8]
    
    return zip(percentages, reps).enumerated().map { index, data in
        let (percentage, repCount) = data
        return createExerciseSet(
            setIndex: index,
            reps: repCount,
            weight: tm * percentage,
            isAmrap: false,
            amrapTargetReps: nil
        )
    }
}

// MARK: - Friday Sets (Bench + Close Grip Bench)

private func createFridayBenchSets(tm: Double) -> [ExerciseSet] {
    // 65x5, 75x3, 85x1+, 80x3, 75x5, 70x3, 65x5, 60x3, 55x5+
    let percentages = [0.65, 0.75, 0.85, 0.80, 0.75, 0.70, 0.65, 0.60, 0.55]
    let reps = [5, 3, 1, 3, 5, 3, 5, 3, 5]
    
    return zip(percentages, reps).enumerated().map { index, data in
        let (percentage, repCount) = data
        let isAmrap = (index == 2 || index == 8) // 1+ and 5+ sets are AMRAP
        return createExerciseSet(
            setIndex: index,
            reps: repCount,
            weight: tm * percentage,
            isAmrap: isAmrap,
            amrapTargetReps: isAmrap ? repCount : nil
        )
    }
}

private func createFridayCloseBenchSets(tm: Double) -> [ExerciseSet] {
    // 40x6, 50x5, 60x3, 60x5, 60x7, 60x4, 60x6, 60x8
    let percentages = [0.40, 0.50, 0.60, 0.60, 0.60, 0.60, 0.60, 0.60]
    let reps = [6, 5, 3, 5, 7, 4, 6, 8]
    
    return zip(percentages, reps).enumerated().map { index, data in
        let (percentage, repCount) = data
        return createExerciseSet(
            setIndex: index,
            reps: repCount,
            weight: tm * percentage,
            isAmrap: false,
            amrapTargetReps: nil
        )
    }
}

// MARK: - Helper function to create sets with weight rounding
private func createExerciseSet(setIndex: Int, reps: Int, weight: Double, isAmrap: Bool, amrapTargetReps: Int?) -> ExerciseSet {
    let roundedWeight = roundDownToNearest5(weight)
    return ExerciseSet(
        setIndex: setIndex,
        weight: roundedWeight,
        reps: reps,
        isEditable: false,
        isAmrap: isAmrap,
        amrapTargetReps: amrapTargetReps
    )
}

// MARK: - Weight rounding function
private func roundDownToNearest5(_ weight: Double) -> Double {
    return floor(weight / 5.0) * 5.0
}
