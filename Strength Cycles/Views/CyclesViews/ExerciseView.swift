//
//  ExerciseView.swift
//  Strength Cycles
//
//  Created by Matthew Bunce on 2025-06-10.
//

import SwiftUI
import SwiftData

// MARK: - Main View
struct ExerciseView: View {
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
        NavigationStack {
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
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ExerciseDetailToolbar(
                    onCancel: { dismiss() },
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
    let onCancel: () -> Void
    let onSave: () -> Void
    let isSaveDisabled: Bool
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button("Cancel") {
                onCancel()
            }
        }
        
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
    @Binding var focusedField: ExerciseView.FocusField?
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
        .padding(.vertical, 12)
    }
}

// MARK: - Sets List Component
struct SetsList: View {
    @Binding var editingSets: [ExerciseSet]
    @Binding var focusedField: ExerciseView.FocusField?
    let onDeleteSet: (Int) -> Void
    
    var body: some View {
        LazyVStack(spacing: 1) {
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

// MARK: - Stat Card Component (Unchanged)
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
    @Binding var focusedField: ExerciseView.FocusField?
    let onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
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
        .padding()
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
        HStack(spacing: 8) {
            Text("\(setNumber)")
                .font(.headline)
                .fontWeight(.bold)
                .frame(width: 24)
            
            Button(action: toggleSetStatus) {
                Image(systemName: statusIcon)
                    .font(.title2)
                    .foregroundColor(statusColor)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .frame(width: 60)
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
    @Binding var focusedField: ExerciseView.FocusField?
    
    var body: some View {
        HStack(spacing: 12) {
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
                .padding(8)
        }
    }
}

// MARK: - Input Field Component (Unchanged)
struct InputField<T>: View where T: LosslessStringConvertible & Equatable {
    let title: String
    @Binding var value: T?
    let isDisabled: Bool
    let keyboardType: UIKeyboardType
    let formatter: NumberFormatter
    let onTap: () -> Void
    let focusValue: ExerciseView.FocusField
    @Binding var focusedField: ExerciseView.FocusField?
    
    init(
        title: String,
        value: Binding<T?>,
        isDisabled: Bool = false,
        keyboardType: UIKeyboardType = .numberPad,
        formatter: NumberFormatter = NumberFormatter(),
        focusValue: ExerciseView.FocusField,
        focusedField: Binding<ExerciseView.FocusField?>,
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
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
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
            .font(.body)
            .fontWeight(.medium)
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 8)
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
        .frame(width: 80)
    }
}

// MARK: - Add Set View (Unchanged)
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

// MARK: - Exercise Row View (Refactored)
struct ExerciseRowView: View {
    let cycle: Cycles
    let dayIndex: Int
    let exerciseIndex: Int
    @State private var showingDetail = false

    private var exercise: Exercise {
        guard let trainingDay = cycle.trainingDays.first(where: { $0.dayIndex == dayIndex }),
              let exercise = trainingDay.day.first(where: { $0.exerciseIndex == exerciseIndex }) else {
            return Exercise(exerciseIndex: 0, name: "Unknown Exercise", sets: [])
        }
        return exercise
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ExerciseRowHeader(exercise: exercise)
            
            if !exercise.sets.isEmpty {
                ExerciseRowProgress(exercise: exercise)
            }
            
            ExerciseSetsList(exercise: exercise)
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
        .onTapGesture {
            showingDetail = true
        }
        .sheet(isPresented: $showingDetail) {
            ExerciseView(
                cycle: cycle,
                dayIndex: dayIndex,
                exerciseIndex: exerciseIndex
            )
        }
    }
}

// MARK: - Exercise Row Header Component
struct ExerciseRowHeader: View {
    let exercise: Exercise
    
    var body: some View {
        HStack {
            Text(exercise.name)
                .font(.subheadline)
                .bold()

            Spacer()
            
            ExerciseCompletionIndicators(exercise: exercise)
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Exercise Completion Indicators Component
struct ExerciseCompletionIndicators: View {
    let exercise: Exercise
    
    var body: some View {
        HStack(spacing: 4) {
            if exercise.successfulSetsCount > 0 {
                HStack(spacing: 2) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.caption2)
                    Text("\(exercise.successfulSetsCount)")
                        .font(.caption2)
                        .foregroundColor(.green)
                }
            }
            
            if exercise.failedSetsCount > 0 {
                HStack(spacing: 2) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                        .font(.caption2)
                    Text("\(exercise.failedSetsCount)")
                        .font(.caption2)
                        .foregroundColor(.red)
                }
            }
        }
    }
}

// MARK: - Exercise Row Progress Component
struct ExerciseRowProgress: View {
    let exercise: Exercise
    
    var body: some View {
        let progress = exercise.completionPercentage
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 3)
                    .cornerRadius(1.5)
                
                Rectangle()
                    .fill(Color.blue)
                    .frame(width: geometry.size.width * progress, height: 3)
                    .cornerRadius(1.5)
            }
        }
        .frame(height: 3)
    }
}

// MARK: - Exercise Sets List Component
struct ExerciseSetsList: View {
    let exercise: Exercise
    
    var body: some View {
        ForEach(Array(exercise.sets.sorted(by: { $0.setIndex < $1.setIndex }).enumerated()), id: \.element.setIndex) { displayIndex, set in
            ExerciseSetRow(displayIndex: displayIndex, set: set)
        }
    }
}

// MARK: - Exercise Set Row Component
struct ExerciseSetRow: View {
    let displayIndex: Int
    let set: ExerciseSet
    
    var body: some View {
        HStack {
            HStack(spacing: 4) {
                Text("Set \(displayIndex + 1)")
                
                Image(systemName: set.completionStatus == .completedSuccessfully ? "checkmark.circle.fill" :
                      set.completionStatus == .failed ? "xmark.circle.fill" : "circle")
                    .foregroundColor(set.completionStatus == .completedSuccessfully ? .green :
                                   set.completionStatus == .failed ? .red : .secondary)
                    .font(.caption2)
            }
            
            Spacer()
            Text("\(set.reps ?? 0) reps")
                .foregroundColor(set.reps == nil ? .secondary : .primary)
            Text("@ \(set.weight ?? 0, specifier: "%.1f") lbs")
                .foregroundColor(set.weight == nil ? .secondary : .primary)
        }
        .font(.footnote)
        .foregroundColor(set.isCompleted ? (set.wasSuccessful ? .primary : .secondary) : .secondary)
    }
}
