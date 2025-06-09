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
    
    init(
        usesKilograms: Bool = false,
        enableNotifications: Bool = true,
        enableRestTimerSound: Bool = true,
        defaultRestTime: Int = 90,
        enableProgressPhotos: Bool = false,
        enableCloudSync: Bool = true,
        showTutorial: Bool = true
    ) {
        self.usesKilograms = usesKilograms
        self.enableNotifications = enableNotifications
        self.enableRestTimerSound = enableRestTimerSound
        self.defaultRestTime = defaultRestTime
        self.enableProgressPhotos = enableProgressPhotos
        self.enableCloudSync = enableCloudSync
        self.showTutorial = showTutorial
    }
}
