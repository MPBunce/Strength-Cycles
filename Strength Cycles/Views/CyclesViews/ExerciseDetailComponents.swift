//
//  ExerciseDetailComponents.swift
//  Strength Cycles
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
    @Binding var editingSets: [ExerciseSet]
    @Binding var showingAddSetSheet: Bool
    let canAlterSets: Bool
    let onDeleteSet: (Int) -> Void
    let onEditSet: (Int) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            SetsSectionHeader(
                showingAddSetSheet: $showingAddSetSheet,
                canAddSets: canAlterSets
            )
            SetsList(
                editingSets: $editingSets,
                canAlterSets: canAlterSets,
                onDeleteSet: onDeleteSet,
                onEditSet: onEditSet
            )
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
    @Binding var editingSets: [ExerciseSet]
    let canAlterSets: Bool
    let onDeleteSet: (Int) -> Void
    let onEditSet: (Int) -> Void
    
    var body: some View {
        LazyVStack(spacing: 0) {
            ForEach(editingSets.indices, id: \.self) { index in
                ModernSetRowView(
                    set: $editingSets[index],
                    canDelete: canAlterSets,
                    onDelete: { onDeleteSet(index) },
                    onEdit: { onEditSet(index) }
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
    @Binding var set: ExerciseSet
    let canDelete: Bool
    let onDelete: () -> Void
    let onEdit: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            SetStatusButton(set: $set)
            
            SetDisplayValues(set: set)
            
            Spacer()
            
            SetActionsMenu(
                set: set,
                canDelete: canDelete,
                canEdit: set.isEditable || set.isAmrap, // Allow editing for AMRAP sets too
                onDelete: onDelete,
                onEdit: onEdit,
                onReset: { resetSet() }
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
            // Tap to toggle completion status
            toggleSetStatus()
        }
    }
    
    private func resetSet() {
        withAnimation(.spring(response: 0.3)) {
            set.reset()
        }
    }
    
    private func toggleSetStatus() {
        withAnimation(.spring(response: 0.3)) {
            switch set.completionStatus {
            case .notStarted:
                set.markAsCompleted()
            case .completedSuccessfully:
                set.markAsFailed()
            case .failed:
                set.markAsCompleted()
            }
        }
    }
}

// MARK: - Set Status Button Component
struct SetStatusButton: View {
    @Binding var set: ExerciseSet
    
    private var statusColor: Color {
        switch set.completionStatus {
        case .notStarted: return .secondary
        case .completedSuccessfully: return .green
        case .failed: return .red
        }
    }
    
    private var statusIcon: String {
        switch set.completionStatus {
        case .notStarted: return "circle"
        case .completedSuccessfully: return "checkmark.circle.fill"
        case .failed: return "xmark.circle.fill"
        }
    }
    
    var body: some View {
        Button(action: toggleSetStatus) {
            Image(systemName: statusIcon)
                .font(.title2)
                .foregroundColor(statusColor)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func toggleSetStatus() {
        withAnimation(.spring(response: 0.3)) {
            switch set.completionStatus {
            case .notStarted:
                set.markAsCompleted()
            case .completedSuccessfully:
                set.markAsFailed()
            case .failed:
                set.reset()
            }
        }
    }
}

// MARK: - Set Display Values Component
struct SetDisplayValues: View {
    let set: ExerciseSet
    
    var body: some View {
        HStack(spacing: 8) {
            // Main display: weight x reps format
            HStack(spacing: 4) {
                Text(set.weight != nil ? String(format: "%.1f", set.weight!) : "—")
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(set.weight != nil ? .primary : .secondary)
                
                Text("×")
                    .font(.body)
                    .foregroundColor(.secondary)
                
                Text(set.reps != nil ? "\(set.reps!)" : "—")
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(set.reps != nil ? .primary : .secondary)
                
                if set.isAmrap {
                        Text("+")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
            }

            // Tags/indicators
            HStack(spacing: 6) {
                if set.isAmrap {
                    Text("AMRAP")
                        .font(.caption2)
                        .fontWeight(.medium)
                        .foregroundColor(.orange)
                        .padding(.horizontal, 4)
                        .padding(.vertical, 1)
                        .background(Color.orange.opacity(0.15))
                        .cornerRadius(3)
                }
                if let target = set.amrapTargetReps {
                    Text("Target: \(target)")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
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
                Button("Edit", action: onEdit)
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
                .padding(8)
        }
        .disabled(!canEdit && !canDelete && !set.isCompleted)
    }
}

// MARK: - Add Set View
struct AddSetView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var weight: String = ""
    @State private var reps: String = ""
    @FocusState private var focusedField: Field?
    
    let onAdd: (Double?, Int?) -> Void
    
    enum Field {
        case weight, reps
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("Add New Set")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top)
                
                VStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Reps")
                            .font(.headline)
                        
                        TextField("Enter reps", text: $reps)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                            .focused($focusedField, equals: .reps)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Weight (lbs)")
                            .font(.headline)
                        
                        TextField("Enter weight", text: $weight)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.decimalPad)
                            .focused($focusedField, equals: .weight)
                    }
                }
                .padding()
                
                Spacer()
                
                Button("Add Set") {
                    let weightValue = Double(weight)
                    let repsValue = Int(reps)
                    onAdd(weightValue, repsValue)
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .disabled(weight.isEmpty && reps.isEmpty)
                
                Button("Cancel") {
                    dismiss()
                }
                .buttonStyle(.bordered)
            }
            .padding()
            .onAppear {
                focusedField = .reps
            }
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
}

// MARK: - Regular Set Edit View
struct EditRegularSetView: View {
    @Environment(\.dismiss) private var dismiss
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
        self._weight = State(initialValue: initialWeight != nil ? String(format: "%.1f", initialWeight!) : "")
        self._reps = State(initialValue: initialReps != nil ? "\(initialReps!)" : "")
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                VStack(spacing: 8) {
                    Text("Edit Set")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    if !isEditable {
                        HStack {
                            Image(systemName: "lock.fill")
                                .foregroundColor(.secondary)
                            Text("This set cannot be edited")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 6)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    }
                }
                .padding(.top)
                
                VStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Reps")
                            .font(.headline)
                        
                        TextField("Enter reps", text: $reps)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                            .focused($focusedField, equals: .reps)
                            .disabled(!isEditable)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Weight (lbs)")
                            .font(.headline)
                        
                        TextField("Enter weight", text: $weight)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.decimalPad)
                            .focused($focusedField, equals: .weight)
                            .disabled(!isEditable)
                    }
                }
                .padding()
                
                Spacer()
                
                if isEditable {
                    Button("Save Changes") {
                        let weightValue = weight.isEmpty ? nil : Double(weight)
                        let repsValue = reps.isEmpty ? nil : Int(reps)
                        onSave(weightValue, repsValue)
                    }
                    .buttonStyle(.borderedProminent)
                }
                
                Button("Cancel") {
                    onCancel()
                }
                .buttonStyle(.bordered)
            }
            .padding()
            .onAppear {
                if isEditable {
                    focusedField = .reps
                }
            }
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
}

// MARK: - Edit Set Sheet View (Completely Rewritten)
struct EditSetSheetView: View {
    let set: ExerciseSet
    let setIndex: Int
    let onUpdateAmrap: (Int, Int?) -> Void
    let onUpdateRegular: (Int, Double?, Int?) -> Void
    let onCancel: () -> Void
    
    var body: some View {
        // Add debugging
        let _ = print("🟢 EditSetSheetView created for index \(setIndex), isAmrap: \(set.isAmrap)")
        
        if set.isAmrap {
            EditAmrapSetView(
                initialReps: set.reps,
                weight: set.weight,
                onSave: { reps in
                    print("🟢 AMRAP save called with reps: \(reps?.description ?? "nil")")
                    onUpdateAmrap(setIndex, reps)
                },
                onCancel: {
                    print("🟢 AMRAP cancel called")
                    onCancel()
                }
            )
        } else {
            EditRegularSetView(
                initialWeight: set.weight,
                initialReps: set.reps,
                isEditable: set.isEditable,
                onSave: { weight, reps in
                    print("🟢 Regular save called with weight: \(weight?.description ?? "nil"), reps: \(reps?.description ?? "nil")")
                    onUpdateRegular(setIndex, weight, reps)
                },
                onCancel: {
                    print("🟢 Regular cancel called")
                    onCancel()
                }
            )
        }
    }
}

// MARK: - AMRAP Set Edit View
struct EditAmrapSetView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var actualReps: String
    @FocusState private var isTextFieldFocused: Bool
    
    let weight: Double?
    let onSave: (Int?) -> Void
    let onCancel: () -> Void
    
    init(initialReps: Int?, weight: Double?, onSave: @escaping (Int?) -> Void, onCancel: @escaping () -> Void) {
        self.weight = weight
        self.onSave = onSave
        self.onCancel = onCancel
        self._actualReps = State(initialValue: initialReps != nil ? "\(initialReps!)" : "")
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Header Section
                VStack(spacing: 12) {
                    Text("AMRAP Set")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    // AMRAP Info Card
                    VStack(spacing: 8) {
                        HStack {
                            Image(systemName: "target")
                                .foregroundColor(.orange)
                            Text("As Many Reps As Possible")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.orange)
                        }
                        
                        if let w = weight {
                            Text("Weight: \(String(format: "%.1f", w)) lbs")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(12)
                }
                .padding(.top)
                
                // Input Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Actual Reps Achieved")
                        .font(.headline)
                    
                    TextField("Enter reps completed", text: $actualReps)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .focused($isTextFieldFocused)
                        .font(.title3)
                }
                .padding()
                
                Spacer()
                
                // Action Buttons
                VStack(spacing: 12) {
                    Button("Save Reps") {
                        let repsValue = actualReps.isEmpty ? nil : Int(actualReps)
                        onSave(repsValue)
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(actualReps.isEmpty)
                    
                    Button("Cancel") {
                        onCancel()
                        dismiss()
                    }
                    .buttonStyle(.bordered)
                }
                .padding(.bottom)
            }
            .padding()
            .onAppear {
                // Auto-focus the text field
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isTextFieldFocused = true
                }
            }
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
}
