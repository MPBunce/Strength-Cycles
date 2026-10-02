//
//  TemplateEditorView.swift
//  Forge
//
//  Build or edit a custom cycle template: named days, each with exercises
//  prescribed as sets × reps (optionally with an AMRAP last set).
//

import SwiftUI
import SwiftData

struct TemplateEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context

    /// nil when creating a new template.
    let template: CustomTemplate?

    @State private var name = ""
    @State private var details = ""
    @State private var days: [CustomTemplateDay] = [CustomTemplateDay(name: "Day 1")]
    @State private var loaded = false

    private var canSave: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
            && days.contains { !$0.exercises.isEmpty }
    }

    var body: some View {
        Form {
            Section {
                TextField("Template name", text: $name)
                TextField("Description (optional)", text: $details, axis: .vertical)
                    .lineLimit(1...3)
            }

            Section {
                ForEach($days) { $day in
                    NavigationLink {
                        TemplateDayEditor(day: $day)
                    } label: {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(day.name.isEmpty ? "Untitled Day" : day.name)
                            Text(day.exercises.isEmpty
                                 ? "No exercises"
                                 : day.exercises.map(\.name).joined(separator: ", "))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                        }
                    }
                }
                .onDelete { days.remove(atOffsets: $0) }
                .onMove { days.move(fromOffsets: $0, toOffset: $1) }

                Button {
                    days.append(CustomTemplateDay(name: "Day \(days.count + 1)"))
                } label: {
                    Label("Add Day", systemImage: "plus")
                }
            } header: {
                Text("Days")
            } footer: {
                Text("Each day becomes one training day in the cycle. Weights are left blank for you to fill in as you train.")
            }
        }
        .navigationTitle(template == nil ? "New Template" : "Edit Template")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save", action: save)
                    .fontWeight(.semibold)
                    .disabled(!canSave)
            }
        }
        .onAppear {
            guard !loaded else { return }
            loaded = true
            if let template {
                name = template.name
                details = template.details
                days = template.days
            }
        }
    }

    private func save() {
        let cleanedDays = days.map { day in
            var day = day
            day.exercises.removeAll { $0.name.trimmingCharacters(in: .whitespaces).isEmpty }
            return day
        }
        let trimmedName = name.trimmingCharacters(in: .whitespaces)
        let trimmedDetails = details.trimmingCharacters(in: .whitespacesAndNewlines)
        if let template {
            template.name = trimmedName
            template.details = trimmedDetails
            template.days = cleanedDays
        } else {
            context.insert(CustomTemplate(name: trimmedName, details: trimmedDetails, days: cleanedDays))
        }
        dismiss()
    }
}

private struct TemplateDayEditor: View {
    @Binding var day: CustomTemplateDay
    @State private var newExerciseName = ""
    @FocusState private var addFieldFocused: Bool

    var body: some View {
        Form {
            Section("Day name") {
                TextField("e.g. Upper A", text: $day.name)
            }

            Section {
                ForEach($day.exercises) { $exercise in
                    NavigationLink {
                        TemplateExerciseEditor(exercise: $exercise)
                    } label: {
                        LabeledContent(exercise.name, value: "\(exercise.sets) × \(exercise.reps)\(exercise.lastSetAmrap ? "+" : "")")
                    }
                }
                .onDelete { day.exercises.remove(atOffsets: $0) }
                .onMove { day.exercises.move(fromOffsets: $0, toOffset: $1) }

                HStack {
                    TextField("Add exercise", text: $newExerciseName)
                        .focused($addFieldFocused)
                        .submitLabel(.done)
                        .onSubmit(addExercise)
                    Button(action: addExercise) {
                        Image(systemName: "plus.circle.fill")
                    }
                    .disabled(newExerciseName.trimmingCharacters(in: .whitespaces).isEmpty)
                    .accessibilityLabel("Add exercise")
                }
            } header: {
                Text("Exercises")
            } footer: {
                Text("New exercises start at 3 × 8. Tap one to change its sets and reps.")
            }
        }
        .navigationTitle(day.name.isEmpty ? "Day" : day.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { EditButton() }
    }

    private func addExercise() {
        let trimmed = newExerciseName.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        day.exercises.append(CustomTemplateExercise(name: trimmed))
        newExerciseName = ""
        addFieldFocused = true
    }
}

private struct TemplateExerciseEditor: View {
    @Binding var exercise: CustomTemplateExercise

    var body: some View {
        Form {
            Section {
                TextField("Exercise name", text: $exercise.name)
            }
            Section {
                Stepper(value: $exercise.sets, in: 1...20) {
                    LabeledContent("Sets", value: "\(exercise.sets)")
                }
                Stepper(value: $exercise.reps, in: 1...100) {
                    LabeledContent("Reps", value: "\(exercise.reps)")
                }
                Toggle("Last set AMRAP", isOn: $exercise.lastSetAmrap)
            } footer: {
                Text("AMRAP: take the last set to as many reps as possible, aiming for at least \(exercise.reps).")
            }
        }
        .navigationTitle(exercise.name.isEmpty ? "Exercise" : exercise.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
