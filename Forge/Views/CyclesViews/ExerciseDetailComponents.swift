//
//  ExerciseDetailComponents.swift
//  Forge
//
//  Created by Matthew Bunce on 2025-06-10.
//

import SwiftUI
import Foundation
import SwiftData

// MARK: - Stats Header Component
struct ExerciseStatsHeader: View {
    let editingSets: [ExerciseSet]
    
    var body: some View {
        VStack(spacing: 16) {
            ExerciseStatsCards(editingSets: editingSets)
            
            if !editingSets.isEmpty {
                ExerciseProgressIndicator(editingSets: editingSets)
            }
        }
        .padding()
    }
}

// MARK: - Stats Cards Component
struct ExerciseStatsCards: View {
    let editingSets: [ExerciseSet]
    
    var body: some View {
        HStack(spacing: 12) {
            StatCard(
                title: "Total Sets",
                value: "\(editingSets.count)",
                color: .blue,
                icon: "list.number"
            )
            
            StatCard(
                title: "Completed",
                value: "\(editingSets.filter { $0.wasSuccessful }.count)",
                color: .green,
                icon: "checkmark.circle.fill"
            )
            
            StatCard(
                title: "Failed",
                value: "\(editingSets.filter { $0.completionStatus == .failed }.count)",
                color: .red,
                icon: "xmark.circle.fill"
            )
        }
    }
}

// MARK: - Progress Indicator Component
struct ExerciseProgressIndicator: View {
    let editingSets: [ExerciseSet]
    
    private var progress: Double {
        let completedCount = editingSets.filter { $0.isCompleted }.count
        return Double(completedCount) / Double(editingSets.count)
    }
    
    private var completedCount: Int {
        editingSets.filter { $0.isCompleted }.count
    }
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Progress")
                    .font(.headline)
                Spacer()
                Text("\(completedCount)/\(editingSets.count)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            CustomProgressBar(progress: progress)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
}

// MARK: - Custom Progress Bar Component
struct CustomProgressBar: View {
    let progress: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 8)
                    .cornerRadius(4)
                
                Rectangle()
                    .fill(Color.blue)
                    .frame(width: geometry.size.width * progress, height: 8)
                    .cornerRadius(4)
            }
        }
        .frame(height: 8)
    }
}

// MARK: - Sets Section Component
struct ExerciseSetsSection: View {
    let sets: [ExerciseSet]
    @Binding var showingAddSetSheet: Bool
    let canAlterSets: Bool
    let onDeleteSet: (ExerciseSet) -> Void
    let onEditSet: (ExerciseSet) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            SetsSectionHeader(
                showingAddSetSheet: $showingAddSetSheet,
                canAddSets: canAlterSets
            )
            if sets.isEmpty {
                Text(canAlterSets ? "No sets yet. Tap Add Set to log one." : "No sets for this exercise.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 32)
            } else {
                SetsList(
                    sets: sets,
                    canAlterSets: canAlterSets,
                    onDeleteSet: onDeleteSet,
                    onEditSet: onEditSet
                )
            }
        }
    }
}

// MARK: - Sets Section Header Component
struct SetsSectionHeader: View {
    @Binding var showingAddSetSheet: Bool
    let canAddSets: Bool
    
    var body: some View {
        HStack {
            Text("Sets")
                .font(.title2)
                .fontWeight(.bold)
            
            Spacer()
            
            if canAddSets {
                Button(action: { showingAddSetSheet = true }) {
                    HStack(spacing: 4) {
                        Image(systemName: "plus")
                        Text("Add Set")
                    }
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.blue)
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

// MARK: - Sets List Component
struct SetsList: View {
    let sets: [ExerciseSet]
    let canAlterSets: Bool
    let onDeleteSet: (ExerciseSet) -> Void
    let onEditSet: (ExerciseSet) -> Void
    
    var body: some View {
        LazyVStack(spacing: 0) {
            ForEach(Array(sets.enumerated()), id: \.element.persistentModelID) { index, set in
                ModernSetRowView(
                    set: set,
                    number: index + 1,
                    canDelete: canAlterSets,
                    onDelete: { onDeleteSet(set) },
                    onEdit: { onEditSet(set) }
                )
            }
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

// MARK: - Stat Card Component
struct StatCard: View {
    let title: String
    let value: String
    let color: Color
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
}

// MARK: - Modern Set Row Component
struct ModernSetRowView: View {
    let set: ExerciseSet
    let number: Int
    let canDelete: Bool
    let onDelete: () -> Void
    let onEdit: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            SetStatusButton(set: set)
            
            Text("\(number)")
                .font(.caption)
                .foregroundColor(.secondary)
                .monospacedDigit()
                .frame(width: 16)
            
            SetDisplayValues(set: set)
            
            Spacer(minLength: 0)
            
            SetActionsMenu(
                set: set,
                canDelete: canDelete,
                canEdit: set.isEditable || set.isAmrap,
                onDelete: onDelete,
                onEdit: onEdit,
                onReset: { withAnimation(.spring(response: 0.3)) { set.reset() } }
            )
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(set.isCompleted ? Color.gray.opacity(0.05) : Color.clear)
        .overlay(
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(Color(.separator)),
            alignment: .bottom
        )
        .contentShape(Rectangle())
        .onTapGesture {
            // AMRAP sets are logged by entering reps, so tapping the row opens that sheet instead.
            if set.isAmrap {
                onEdit()
            } else {
                withAnimation(.spring(response: 0.3)) { set.cycleStatus() }
            }
        }
    }
}

// MARK: - Set Status Button Component
struct SetStatusButton: View {
    let set: ExerciseSet
    
    private var statusColor: Color {
        switch set.completionStatus {
        case .notStarted: return .secondary
        case .completedSuccessfully: return .green
        case .failed: return .red
        }
    }
    
    private var statusIcon: String {
        if set.isAmrap && set.completionStatus == .notStarted {
            return "circle.dashed"
        }
        
        switch set.completionStatus {
        case .notStarted: return "circle"
        case .completedSuccessfully: return "checkmark.circle.fill"
        case .failed: return "xmark.circle.fill"
        }
    }
    
    var body: some View {
        Image(systemName: statusIcon)
            .font(.title2)
            .foregroundColor(statusColor)
            .accessibilityLabel(set.completionStatus == .notStarted ? "Not done" : set.wasSuccessful ? "Done" : "Failed")
    }
}

// MARK: - Set Display Values Component
struct SetDisplayValues: View {
    let set: ExerciseSet
    
    var body: some View {
        HStack(spacing: 8) {
            HStack(spacing: 4) {
                Text(set.weight.map { WeightConverter.format($0) } ?? "—")
                    .fontWeight(.medium)
                    .foregroundColor(set.weight != nil ? .primary : .secondary)
                
                Text("×")
                    .foregroundColor(.secondary)
                
                Text(set.reps.map { "\($0)" } ?? "—")
                    .fontWeight(.medium)
                    .foregroundColor(set.reps != nil ? .primary : .secondary)
            }
            .font(.body)
            .monospacedDigit()

            if set.isAmrap {
                Text(set.amrapTargetReps.map { "AMRAP \($0)+" } ?? "AMRAP")
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(.orange)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.orange.opacity(0.15))
                    .cornerRadius(4)
            }
        }
    }
}

// MARK: - Set Actions Menu Component
struct SetActionsMenu: View {
    let set: ExerciseSet
    let canDelete: Bool
    let canEdit: Bool
    let onDelete: () -> Void
    let onEdit: () -> Void
    let onReset: () -> Void
    
    var body: some View {
        Menu {
            if canEdit {
                Button(set.isAmrap ? "Log Reps" : "Edit", action: onEdit)
            }
            
            if set.isCompleted {
                Button("Reset", action: onReset)
            }
            
            if canDelete {
                Button("Delete", role: .destructive, action: onDelete)
            }
        } label: {
            Image(systemName: "ellipsis")
                .foregroundColor(.secondary)
                .frame(width: 32, height: 32)
                .contentShape(Rectangle())
        }
        .disabled(!canEdit && !canDelete && !set.isCompleted)
    }
}

// MARK: - Shared sheet layout
// Confirm/Cancel live in the navigation bar so the number pad (which has no return key)
// can never cover them.
private struct SetSheet<Content: View>: View {
    let title: String
    let confirmTitle: String
    let confirmDisabled: Bool
    let onConfirm: () -> Void
    let onCancel: () -> Void
    @ViewBuilder let content: Content
    
    var body: some View {
        NavigationStack {
            Form { content }
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel", action: onCancel)
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button(confirmTitle, action: onConfirm)
                            .fontWeight(.semibold)
                            .disabled(confirmDisabled)
                    }
                }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}

// MARK: - Add Set View
struct AddSetView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.weightUnit) private var unit
    @State private var weight: String = ""
    @State private var reps: String = ""
    @FocusState private var focusedField: Field?
    
    let onAdd: (Double?, Int?) -> Void
    
    enum Field {
        case weight, reps
    }
    
    private var isValid: Bool {
        (!reps.isEmpty || !weight.isEmpty)
            && (reps.isEmpty || Int(reps) != nil)
            && (weight.isEmpty || Double(weight) != nil)
    }
    
    var body: some View {
        SetSheet(
            title: "Add Set",
            confirmTitle: "Add",
            confirmDisabled: !isValid,
            onConfirm: {
                onAdd(Double(weight), Int(reps))
                dismiss()
            },
            onCancel: { dismiss() }
        ) {
            LabeledContent("Reps") {
                TextField("0", text: $reps)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.trailing)
                    .focused($focusedField, equals: .reps)
            }
            LabeledContent("Weight (\(unit))") {
                TextField("Optional", text: $weight)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
                    .focused($focusedField, equals: .weight)
            }
        }
        .onAppear { focusedField = .reps }
    }
}

// MARK: - Regular Set Edit View
struct EditRegularSetView: View {
    @Environment(\.weightUnit) private var unit
    @State private var weight: String
    @State private var reps: String
    @FocusState private var focusedField: Field?
    
    let isEditable: Bool
    let onSave: (Double?, Int?) -> Void
    let onCancel: () -> Void
    
    enum Field {
        case weight, reps
    }
    
    init(initialWeight: Double?, initialReps: Int?, isEditable: Bool, onSave: @escaping (Double?, Int?) -> Void, onCancel: @escaping () -> Void) {
        self.isEditable = isEditable
        self.onSave = onSave
        self.onCancel = onCancel
        self._weight = State(initialValue: initialWeight.map { WeightConverter.format($0) } ?? "")
        self._reps = State(initialValue: initialReps.map { "\($0)" } ?? "")
    }
    
    private var isValid: Bool {
        isEditable
            && (reps.isEmpty || Int(reps) != nil)
            && (weight.isEmpty || Double(weight) != nil)
    }
    
    var body: some View {
        SetSheet(
            title: "Edit Set",
            confirmTitle: "Save",
            confirmDisabled: !isValid,
            onConfirm: {
                onSave(weight.isEmpty ? nil : Double(weight), reps.isEmpty ? nil : Int(reps))
            },
            onCancel: onCancel
        ) {
            if !isEditable {
                Label("This set is set by the program and can't be edited", systemImage: "lock.fill")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            LabeledContent("Reps") {
                TextField("0", text: $reps)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.trailing)
                    .focused($focusedField, equals: .reps)
                    .disabled(!isEditable)
            }
            LabeledContent("Weight (\(unit))") {
                TextField("Optional", text: $weight)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
                    .focused($focusedField, equals: .weight)
                    .disabled(!isEditable)
            }
        }
        .onAppear {
            if isEditable { focusedField = .reps }
        }
    }
}

// MARK: - Edit Set Sheet View
struct EditSetSheetView: View {
    let set: ExerciseSet
    let onUpdateAmrap: (Int?, Double?) -> Void
    let onUpdateRegular: (Double?, Int?) -> Void
    let onCancel: () -> Void
    
    var body: some View {
        if set.isAmrap {
            EditAmrapSetView(
                initialReps: set.reps,
                weight: set.weight,
                isWeightEditable: set.isEditable,
                targetReps: set.amrapTargetReps,
                onSave: onUpdateAmrap,
                onCancel: onCancel
            )
        } else {
            EditRegularSetView(
                initialWeight: set.weight,
                initialReps: set.reps,
                isEditable: set.isEditable,
                onSave: onUpdateRegular,
                onCancel: onCancel
            )
        }
    }
}

// MARK: - AMRAP Set Edit View
struct EditAmrapSetView: View {
    @Environment(\.weightUnit) private var unit
    @State private var actualReps: String
    @State private var weightText: String
    @FocusState private var isTextFieldFocused: Bool
    
    let weight: Double?
    let isWeightEditable: Bool
    let targetReps: Int?
    let onSave: (Int?, Double?) -> Void
    let onCancel: () -> Void
    
    init(initialReps: Int?, weight: Double?, isWeightEditable: Bool, targetReps: Int?, onSave: @escaping (Int?, Double?) -> Void, onCancel: @escaping () -> Void) {
        self.weight = weight
        self.isWeightEditable = isWeightEditable
        self.targetReps = targetReps
        self.onSave = onSave
        self.onCancel = onCancel
        self._actualReps = State(initialValue: initialReps.map { "\($0)" } ?? "")
        self._weightText = State(initialValue: weight.map { WeightConverter.format($0) } ?? "")
    }
    
    private var isValid: Bool {
        Int(actualReps) != nil && (weightText.isEmpty || Double(weightText) != nil)
    }
    
    var body: some View {
        SetSheet(
            title: "AMRAP Set",
            confirmTitle: "Save",
            confirmDisabled: !isValid,
            onConfirm: { onSave(Int(actualReps), isWeightEditable ? Double(weightText) : weight) },
            onCancel: onCancel
        ) {
            Section {
                if isWeightEditable {
                    LabeledContent("Weight (\(unit))") {
                        TextField("Optional", text: $weightText)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                } else if let w = weight {
                    LabeledContent("Weight", value: "\(WeightConverter.format(w)) \(unit)")
                }
                if let target = targetReps {
                    LabeledContent("Target", value: "\(target)+ reps")
                }
            } footer: {
                Text("As many reps as possible with good form.")
            }
            
            Section {
                LabeledContent("Reps achieved") {
                    TextField("0", text: $actualReps)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                        .focused($isTextFieldFocused)
                }
                if let target = targetReps, let current = Int(actualReps) {
                    Label(current >= target ? "Target achieved" : "Below target",
                          systemImage: current >= target ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .font(.caption)
                        .foregroundColor(current >= target ? .green : .red)
                }
            }
        }
        .onAppear { isTextFieldFocused = true }
    }
}
