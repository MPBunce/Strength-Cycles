import SwiftUI
import SwiftData

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
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 0) {
                    // Modern header with stats
                    headerView
                    
                    // Sets section
                    setsSection
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle(exercise.name)
            .navigationBarTitleDisplayMode(.large)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveChanges()
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .disabled(editingSets.isEmpty)
                }
            }
            .sheet(isPresented: $showingAddSetSheet) {
                AddSetView { weight, reps in
                    addSet(weight: weight, reps: reps)
                }
            }
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 16) {
            // Stats cards
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
            
            // Progress indicator - replaced ProgressView with custom view
            if !editingSets.isEmpty {
                let completedCount = editingSets.filter { $0.isCompleted }.count
                let progress = Double(completedCount) / Double(editingSets.count)
                
                VStack(spacing: 8) {
                    HStack {
                        Text("Progress")
                            .font(.headline)
                        Spacer()
                        Text("\(completedCount)/\(editingSets.count)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    // Custom progress bar
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
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
            }
        }
        .padding()
    }
    
    private var setsSection: some View {
        VStack(spacing: 0) {
            // Section header
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
            
            // Sets list
            LazyVStack(spacing: 1) {
                ForEach(editingSets.indices, id: \.self) { index in
                    ModernSetRowView(
                        setNumber: index + 1,
                        set: $editingSets[index],
                        focusedField: $focusedField,
                        onDelete: { deleteSet(at: index) }
                    )
                }
            }
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .padding(.horizontal)
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

struct ModernSetRowView: View {
    let setNumber: Int
    @Binding var set: ExerciseSet
    @Binding var focusedField: ExerciseDetailView.FocusField?
    let onDelete: () -> Void
    
    @State private var showingActions = false
    
    private var statusColor: Color {
        switch set.completionStatus {
        case .notStarted: return .secondary
        case .completedSuccessfully: return .green
        case .failed: return .red
        }
    }
    
    var body: some View {
        HStack(spacing: 16) {
            // Set number and status
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
            
            // Input fields
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
            
            Spacer()
            
            // Actions menu
            Menu {
                if set.isCompleted {
                    Button("Reset", action: resetSet)
                }
                
                Button("Delete", role: .destructive, action: onDelete)
            } label: {
                Image(systemName: "ellipsis")
                    .foregroundColor(.secondary)
                    .padding(8)
            }
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
    
    private var statusIcon: String {
        switch set.completionStatus {
        case .notStarted: return "circle"
        case .completedSuccessfully: return "checkmark.circle.fill"
        case .failed: return "xmark.circle.fill"
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
                set.reset()
            }
        }
    }
    
    private func resetSet() {
        withAnimation(.spring(response: 0.3)) {
            set.reset()
        }
    }
}

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
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            // Convert T? to String for TextField
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

// Updated ExerciseRowView to show completion status
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
            HStack {
                Text(exercise.name)
                    .font(.subheadline)
                    .bold()

                Spacer()
                
                // Completion indicators
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
                    
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            // Custom progress bar - replaced ProgressView
            if !exercise.sets.isEmpty {
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

            ForEach(Array(exercise.sets.sorted(by: { $0.setIndex < $1.setIndex }).enumerated()), id: \.element.setIndex) { displayIndex, set in
                HStack {
                    HStack(spacing: 4) {
                        Text("Set \(displayIndex + 1)")
                        
                        // Status indicator
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
        .padding(.vertical, 4)
        .contentShape(Rectangle())
        .onTapGesture {
            showingDetail = true
        }
        .sheet(isPresented: $showingDetail) {
            ExerciseDetailView(
                cycle: cycle,
                dayIndex: dayIndex,
                exerciseIndex: exerciseIndex
            )
        }
    }
}
