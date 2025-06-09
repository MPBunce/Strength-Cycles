//
//  SettingsView.swift
//  Strength Cycles
//
//  Created by Matthew Bunce on 2025-06-01.
//
import SwiftUI
import SwiftData

 
struct SettingsView: View {
    @Environment(\.modelContext) var context
    @Query var settings: [Settings]
    
    private var userSettings: Settings {
        settings.first ?? Settings()
    }
    
    var body: some View {
        NavigationView {
            List {
                // Units Section
                Section("Units") {
                    HStack {
                        Image(systemName: "scalemass")
                            .foregroundColor(.blue)
                            .frame(width: 20)
                        Text("Weight Unit")
                        Spacer()
                        Toggle("", isOn: Binding(
                            get: { userSettings.usesKilograms },
                            set: { newValue in
                                updateSetting { userSettings.usesKilograms = newValue }
                            }
                        ))
                        .labelsHidden()
                        Text(userSettings.usesKilograms ? "kg" : "lbs")
                            .foregroundColor(.secondary)
                            .font(.caption)
                    }
                }
                
                // Workout Settings
                Section("Workout") {
                    HStack {
                        Image(systemName: "timer")
                            .foregroundColor(.orange)
                            .frame(width: 20)
                        Text("Default Rest Time")
                        Spacer()
                        Menu("\(userSettings.defaultRestTime)s") {
                            ForEach([60, 90, 120, 180, 300], id: \.self) { seconds in
                                Button("\(seconds) seconds") {
                                    updateSetting { userSettings.defaultRestTime = seconds }
                                }
                            }
                        }
                        .foregroundColor(.blue)
                    }
                    
                    HStack {
                        Image(systemName: "speaker.wave.2")
                            .foregroundColor(.purple)
                            .frame(width: 20)
                        Text("Rest Timer Sound")
                        Spacer()
                        Toggle("", isOn: Binding(
                            get: { userSettings.enableRestTimerSound },
                            set: { newValue in
                                updateSetting { userSettings.enableRestTimerSound = newValue }
                            }
                        ))
                        .labelsHidden()
                    }
                }
                
                // Notifications Section
                Section("Notifications") {
                    HStack {
                        Image(systemName: "bell")
                            .foregroundColor(.red)
                            .frame(width: 20)
                        Text("Workout Reminders")
                        Spacer()
                        Toggle("", isOn: Binding(
                            get: { userSettings.enableNotifications },
                            set: { newValue in
                                updateSetting { userSettings.enableNotifications = newValue }
                            }
                        ))
                        .labelsHidden()
                    }
                }
                
                // Data & Privacy Section
                Section("Data & Privacy") {
                    HStack {
                        Image(systemName: "photo")
                            .foregroundColor(.green)
                            .frame(width: 20)
                        Text("Progress Photos")
                        Spacer()
                        Toggle("", isOn: Binding(
                            get: { userSettings.enableProgressPhotos },
                            set: { newValue in
                                updateSetting { userSettings.enableProgressPhotos = newValue }
                            }
                        ))
                        .labelsHidden()
                    }
                    
                    HStack {
                        Image(systemName: "icloud")
                            .foregroundColor(.blue)
                            .frame(width: 20)
                        Text("iCloud Sync")
                        Spacer()
                        Toggle("", isOn: Binding(
                            get: { userSettings.enableCloudSync },
                            set: { newValue in
                                updateSetting { userSettings.enableCloudSync = newValue }
                            }
                        ))
                        .labelsHidden()
                    }
                }
                
                // Help & Support Section
                Section("Help & Support") {
                    HStack {
                        Image(systemName: "questionmark.circle")
                            .foregroundColor(.gray)
                            .frame(width: 20)
                        Text("Show Tutorial")
                        Spacer()
                        Toggle("", isOn: Binding(
                            get: { userSettings.showTutorial },
                            set: { newValue in
                                updateSetting { userSettings.showTutorial = newValue }
                            }
                        ))
                        .labelsHidden()
                    }
                    
                    Button(action: {
                        // Reset all settings to default
                        resetToDefaults()
                    }) {
                        HStack {
                            Image(systemName: "arrow.clockwise")
                                .foregroundColor(.orange)
                                .frame(width: 20)
                            Text("Reset to Defaults")
                                .foregroundColor(.primary)
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    // MARK: - Settings Management
    private func initializeSettingsIfNeeded() {
        if settings.isEmpty {
            let defaultSettings = Settings()
            context.insert(defaultSettings)
            
            do {
                try context.save()
            } catch {
                print("Failed to save default settings: \(error)")
            }
        }
    }
    
    private func updateSetting(_ update: () -> Void) {
        update()
        
        do {
            try context.save()
        } catch {
            print("Failed to save settings: \(error)")
        }
    }
    
    private func resetToDefaults() {
        let defaultSettings = Settings()
        userSettings.usesKilograms = defaultSettings.usesKilograms
        userSettings.enableNotifications = defaultSettings.enableNotifications
        userSettings.enableRestTimerSound = defaultSettings.enableRestTimerSound
        userSettings.defaultRestTime = defaultSettings.defaultRestTime
        userSettings.enableProgressPhotos = defaultSettings.enableProgressPhotos
        userSettings.enableCloudSync = defaultSettings.enableCloudSync
        userSettings.showTutorial = defaultSettings.showTutorial
        
        do {
            try context.save()
        } catch {
            print("Failed to reset settings: \(error)")
        }
    }
}

#Preview {
    SettingsView()
        .modelContainer(for: Settings.self, inMemory: true)
}
