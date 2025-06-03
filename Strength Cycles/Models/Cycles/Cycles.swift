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
    
    var dateStarted: Date
    var template: String
    var trainingDays: [TrainingDay]
    
    init( dateStarted: Date, template: String, trainingDays: [TrainingDay]) {
        self.dateStarted = dateStarted
        self.template = template
        self.trainingDays = trainingDays
    }
    
}
