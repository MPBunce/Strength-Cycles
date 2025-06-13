//
//  Settings.swift
//  Strength Cycles
//
//  Created by Matthew Bunce on 2025-05-31.
//

import SwiftUI
import SwiftData

// MARK: - Unit Conversion Utilities
struct WeightConverter {
    static func lbsToKg(_ lbs: Double) -> Double {
        return lbs / 2.20462
    }
    
    static func kgToLbs(_ kg: Double) -> Double {
        return kg * 2.20462
    }
    
    static func roundToAppropriateIncrement(_ weight: Double, isKilograms: Bool) -> Double {
        if isKilograms {
            // Round to nearest 2.5kg
            return round(weight / 2.5) * 2.5
        } else {
            // Round down to nearest 5lbs
            return floor(weight / 5.0) * 5.0
        }
    }
}

@Model
class Settings {
    var usesKilograms: Bool
    var enableNotifications: Bool
    var enableRestTimerSound: Bool
    var defaultRestTime: Int // in seconds
    var enableProgressPhotos: Bool
    var enableCloudSync: Bool
    var showTutorial: Bool
    
    // Training Maxes - Always stored in pounds for consistency
    var benchPressMax: Double
    var squatMax: Double
    var deadliftMax: Double
    var overheadPressMax: Double
    
    init(
        usesKilograms: Bool = false,
        enableNotifications: Bool = true,
        enableRestTimerSound: Bool = true,
        defaultRestTime: Int = 90,
        enableProgressPhotos: Bool = false,
        enableCloudSync: Bool = true,
        showTutorial: Bool = true,
        benchPressMax: Double = 0.0,
        squatMax: Double = 0.0,
        deadliftMax: Double = 0.0,
        overheadPressMax: Double = 0.0
    ) {
        self.usesKilograms = usesKilograms
        self.enableNotifications = enableNotifications
        self.enableRestTimerSound = enableRestTimerSound
        self.defaultRestTime = defaultRestTime
        self.enableProgressPhotos = enableProgressPhotos
        self.enableCloudSync = enableCloudSync
        self.showTutorial = showTutorial
        self.benchPressMax = benchPressMax
        self.squatMax = squatMax
        self.deadliftMax = deadliftMax
        self.overheadPressMax = overheadPressMax
    }
}

extension Settings {
    static var defaultSettings: Settings {
        return Settings(
            usesKilograms: false,
            enableNotifications: true,
            enableRestTimerSound: true,
            defaultRestTime: 90,
            enableProgressPhotos: false,
            enableCloudSync: true,
            showTutorial: true,
            benchPressMax: 100.0,  // Stored in lbs
            squatMax: 135.0,       // Stored in lbs
            deadliftMax: 135.0,    // Stored in lbs
            overheadPressMax: 100.0 // Stored in lbs
        )
    }
    
    // MARK: - Unit Conversion Methods
    
    /// Convert a training max from stored lbs to display units
    func convertedTrainingMax(_ max: Double) -> Double {
        if usesKilograms {
            return WeightConverter.roundToAppropriateIncrement(
                WeightConverter.lbsToKg(max),
                isKilograms: true
            )
        }
        return WeightConverter.roundToAppropriateIncrement(max, isKilograms: false)
    }
    
    /// Get a formatted string for display of training max
    func displayTrainingMaxString(_ max: Double) -> String {
        let convertedMax = convertedTrainingMax(max)
        let unit = usesKilograms ? "kg" : "lbs"
        
        if usesKilograms && convertedMax.truncatingRemainder(dividingBy: 1) != 0 {
            return String(format: "%.1f %@", convertedMax, unit)
        } else {
            return String(format: "%.0f %@", convertedMax, unit)
        }
    }
    
    /// Convert user input back to lbs for storage
    func convertInputToStorageUnit(_ inputValue: Double) -> Double {
        if usesKilograms {
            return WeightConverter.kgToLbs(inputValue)
        }
        return inputValue
    }
    
    // MARK: - Convenience Properties for Display
    
    var displayBenchPressMax: Double {
        convertedTrainingMax(benchPressMax)
    }
    
    var displaySquatMax: Double {
        convertedTrainingMax(squatMax)
    }
    
    var displayDeadliftMax: Double {
        convertedTrainingMax(deadliftMax)
    }
    
    var displayOverheadPressMax: Double {
        convertedTrainingMax(overheadPressMax)
    }
    
    // MARK: - Formatted String Properties
    
    var benchPressMaxString: String {
        displayTrainingMaxString(benchPressMax)
    }
    
    var squatMaxString: String {
        displayTrainingMaxString(squatMax)
    }
    
    var deadliftMaxString: String {
        displayTrainingMaxString(deadliftMax)
    }
    
    var overheadPressMaxString: String {
        displayTrainingMaxString(overheadPressMax)
    }
    
    var weightUnitString: String {
        usesKilograms ? "kg" : "lbs"
    }
    
    // MARK: - Update Methods
    
    /// Update bench press max from user input
    func updateBenchPressMax(from inputValue: Double) {
        benchPressMax = convertInputToStorageUnit(inputValue)
    }
    
    /// Update squat max from user input
    func updateSquatMax(from inputValue: Double) {
        squatMax = convertInputToStorageUnit(inputValue)
    }
    
    /// Update deadlift max from user input
    func updateDeadliftMax(from inputValue: Double) {
        deadliftMax = convertInputToStorageUnit(inputValue)
    }
    
    /// Update overhead press max from user input
    func updateOverheadPressMax(from inputValue: Double) {
        overheadPressMax = convertInputToStorageUnit(inputValue)
    }
}
