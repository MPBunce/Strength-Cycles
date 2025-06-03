//
//  Templates.swift
//  Strength Cycles
//
//  Created by Matthew Bunce on 2025-06-01.
//

import Foundation

struct CycleTemplate: Identifiable {
    let id: String
    let name: String
    let description: String
    let duration: String
}

// MARK: - Template Definitions
extension CycleTemplate {
    static let allTemplates: [CycleTemplate] = [
        .menzerCycle,
        .pushPullLegs,
        .upperLowerSplit,
        .customTemplate
    ]
    
    static let menzerCycle = CycleTemplate(
        id: "menzer",
        name: "Menzer Cycle",
        description: "High-intensity training with extended rest periods",
        duration: "8 weeks"
    )
    
    static let pushPullLegs = CycleTemplate(
        id: "ppl",
        name: "Push Pull Legs",
        description: "Split training focusing on movement patterns",
        duration: "12 weeks"
    )
    
    static let upperLowerSplit = CycleTemplate(
        id: "upper_lower",
        name: "Upper Lower Split",
        description: "4-day split alternating upper and lower body",
        duration: "10 weeks"
    )
    
    static let customTemplate = CycleTemplate(
        id: "custom",
        name: "Custom Cycle",
        description: "Create your own workout program",
        duration: "Flexible"
    )
}
