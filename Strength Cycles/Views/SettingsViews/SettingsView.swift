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
                // About Section
                Section {
                    NavigationLink(destination: AboutView()) {
                        HStack {
                            Image(systemName: "info.circle")
                                .foregroundColor(.blue)
                                .frame(width: 20)
                            Text("About")
                        }
                    }
                }
                
                // Units Section
                Section("Units") {
                    HStack {
                        Image(systemName: "scalemass")
                            .foregroundColor(.gray)
                            .frame(width: 20)
                        Text("Weight Unit")
                            .foregroundColor(.gray)
                        Spacer()
                        Toggle("", isOn: .constant(userSettings.usesKilograms))
                            .disabled(true)
                            .labelsHidden()
                        Text(userSettings.usesKilograms ? "kg" : "lbs")
                            .foregroundColor(.gray)
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
                            .foregroundColor(.gray)
                            .frame(width: 20)
                        Text("Default Rest Time")
                            .foregroundColor(.gray)
                        Spacer()
                        Menu("\(userSettings.defaultRestTime)s") {
                            ForEach([60, 90, 120, 180, 300], id: \.self) { seconds in
                                Button("\(seconds) seconds") {
                                    // Disabled
                                }
                            }
                        }
                        .disabled(true)
                        .foregroundColor(.gray)
                    }
                    
                    HStack {
                        Image(systemName: "speaker.wave.2")
                            .foregroundColor(.gray)
                            .frame(width: 20)
                        Text("Rest Timer Sound")
                            .foregroundColor(.gray)
                        Spacer()
                        Toggle("", isOn: .constant(userSettings.enableRestTimerSound))
                            .disabled(true)
                            .labelsHidden()
                    }
                }
                
                // Notifications Section
                Section("Notifications") {
                    HStack {
                        Image(systemName: "bell")
                            .foregroundColor(.gray)
                            .frame(width: 20)
                        Text("Workout Reminders")
                            .foregroundColor(.gray)
                        Spacer()
                        Toggle("", isOn: .constant(userSettings.enableNotifications))
                            .disabled(true)
                            .labelsHidden()
                    }
                }
                
                // Data & Privacy Section
                Section("Data & Privacy") {
                    HStack {
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                            .frame(width: 20)
                        Text("Progress Photos")
                            .foregroundColor(.gray)
                        Spacer()
                        Toggle("", isOn: .constant(userSettings.enableProgressPhotos))
                            .disabled(true)
                            .labelsHidden()
                    }
                    
                    HStack {
                        Image(systemName: "icloud")
                            .foregroundColor(.gray)
                            .frame(width: 20)
                        Text("iCloud Sync")
                            .foregroundColor(.gray)
                        Spacer()
                        Toggle("", isOn: .constant(userSettings.enableCloudSync))
                            .disabled(true)
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
                            .foregroundColor(.gray)
                        Spacer()
                        Toggle("", isOn: .constant(userSettings.showTutorial))
                            .disabled(true)
                            .labelsHidden()
                    }
                    
                    Button(action: {
                        // Disabled
                    }) {
                        HStack {
                            Image(systemName: "arrow.clockwise")
                                .foregroundColor(.gray)
                                .frame(width: 20)
                            Text("Reset to Defaults")
                                .foregroundColor(.gray)
                        }
                    }
                    .disabled(true)
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
                    textValue = value == 0 ? "" : String(format: "%.1f", value)
                }
                .onChange(of: textValue) { _, newValue in
                    if let doubleValue = Double(newValue) {
                        value = doubleValue
                    } else if newValue.isEmpty {
                        value = 0.0
                    }
                }
                .onSubmit {
                    if let doubleValue = Double(textValue) {
                        value = doubleValue
                    } else {
                        textValue = value == 0 ? "" : String(format: "%.1f", value)
                    }
                }
            
            Text(unit)
                .foregroundColor(.secondary)
                .font(.caption)
                .frame(width: 25, alignment: .leading)
        }
    }
}

#Preview {
    SettingsView()
        .modelContainer(for: Settings.self, inMemory: true)
}
