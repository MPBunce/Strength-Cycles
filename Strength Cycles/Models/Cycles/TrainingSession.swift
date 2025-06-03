//
//  TrainingSession.swift
//  Strength Cycles
//
//  Created by Matthew Bunce on 2025-06-01.
//

import Foundation
import SwiftData

@Model
class TrainingSession {
    var date: Date
    
    init(date: Date, exercises: [Exercise]) {
        self.date = date
    }
}
