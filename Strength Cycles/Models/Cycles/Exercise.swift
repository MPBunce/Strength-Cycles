//
//  Exercise.swift
//  Strength Cycles
//
//  Created by Matthew Bunce on 2025-05-28.
//

import Foundation
import SwiftData

class Exercise {
    var id: String { name }
    var name: String
    var sets: [Set]
    
    init(name: String, sets: [Set]) {
        self.name = name
        self.sets = sets
    }
}

class Set {
    var weight: Double
    var reps: Int
    
    init(weight: Double, reps: Int) {
        self.weight = weight
        self.reps = reps
    }
}
