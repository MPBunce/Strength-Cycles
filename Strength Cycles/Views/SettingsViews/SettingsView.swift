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
                Section {
                    Picker(selection: Binding(
                        get: { userSettings.usesKilograms },
                        set: { newValue in updateSetting { userSettings.usesKilograms = newValue } }
                    )) {
                        Text("lbs").tag(false)
                        Text("kg").tag(true)
                    } label: {
                        Label("Weight Unit", systemImage: "scalemass")
                    }
                } header: {
                    Text("Units")
                } footer: {
                    Text("Existing cycles keep the unit they were created with.")
                }
                
                // Training Maxes Section
                Section {
                    TrainingMaxRow(
                        title: "Bench Press",
                        icon: "dumbbell",
                        value: Binding(
                            get: { displayValue(userSettings.benchPressMax) },
                            set: { newValue in
                                updateSetting { userSettings.benchPressMax = userSettings.convertInputToStorageUnit(newValue) }
                            }
                        ),
                        unit: userSettings.weightUnitString
                    )
                    .id(userSettings.usesKilograms) // reload the text when the unit flips
                    
                    TrainingMaxRow(
                        title: "Squat",
                        icon: "dumbbell",
                        value: Binding(
                            get: { displayValue(userSettings.squatMax) },
                            set: { newValue in
                                updateSetting { userSettings.squatMax = userSettings.convertInputToStorageUnit(newValue) }
                            }
                        ),
                        unit: userSettings.weightUnitString
                    )
                    .id(userSettings.usesKilograms) // reload the text when the unit flips
                    
                    TrainingMaxRow(
                        title: "Deadlift",
                        icon: "dumbbell",
                        value: Binding(
                            get: { displayValue(userSettings.deadliftMax) },
                            set: { newValue in
                                updateSetting { userSettings.deadliftMax = userSettings.convertInputToStorageUnit(newValue) }
                            }
                        ),
                        unit: userSettings.weightUnitString
                    )
                    .id(userSettings.usesKilograms) // reload the text when the unit flips
                    
                    TrainingMaxRow(
                        title: "Overhead Press",
                        icon: "dumbbell",
                        value: Binding(
                            get: { displayValue(userSettings.overheadPressMax) },
                            set: { newValue in
                                updateSetting { userSettings.overheadPressMax = userSettings.convertInputToStorageUnit(newValue) }
                            }
                        ),
                        unit: userSettings.weightUnitString
                    )
                    .id(userSettings.usesKilograms) // reload the text when the unit flips
                } header: {
                    Text("Training Maxes")
                } footer: {
                    Text("Used to calculate weights when you start a 5/3/1 or nSuns cycle. Changes apply to new cycles only.")
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                initializeDefaultSettingsIfNeeded()
            }
        }
    }
    
    /// Training maxes are stored in lbs; show them in the chosen unit, to the nearest 0.1.
    private func displayValue(_ lbs: Double) -> Double {
        guard userSettings.usesKilograms else { return lbs }
        return (WeightConverter.lbsToKg(lbs) * 10).rounded() / 10
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
                    textValue = value == 0 ? "" : WeightConverter.format(value)
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
                        textValue = value == 0 ? "" : WeightConverter.format(value)
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
