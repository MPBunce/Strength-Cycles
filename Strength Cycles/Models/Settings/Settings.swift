//
//  Settings.swift
//  Strength Cycles
//
//  Created by Matthew Bunce on 2025-05-31.
//

import SwiftUI
import SwiftData

@Model
class Settings {
    var usesKilograms: Bool
    var enableNotifications: Bool
    var enableRestTimerSound: Bool
    var defaultRestTime: Int // in seconds
    var enableProgressPhotos: Bool
    var enableCloudSync: Bool
    var showTutorial: Bool
    
    // Training Maxes
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
            benchPressMax: 0.0,
            squatMax: 0.0,
            deadliftMax: 0.0,
            overheadPressMax: 0.0
        )
    }
}
