import Foundation
import SwiftData

// MARK: - Set Completion Status
enum SetCompletionStatus: String, Codable, CaseIterable {
    case notStarted = "not_started"
    case completedSuccessfully = "completed_successfully"
    case failed = "failed"
}

@Model
class ExerciseSet {
    var setIndex: Int
    var weight: Double?
    var reps: Int?
    var isEditable: Bool
    var completionStatus: SetCompletionStatus
    
    init(setIndex: Int, weight: Double? = nil, reps: Int? = nil, isEditable: Bool = true, completionStatus: SetCompletionStatus = .notStarted) {
        self.setIndex = setIndex
        self.weight = weight
        self.reps = reps
        self.isEditable = isEditable
        self.completionStatus = completionStatus
    }
    
    func copy() -> ExerciseSet {
        return ExerciseSet(
            setIndex: setIndex,
            weight: weight,
            reps: reps,
            isEditable: isEditable,
            completionStatus: .notStarted // Reset completion status on copy
        )
    }
    
    // Convenience methods
    func markAsCompleted() {
        completionStatus = .completedSuccessfully
    }
    
    func markAsFailed() {
        completionStatus = .failed
    }
    
    func reset() {
        completionStatus = .notStarted
    }
    
    var isCompleted: Bool {
        return completionStatus != .notStarted
    }
    
    var wasSuccessful: Bool {
        return completionStatus == .completedSuccessfully
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
    
    // Convenience methods for exercise completion
    var completedSetsCount: Int {
        return sets.filter { $0.isCompleted }.count
    }
    
    var successfulSetsCount: Int {
        return sets.filter { $0.wasSuccessful }.count
    }
    
    var failedSetsCount: Int {
        return sets.filter { $0.completionStatus == .failed }.count
    }
    
    var isFullyCompleted: Bool {
        return sets.allSatisfy { $0.isCompleted }
    }
    
    var completionPercentage: Double {
        guard !sets.isEmpty else { return 0.0 }
        return Double(completedSetsCount) / Double(sets.count)
    }
}

@Model
class TrainingDay {
    var dayIndex: Int
    var dayName: String
    var day: [Exercise]
    var completedDate: Date?
    var canAddAccessory: Bool
    
    init(dayIndex: Int, dayName: String, day: [Exercise], completedDate: Date? = nil, canAddAccessory: Bool = false) {
        self.dayIndex = dayIndex
        self.dayName = dayName
        self.day = day
        self.completedDate = completedDate
        self.canAddAccessory = canAddAccessory
    }
    
    func copy() -> TrainingDay {
        let copiedExercises = day.map { $0.copy() }
        return TrainingDay(dayIndex: dayIndex, dayName: dayName, day: copiedExercises, completedDate: nil, canAddAccessory: canAddAccessory)
    }
    
    // Convenience methods for day completion
    var totalSets: Int {
        return day.reduce(0) { $0 + $1.sets.count }
    }
    
    var completedSets: Int {
        return day.reduce(0) { $0 + $1.completedSetsCount }
    }
    
    var successfulSets: Int {
        return day.reduce(0) { $0 + $1.successfulSetsCount }
    }
    
    var failedSets: Int {
        return day.reduce(0) { $0 + $1.failedSetsCount }
    }
    
    var isFullyCompleted: Bool {
        return day.allSatisfy { $0.isFullyCompleted }
    }
    
    var completionPercentage: Double {
        guard totalSets > 0 else { return 0.0 }
        return Double(completedSets) / Double(totalSets)
    }
    
    func markAsCompleted() {
        completedDate = Date()
    }
}
