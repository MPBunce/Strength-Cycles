import Foundation
import SwiftData

@Model
class ExerciseSet {
    var setIndex: Int
    var weight: Double?
    var reps: Int?
    
    init(setIndex: Int, weight: Double? = nil, reps: Int? = nil) {
        self.setIndex = setIndex
        self.weight = weight
        self.reps = reps
    }
    
    func copy() -> ExerciseSet {
        return ExerciseSet(setIndex: setIndex, weight: weight, reps: reps)
    }
}

@Model
class Exercise {
    var exerciseIndex: Int
    var name: String
    var sets: [ExerciseSet]
    
    init(exerciseIndex: Int, name: String, sets: [ExerciseSet]) {
        self.exerciseIndex = exerciseIndex
        self.name = name
        self.sets = sets
    }
    
    func copy() -> Exercise {
        let copiedSets = sets.map { $0.copy() }
        return Exercise(exerciseIndex: exerciseIndex, name: name, sets: copiedSets)
    }
}

@Model
class TrainingDay {
    var dayIndex: Int
    var day: [Exercise]
    var completedDate: Date?
    
    init(dayIndex: Int, day: [Exercise], completedDate: Date? = nil) {
        self.dayIndex = dayIndex
        self.day = day
        self.completedDate = completedDate
    }
    
    func copy() -> TrainingDay {
        let copiedExercises = day.map { $0.copy() }
        return TrainingDay(dayIndex: dayIndex, day: copiedExercises, completedDate: nil)
    }
}
