import Foundation
import SwiftData

@Model
class ExerciseSet {
    var weight: Double
    var reps: Int
    
    init(weight: Double, reps: Int) {
        self.weight = weight
        self.reps = reps
    }
    
    func copy() -> ExerciseSet {
        return ExerciseSet(weight: weight, reps: reps)
    }
}

@Model
class Exercise {
    var name: String
    var sets: [ExerciseSet]
    
    init(name: String, sets: [ExerciseSet]) {
        self.name = name
        self.sets = sets
    }
    
    func copy() -> Exercise {
        let copiedSets = sets.map { $0.copy() }
        return Exercise(name: name, sets: copiedSets)
    }
}

@Model
class TrainingDay {
    var day: [Exercise]
    var completedDate: Date?
    
    init(day: [Exercise], completedDate: Date? = nil) {
        self.day = day
        self.completedDate = completedDate
    }
    
    func copy() -> TrainingDay {
        let copiedExercises = day.map { $0.copy() }
        return TrainingDay(day: copiedExercises, completedDate: nil)
    }
}
