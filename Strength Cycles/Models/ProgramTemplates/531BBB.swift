//
//  FiveThreeOneBBB.swift
//  Strength Cycles
//
//  Created by Matthew Bunce on 2025-06-15.
//

import Foundation
import SwiftData

@Model
class FiveThreeOneBBBProgram: ProgramProtocol {
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
            // Week 1 Day 1: OHP + Bench BBB
            TrainingDay(
                dayIndex: 0,
                dayName: "Week 1 - OHP + Bench BBB",
                day: [
                    Exercise(
                        exerciseIndex: 0,
                        name: "Overhead Press",
                        canAlterSets: false,
                        sets: createWeek1Sets(tm: ohpTM)
                    ),
                    Exercise(
                        exerciseIndex: 1,
                        name: "Bench Press (BBB)",
                        canAlterSets: false,
                        sets: createBBBSets(tm: benchTM)
                    ),
                    Exercise(
                        exerciseIndex: 2,
                        name: "Chin Ups",
                        canAlterSets: true,
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 3,
                        name: "Dips",
                        canAlterSets: true,
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 4,
                        name: "Face Pulls",
                        canAlterSets: true,
                        sets: []
                    )
                ],
                completedDate: nil
            ),
            
            // Week 1 Day 2: Deadlift + Squat BBB
            TrainingDay(
                dayIndex: 1,
                dayName: "Week 1 - Deadlift + Squat BBB",
                day: [
                    Exercise(
                        exerciseIndex: 0,
                        name: "Deadlift",
                        canAlterSets: false,
                        sets: createWeek1Sets(tm: deadliftTM)
                    ),
                    Exercise(
                        exerciseIndex: 1,
                        name: "Squat (BBB)",
                        canAlterSets: false,
                        sets: createBBBSets(tm: squatTM)
                    ),
                    Exercise(
                        exerciseIndex: 2,
                        name: "Hanging Knee Raises",
                        canAlterSets: true,
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 3,
                        name: "Back Extensions",
                        canAlterSets: true,
                        sets: []
                    )
                ],
                completedDate: nil
            ),
            
            // Week 1 Day 3: Bench + OHP BBB
            TrainingDay(
                dayIndex: 2,
                dayName: "Week 1 - Bench + OHP BBB",
                day: [
                    Exercise(
                        exerciseIndex: 0,
                        name: "Bench Press",
                        canAlterSets: false,
                        sets: createWeek1Sets(tm: benchTM)
                    ),
                    Exercise(
                        exerciseIndex: 1,
                        name: "Overhead Press (BBB)",
                        canAlterSets: false,
                        sets: createBBBSets(tm: ohpTM)
                    ),
                    Exercise(
                        exerciseIndex: 2,
                        name: "Barbell Rows",
                        canAlterSets: true,
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 3,
                        name: "Tricep Extensions",
                        canAlterSets: true,
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 4,
                        name: "Barbell Curls",
                        canAlterSets: true,
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 5,
                        name: "Lateral Raises",
                        canAlterSets: true,
                        sets: []
                    )
                ],
                completedDate: nil
            ),
            
            // Week 1 Day 4: Squat + Deadlift BBB
            TrainingDay(
                dayIndex: 3,
                dayName: "Week 1 - Squat + Deadlift BBB",
                day: [
                    Exercise(
                        exerciseIndex: 0,
                        name: "Squat",
                        canAlterSets: false,
                        sets: createWeek1Sets(tm: squatTM)
                    ),
                    Exercise(
                        exerciseIndex: 1,
                        name: "Deadlift (BBB)",
                        canAlterSets: false,
                        sets: createBBBSets(tm: deadliftTM)
                    ),
                    Exercise(
                        exerciseIndex: 2,
                        name: "Walking Lunges",
                        canAlterSets: true,
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 3,
                        name: "Leg Curls",
                        canAlterSets: true,
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 4,
                        name: "Calf Raises",
                        canAlterSets: true,
                        sets: []
                    )
                ],
                completedDate: nil
            ),
            
            // Week 2 Day 1: OHP + Bench BBB
            TrainingDay(
                dayIndex: 4,
                dayName: "Week 2 - OHP + Bench BBB",
                day: [
                    Exercise(
                        exerciseIndex: 0,
                        name: "Overhead Press",
                        canAlterSets: false,
                        sets: createWeek2Sets(tm: ohpTM)
                    ),
                    Exercise(
                        exerciseIndex: 1,
                        name: "Bench Press (BBB)",
                        canAlterSets: false,
                        sets: createBBBSets(tm: benchTM)
                    ),
                    Exercise(
                        exerciseIndex: 2,
                        name: "Chin Ups",
                        canAlterSets: true,
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 3,
                        name: "Dips",
                        canAlterSets: true,
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 4,
                        name: "Face Pulls",
                        canAlterSets: true,
                        sets: []
                    )
                ],
                completedDate: nil
            ),
            
            // Week 2 Day 2: Deadlift + Squat BBB
            TrainingDay(
                dayIndex: 5,
                dayName: "Week 2 - Deadlift + Squat BBB",
                day: [
                    Exercise(
                        exerciseIndex: 0,
                        name: "Deadlift",
                        canAlterSets: false,
                        sets: createWeek2Sets(tm: deadliftTM)
                    ),
                    Exercise(
                        exerciseIndex: 1,
                        name: "Squat (BBB)",
                        canAlterSets: false,
                        sets: createBBBSets(tm: squatTM)
                    ),
                    Exercise(
                        exerciseIndex: 2,
                        name: "Hanging Knee Raises",
                        canAlterSets: true,
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 3,
                        name: "Back Extensions",
                        canAlterSets: true,
                        sets: []
                    )
                ],
                completedDate: nil
            ),
            
            // Week 2 Day 3: Bench + OHP BBB
            TrainingDay(
                dayIndex: 6,
                dayName: "Week 2 - Bench + OHP BBB",
                day: [
                    Exercise(
                        exerciseIndex: 0,
                        name: "Bench Press",
                        canAlterSets: false,
                        sets: createWeek2Sets(tm: benchTM)
                    ),
                    Exercise(
                        exerciseIndex: 1,
                        name: "Overhead Press (BBB)",
                        canAlterSets: false,
                        sets: createBBBSets(tm: ohpTM)
                    ),
                    Exercise(
                        exerciseIndex: 2,
                        name: "Barbell Rows",
                        canAlterSets: true,
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 3,
                        name: "Tricep Extensions",
                        canAlterSets: true,
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 4,
                        name: "Barbell Curls",
                        canAlterSets: true,
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 5,
                        name: "Lateral Raises",
                        canAlterSets: true,
                        sets: []
                    )
                ],
                completedDate: nil
            ),
            
            // Week 2 Day 4: Squat + Deadlift BBB
            TrainingDay(
                dayIndex: 7,
                dayName: "Week 2 - Squat + Deadlift BBB",
                day: [
                    Exercise(
                        exerciseIndex: 0,
                        name: "Squat",
                        canAlterSets: false,
                        sets: createWeek2Sets(tm: squatTM)
                    ),
                    Exercise(
                        exerciseIndex: 1,
                        name: "Deadlift (BBB)",
                        canAlterSets: false,
                        sets: createBBBSets(tm: deadliftTM)
                    ),
                    Exercise(
                        exerciseIndex: 2,
                        name: "Walking Lunges",
                        canAlterSets: true,
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 3,
                        name: "Leg Curls",
                        canAlterSets: true,
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 4,
                        name: "Calf Raises",
                        canAlterSets: true,
                        sets: []
                    )
                ],
                completedDate: nil
            ),
            
            // Week 3 Day 1: OHP + Bench BBB
            TrainingDay(
                dayIndex: 8,
                dayName: "Week 3 - OHP + Bench BBB",
                day: [
                    Exercise(
                        exerciseIndex: 0,
                        name: "Overhead Press",
                        canAlterSets: false,
                        sets: createWeek3Sets(tm: ohpTM)
                    ),
                    Exercise(
                        exerciseIndex: 1,
                        name: "Bench Press (BBB)",
                        canAlterSets: false,
                        sets: createBBBSets(tm: benchTM)
                    ),
                    Exercise(
                        exerciseIndex: 2,
                        name: "Chin Ups",
                        canAlterSets: true,
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 3,
                        name: "Dips",
                        canAlterSets: true,
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 4,
                        name: "Face Pulls",
                        canAlterSets: true,
                        sets: []
                    )
                ],
                completedDate: nil
            ),
            
            // Week 3 Day 2: Deadlift + Squat BBB
            TrainingDay(
                dayIndex: 9,
                dayName: "Week 3 - Deadlift + Squat BBB",
                day: [
                    Exercise(
                        exerciseIndex: 0,
                        name: "Deadlift",
                        canAlterSets: false,
                        sets: createWeek3Sets(tm: deadliftTM)
                    ),
                    Exercise(
                        exerciseIndex: 1,
                        name: "Squat (BBB)",
                        canAlterSets: false,
                        sets: createBBBSets(tm: squatTM)
                    ),
                    Exercise(
                        exerciseIndex: 2,
                        name: "Hanging Knee Raises",
                        canAlterSets: true,
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 3,
                        name: "Back Extensions",
                        canAlterSets: true,
                        sets: []
                    )
                ],
                completedDate: nil
            ),
            
            // Week 3 Day 3: Bench + OHP BBB
            TrainingDay(
                dayIndex: 10,
                dayName: "Week 3 - Bench + OHP BBB",
                day: [
                    Exercise(
                        exerciseIndex: 0,
                        name: "Bench Press",
                        canAlterSets: false,
                        sets: createWeek3Sets(tm: benchTM)
                    ),
                    Exercise(
                        exerciseIndex: 1,
                        name: "Overhead Press (BBB)",
                        canAlterSets: false,
                        sets: createBBBSets(tm: ohpTM)
                    ),
                    Exercise(
                        exerciseIndex: 2,
                        name: "Barbell Rows",
                        canAlterSets: true,
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 3,
                        name: "Tricep Extensions",
                        canAlterSets: true,
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 4,
                        name: "Barbell Curls",
                        canAlterSets: true,
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 5,
                        name: "Lateral Raises",
                        canAlterSets: true,
                        sets: []
                    )
                ],
                completedDate: nil
            ),
            
            // Week 3 Day 4: Squat + Deadlift BBB
            TrainingDay(
                dayIndex: 11,
                dayName: "Week 3 - Squat + Deadlift BBB",
                day: [
                    Exercise(
                        exerciseIndex: 0,
                        name: "Squat",
                        canAlterSets: false,
                        sets: createWeek3Sets(tm: squatTM)
                    ),
                    Exercise(
                        exerciseIndex: 1,
                        name: "Deadlift (BBB)",
                        canAlterSets: false,
                        sets: createBBBSets(tm: deadliftTM)
                    ),
                    Exercise(
                        exerciseIndex: 2,
                        name: "Walking Lunges",
                        canAlterSets: true,
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 3,
                        name: "Leg Curls",
                        canAlterSets: true,
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 4,
                        name: "Calf Raises",
                        canAlterSets: true,
                        sets: []
                    )
                ],
                completedDate: nil
            ),
            
            // Week 4 Day 1: OHP + Bench BBB (Deload)
            TrainingDay(
                dayIndex: 12,
                dayName: "Week 4 - OHP + Bench BBB (Deload)",
                day: [
                    Exercise(
                        exerciseIndex: 0,
                        name: "Overhead Press",
                        canAlterSets: false,
                        sets: createDeloadSets(tm: ohpTM)
                    ),
                    Exercise(
                        exerciseIndex: 1,
                        name: "Bench Press (BBB)",
                        canAlterSets: false,
                        sets: createBBBSets(tm: benchTM)
                    ),
                    Exercise(
                        exerciseIndex: 2,
                        name: "Chin Ups",
                        canAlterSets: true,
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 3,
                        name: "Dips",
                        canAlterSets: true,
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 4,
                        name: "Face Pulls",
                        canAlterSets: true,
                        sets: []
                    )
                ],
                completedDate: nil
            ),
            
            // Week 4 Day 2: Deadlift + Squat BBB (Deload)
            TrainingDay(
                dayIndex: 13,
                dayName: "Week 4 - Deadlift + Squat BBB (Deload)",
                day: [
                    Exercise(
                        exerciseIndex: 0,
                        name: "Deadlift",
                        canAlterSets: false,
                        sets: createDeloadSets(tm: deadliftTM)
                    ),
                    Exercise(
                        exerciseIndex: 1,
                        name: "Squat (BBB)",
                        canAlterSets: false,
                        sets: createBBBSets(tm: squatTM)
                    ),
                    Exercise(
                        exerciseIndex: 2,
                        name: "Hanging Knee Raises",
                        canAlterSets: true,
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 3,
                        name: "Back Extensions",
                        canAlterSets: true,
                        sets: []
                    )
                ],
                completedDate: nil
            ),
            
            // Week 4 Day 3: Bench + OHP BBB (Deload)
            TrainingDay(
                dayIndex: 14,
                dayName: "Week 4 - Bench + OHP BBB (Deload)",
                day: [
                    Exercise(
                        exerciseIndex: 0,
                        name: "Bench Press",
                        canAlterSets: false,
                        sets: createDeloadSets(tm: benchTM)
                    ),
                    Exercise(
                        exerciseIndex: 1,
                        name: "Overhead Press (BBB)",
                        canAlterSets: false,
                        sets: createBBBSets(tm: ohpTM)
                    ),
                    Exercise(
                        exerciseIndex: 2,
                        name: "Barbell Rows",
                        canAlterSets: true,
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 3,
                        name: "Tricep Extensions",
                        canAlterSets: true,
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 4,
                        name: "Barbell Curls",
                        canAlterSets: true,
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 5,
                        name: "Lateral Raises",
                        canAlterSets: true,
                        sets: []
                    )
                ],
                completedDate: nil
            ),
            
            // Week 4 Day 4: Squat + Deadlift BBB (Deload)
            TrainingDay(
                dayIndex: 15,
                dayName: "Week 4 - Squat + Deadlift BBB (Deload)",
                day: [
                    Exercise(
                        exerciseIndex: 0,
                        name: "Squat",
                        canAlterSets: false,
                        sets: createDeloadSets(tm: squatTM)
                    ),
                    Exercise(
                        exerciseIndex: 1,
                        name: "Deadlift (BBB)",
                        canAlterSets: false,
                        sets: createBBBSets(tm: deadliftTM)
                    ),
                    Exercise(
                        exerciseIndex: 2,
                        name: "Walking Lunges",
                        canAlterSets: true,
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 3,
                        name: "Leg Curls",
                        canAlterSets: true,
                        sets: []
                    ),
                    Exercise(
                        exerciseIndex: 4,
                        name: "Calf Raises",
                        canAlterSets: true,
                        sets: []
                    )
                ],
                completedDate: nil
            )
        ]
    }
}

// MARK: - Week 1 Sets (5s Week)

private func createWeek1Sets(tm: Double) -> [ExerciseSet] {
    // Week 1: 65x5, 75x5, 85x5+
    let percentages = [0.65, 0.75, 0.85]
    let reps = [5, 5, 5]
    
    return zip(percentages, reps).enumerated().map { index, data in
        let (percentage, repCount) = data
        let isAmrap = (index == 2) // Last set is AMRAP
        return createExerciseSet(
            setIndex: index,
            reps: repCount,
            weight: tm * percentage,
            isAmrap: isAmrap,
            amrapTargetReps: isAmrap ? repCount : nil
        )
    }
}

// MARK: - Week 2 Sets (3s Week)

private func createWeek2Sets(tm: Double) -> [ExerciseSet] {
    // Week 2: 70x3, 80x3, 90x3+
    let percentages = [0.70, 0.80, 0.90]
    let reps = [3, 3, 3]
    
    return zip(percentages, reps).enumerated().map { index, data in
        let (percentage, repCount) = data
        let isAmrap = (index == 2) // Last set is AMRAP
        return createExerciseSet(
            setIndex: index,
            reps: repCount,
            weight: tm * percentage,
            isAmrap: isAmrap,
            amrapTargetReps: isAmrap ? repCount : nil
        )
    }
}

// MARK: - Week 3 Sets (5/3/1 Week)

private func createWeek3Sets(tm: Double) -> [ExerciseSet] {
    // Week 3: 75x5, 85x3, 95x1+
    let percentages = [0.75, 0.85, 0.95]
    let reps = [5, 3, 1]
    
    return zip(percentages, reps).enumerated().map { index, data in
        let (percentage, repCount) = data
        let isAmrap = (index == 2) // Last set is AMRAP
        return createExerciseSet(
            setIndex: index,
            reps: repCount,
            weight: tm * percentage,
            isAmrap: isAmrap,
            amrapTargetReps: isAmrap ? repCount : nil
        )
    }
}

// MARK: - Week 4 Sets (Deload Week)

private func createDeloadSets(tm: Double) -> [ExerciseSet] {
    // Week 4: 40x5, 50x5, 60x5
    let percentages = [0.40, 0.50, 0.60]
    let reps = [5, 5, 5]
    
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

// MARK: - BBB Sets (Boring But Big)

private func createBBBSets(tm: Double) -> [ExerciseSet] {
    // BBB: 5 sets of 10 reps at 50% of Training Max
    let percentage = 0.50
    let reps = 10
    let numSets = 5
    
    return (0..<numSets).map { index in
        return createExerciseSet(
            setIndex: index,
            reps: reps,
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
