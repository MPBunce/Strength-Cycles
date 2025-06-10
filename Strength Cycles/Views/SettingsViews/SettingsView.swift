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
        if let existingSettings = settings.first {
            return existingSettings
        } else {
            // This shouldn't happen if we initialize properly, but fallback
            let newSettings = Settings.defaultSettings
            context.insert(newSettings)
            try? context.save()
            return newSettings
        }
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
                
                // Training Maxes Section
                Section("Training Maxes") {
                    TrainingMaxRow(
                        title: "Bench Press",
                        icon: "dumbbell",
                        value: Binding(
                            get: { userSettings.benchPressMax },
                            set: { newValue in
                                updateSetting { userSettings.benchPressMax = newValue }
                            }
                        ),
                        unit: userSettings.usesKilograms ? "kg" : "lbs"
                    )
                    
                    TrainingMaxRow(
                        title: "Squat",
                        icon: "dumbbell",
                        value: Binding(
                            get: { userSettings.squatMax },
                            set: { newValue in
                                updateSetting { userSettings.squatMax = newValue }
                            }
                        ),
                        unit: userSettings.usesKilograms ? "kg" : "lbs"
                    )
                    
                    TrainingMaxRow(
                        title: "Deadlift",
                        icon: "dumbbell",
                        value: Binding(
                            get: { userSettings.deadliftMax },
                            set: { newValue in
                                updateSetting { userSettings.deadliftMax = newValue }
                            }
                        ),
                        unit: userSettings.usesKilograms ? "kg" : "lbs"
                    )
                    
                    TrainingMaxRow(
                        title: "Overhead Press",
                        icon: "dumbbell",
                        value: Binding(
                            get: { userSettings.overheadPressMax },
                            set: { newValue in
                                updateSetting { userSettings.overheadPressMax = newValue }
                            }
                        ),
                        unit: userSettings.usesKilograms ? "kg" : "lbs"
                    )
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
            .onAppear {
                initializeDefaultSettingsIfNeeded()
            }
        }
    }
    
    // MARK: - Settings Management
    private func initializeDefaultSettingsIfNeeded() {
        // Only initialize if no settings exist
        if settings.isEmpty {
            let defaultSettings = Settings.defaultSettings
            context.insert(defaultSettings)
            
            do {
                try context.save()
            } catch {
                print("Failed to save default settings: \(error)")
            }
        }
    }
    
    private func updateSetting(_ update: () -> Void) {
        // Ensure we have settings in the context
        if settings.isEmpty {
            initializeDefaultSettingsIfNeeded()
        }
        
        update()
        
        do {
            try context.save()
        } catch {
            print("Failed to save settings: \(error)")
        }
    }
    
    private func resetToDefaults() {
        let defaultSettings = Settings.defaultSettings
        userSettings.usesKilograms = defaultSettings.usesKilograms
        userSettings.enableNotifications = defaultSettings.enableNotifications
        userSettings.enableRestTimerSound = defaultSettings.enableRestTimerSound
        userSettings.defaultRestTime = defaultSettings.defaultRestTime
        userSettings.enableProgressPhotos = defaultSettings.enableProgressPhotos
        userSettings.enableCloudSync = defaultSettings.enableCloudSync
        userSettings.showTutorial = defaultSettings.showTutorial
        userSettings.benchPressMax = defaultSettings.benchPressMax
        userSettings.squatMax = defaultSettings.squatMax
        userSettings.deadliftMax = defaultSettings.deadliftMax
        userSettings.overheadPressMax = defaultSettings.overheadPressMax
        
        do {
            try context.save()
        } catch {
            print("Failed to reset settings: \(error)")
        }
    }
}

// MARK: - Training Max Row Component
struct TrainingMaxRow: View {
    let title: String
    let icon: String
    @Binding var value: Double
    let unit: String
    @State private var textValue: String = ""
    @State private var isEditing: Bool = false
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.red)
                .frame(width: 20)
            Text(title)
            Spacer()
            
            TextField("0", text: $textValue)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.trailing)
                .frame(width: 80)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onAppear {
                    textValue = value == 0 ? "" : formatValue(value)
                }
                .onChange(of: textValue) { _, newValue in
                    let filteredValue = filterNumericInput(newValue)
                    if filteredValue != newValue {
                        textValue = filteredValue
                    }
                    
                    if let doubleValue = Double(filteredValue) {
                        value = doubleValue
                    } else if filteredValue.isEmpty {
                        value = 0.0
                    }
                }
                .onSubmit {
                    if let doubleValue = Double(textValue) {
                        value = doubleValue
                        textValue = formatValue(doubleValue)
                    } else {
                        textValue = value == 0 ? "" : formatValue(value)
                    }
                }
            
            Text(unit)
                .foregroundColor(.secondary)
                .font(.caption)
                .frame(width: 25, alignment: .leading)
        }
    }
    
    // MARK: - Helper Functions
    private func filterNumericInput(_ input: String) -> String {
        // Allow digits and at most one decimal point
        let filtered = input.filter { $0.isNumber || $0 == "." }
        
        // Ensure only one decimal point
        let components = filtered.components(separatedBy: ".")
        if components.count > 2 {
            return components[0] + "." + components[1...].joined()
        }
        
        // Limit decimal places to 1
        if components.count == 2 && components[1].count > 1 {
            return components[0] + "." + String(components[1].prefix(1))
        }
        
        return filtered
    }
    
    private func formatValue(_ value: Double) -> String {
        if value == floor(value) {
            return String(format: "%.0f", value)
        } else {
            return String(format: "%.1f", value)
        }
    }
}

#Preview {
    SettingsView()
        .modelContainer(for: Settings.self, inMemory: true)
}
