//
//  ExerciseDetailView.swift
//  Strength Cycles
//
//  Created by Matthew Bunce on 2025-06-10.
//

import SwiftUI
import SwiftData

// MARK: - Main Exercise Detail View
struct ExerciseDetailView: View {
    let cycle: Cycles
    let dayIndex: Int
    let exerciseIndex: Int
    
    @Environment(\.dismiss) private var dismiss
    @State private var editingSets: [ExerciseSet]
    @State private var showingAddSetSheet = false
    @State private var focusedField: FocusField?
    
    enum FocusField: Hashable {
        case reps(Int)
        case weight(Int)
    }

    private var exercise: Exercise {
        cycle.trainingDays
            .first(where: { $0.dayIndex == dayIndex })?
            .day.first(where: { $0.exerciseIndex == exerciseIndex }) ?? Exercise(exerciseIndex: 0, name: "", sets: [])
    }

    init(cycle: Cycles, dayIndex: Int, exerciseIndex: Int) {
        self.cycle = cycle
        self.dayIndex = dayIndex
        self.exerciseIndex = exerciseIndex

        let exercise = cycle.trainingDays
            .first(where: { $0.dayIndex == dayIndex })?
            .day.first(where: { $0.exerciseIndex == exerciseIndex }) ?? Exercise(exerciseIndex: 0, name: "", sets: [])

        self._editingSets = State(initialValue: exercise.sets.sorted(by: { $0.setIndex < $1.setIndex }))
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                //ExerciseStatsHeader(editingSets: editingSets)
                ExerciseSetsSection(
                    editingSets: $editingSets,
                    focusedField: $focusedField,
                    showingAddSetSheet: $showingAddSetSheet,
                    onDeleteSet: deleteSet
                )
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(exercise.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ExerciseDetailToolbar(
                onSave: { saveChanges(); dismiss() },
                isSaveDisabled: editingSets.isEmpty
            )
        }
        .sheet(isPresented: $showingAddSetSheet) {
            AddSetView { weight, reps in
                addSet(weight: weight, reps: reps)
            }
        }
    }

    private func addSet(weight: Double?, reps: Int?) {
        let nextIndex = (editingSets.map { $0.setIndex }.max() ?? -1) + 1
        let newSet = ExerciseSet(
            setIndex: nextIndex,
            weight: weight,
            reps: reps,
            isEditable: true,
            completionStatus: .notStarted
        )
        withAnimation(.spring()) {
            editingSets.append(newSet)
        }
    }

    private func deleteSet(at index: Int) {
        withAnimation(.spring()) {
            editingSets.remove(at: index)
            
            // Reindex remaining sets
            for (i, set) in editingSets.enumerated() {
                set.setIndex = i
            }
        }
    }

    private func saveChanges() {
        guard let day = cycle.trainingDays.first(where: { $0.dayIndex == dayIndex }) else { return }
        guard let exercise = day.day.first(where: { $0.exerciseIndex == exerciseIndex }) else { return }
        exercise.sets = editingSets
    }
}

// MARK: - Toolbar Component
struct ExerciseDetailToolbar: ToolbarContent {
    let onSave: () -> Void
    let isSaveDisabled: Bool
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button("Save") {
                onSave()
            }
            .fontWeight(.semibold)
            .disabled(isSaveDisabled)
        }
    }
}

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
    @Binding var focusedField: ExerciseDetailView.FocusField?
    @Binding var showingAddSetSheet: Bool
    let onDeleteSet: (Int) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            SetsSectionHeader(showingAddSetSheet: $showingAddSetSheet)
            SetsList(
                editingSets: $editingSets,
                focusedField: $focusedField,
                onDeleteSet: onDeleteSet
            )
        }
    }
}

// MARK: - Sets Section Header Component
struct SetsSectionHeader: View {
    @Binding var showingAddSetSheet: Bool
    
    var body: some View {
        HStack {
            Text("Sets")
                .font(.title2)
                .fontWeight(.bold)
            
            Spacer()
            
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
        .padding(.horizontal)
        .padding(.vertical, 8) // Reduced from 12
    }
}

// MARK: - Sets List Component
struct SetsList: View {
    @Binding var editingSets: [ExerciseSet]
    @Binding var focusedField: ExerciseDetailView.FocusField?
    let onDeleteSet: (Int) -> Void
    
    var body: some View {
        LazyVStack(spacing: 0) { // Reduced from 1
            ForEach(editingSets.indices, id: \.self) { index in
                ModernSetRowView(
                    setNumber: index + 1,
                    set: $editingSets[index],
                    focusedField: $focusedField,
                    onDelete: { onDeleteSet(index) }
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
    let setNumber: Int
    @Binding var set: ExerciseSet
    @Binding var focusedField: ExerciseDetailView.FocusField?
    let onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 12) { // Reduced from 16
            SetNumberAndStatus(
                setNumber: setNumber,
                set: $set
            )
            
            SetInputFields(
                set: $set,
                focusedField: $focusedField
            )
            
            Spacer()
            
            SetActionsMenu(
                set: set,
                onDelete: onDelete,
                onReset: { resetSet() }
            )
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8) // Reduced from default padding
        .background(set.isCompleted ? Color.gray.opacity(0.05) : Color.clear)
        .overlay(
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(Color(.separator)),
            alignment: .bottom
        )
        .contentShape(Rectangle())
        .onTapGesture {
            if !set.isCompleted {
                focusedField = set.reps == nil ? .reps(set.setIndex) : .weight(set.setIndex)
            }
        }
    }
    
    private func resetSet() {
        withAnimation(.spring(response: 0.3)) {
            set.reset()
        }
    }
}

// MARK: - Set Number and Status Component
struct SetNumberAndStatus: View {
    let setNumber: Int
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
        HStack(spacing: 6) { // Reduced from 8
            Text("\(setNumber)")
                .font(.subheadline) // Reduced from .headline
                .fontWeight(.semibold) // Reduced from .bold
                .frame(width: 20) // Reduced from 24
            
            Button(action: toggleSetStatus) {
                Image(systemName: statusIcon)
                    .font(.title3) // Reduced from .title2
                    .foregroundColor(statusColor)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .frame(width: 50) // Reduced from 60
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

// MARK: - Set Input Fields Component
struct SetInputFields: View {
    @Binding var set: ExerciseSet
    @Binding var focusedField: ExerciseDetailView.FocusField?
    
    var body: some View {
        HStack(spacing: 8) { // Reduced from 12
            InputField(
                title: "Reps",
                value: $set.reps,
                isDisabled: !set.isEditable || set.isCompleted,
                keyboardType: .numberPad,
                focusValue: .reps(set.setIndex),
                focusedField: $focusedField
            ) {
                focusedField = .reps(set.setIndex)
            }
            
            InputField(
                title: "Weight",
                value: $set.weight,
                isDisabled: !set.isEditable || set.isCompleted,
                keyboardType: .decimalPad,
                formatter: {
                    let formatter = NumberFormatter()
                    formatter.numberStyle = .decimal
                    formatter.maximumFractionDigits = 1
                    return formatter
                }(),
                focusValue: .weight(set.setIndex),
                focusedField: $focusedField
            ) {
                focusedField = .weight(set.setIndex)
            }
        }
    }
}

// MARK: - Set Actions Menu Component
struct SetActionsMenu: View {
    let set: ExerciseSet
    let onDelete: () -> Void
    let onReset: () -> Void
    
    var body: some View {
        Menu {
            if set.isCompleted {
                Button("Reset", action: onReset)
            }
            
            Button("Delete", role: .destructive, action: onDelete)
        } label: {
            Image(systemName: "ellipsis")
                .foregroundColor(.secondary)
                .padding(4) // Reduced from 8
        }
    }
}

// MARK: - Input Field Component
struct InputField<T>: View where T: LosslessStringConvertible & Equatable {
    let title: String
    @Binding var value: T?
    let isDisabled: Bool
    let keyboardType: UIKeyboardType
    let formatter: NumberFormatter
    let onTap: () -> Void
    let focusValue: ExerciseDetailView.FocusField
    @Binding var focusedField: ExerciseDetailView.FocusField?
    
    init(
        title: String,
        value: Binding<T?>,
        isDisabled: Bool = false,
        keyboardType: UIKeyboardType = .numberPad,
        formatter: NumberFormatter = NumberFormatter(),
        focusValue: ExerciseDetailView.FocusField,
        focusedField: Binding<ExerciseDetailView.FocusField?>,
        onTap: @escaping () -> Void = {}
    ) {
        self.title = title
        self._value = value
        self.isDisabled = isDisabled
        self.keyboardType = keyboardType
        self.formatter = formatter
        self.focusValue = focusValue
        self._focusedField = focusedField
        self.onTap = onTap
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) { // Reduced from 4
            Text(title)
                .font(.caption2) // Reduced from .caption
                .foregroundColor(.secondary)
            
            TextField("0", text: Binding(
                get: {
                    if let value = value {
                        return String(value)
                    }
                    return ""
                },
                set: { newValue in
                    if newValue.isEmpty {
                        value = nil
                    } else if let converted = T(newValue) {
                        value = converted
                    }
                }
            ))
            .textFieldStyle(PlainTextFieldStyle())
            .font(.callout) // Reduced from .body
            .fontWeight(.medium)
            .padding(6) // Reduced from 8
            .background(
                RoundedRectangle(cornerRadius: 6) // Reduced from 8
                    .fill(isDisabled ? Color(.systemGray5) : Color(.systemGray6))
            )
            .keyboardType(keyboardType)
            .disabled(isDisabled)
            .opacity(isDisabled ? 0.6 : 1.0)
            .onTapGesture {
                if !isDisabled {
                    focusedField = focusValue
                    onTap()
                }
            }
        }
        .frame(width: 65) // Reduced from 80
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
