//
//  Menzer.swift
//  Strength Cycles
//
//  Created by Matthew Bunce on 2025-05-28.
//

import Foundation
import SwiftData

@Model
class MikeMenzerNewCycle {
    
    @Attribute(.unique) var name: String
    var dateStarted: Date
    var dateUpdated: Date
    var value: Double
    
    init(name: String, date: Date, value: Double) {
        self.name = name
        self.date = date
        self.value = value
    }
}

class ChestAndBackWorkout {
    
}

class LegsWorkoutOne {
    
}

class ShouldersAndArms {
    
}

class LegsWorkoutTwo {
    
}
