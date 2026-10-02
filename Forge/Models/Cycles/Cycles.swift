//
//  Cycles.swift
//  Forge
//
//  Created by Matthew Bunce on 2025-05-31.
//
import Foundation
import SwiftData

@Model
class Cycles {
    @Attribute(.unique) var id: UUID
    var startDate: Date
    var template: String
    var trainingDays: [TrainingDay]
    /// Unit the cycle's weights were written in. Fixed at creation so switching the
    /// app's unit later doesn't reinterpret existing numbers.
    var usesKilograms: Bool = false
    
    init( startDate: Date, template: String, usesKilograms: Bool, trainingDays: [TrainingDay]) {
        self.id = UUID()
        self.startDate = startDate
        self.template = template
        self.trainingDays = trainingDays
        self.usesKilograms = usesKilograms
    }
    
    var weightUnit: String { usesKilograms ? "kg" : "lbs" }
    
    var isCompleted: Bool {
        !trainingDays.isEmpty && trainingDays.allSatisfy { $0.completedDate != nil }
    }
    
}
