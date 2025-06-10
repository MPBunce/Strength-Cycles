//
//  Cycles.swift
//  Strength Cycles
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
    var usesKilograms: Bool
    var trainingDays: [TrainingDay]
    
    init( startDate: Date, template: String, usesKilograms: Bool, trainingDays: [TrainingDay]) {
        self.id = UUID()
        self.startDate = startDate
        self.template = template
        self.usesKilograms = usesKilograms
        self.trainingDays = trainingDays
    }
    
    var isCompleted: Bool {
        !trainingDays.isEmpty && trainingDays.allSatisfy { $0.completedDate != nil }
    }
    
}
