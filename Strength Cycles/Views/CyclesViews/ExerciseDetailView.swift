import SwiftUI
import SwiftData

struct ExerciseDetailView: View {
    let cycle: Cycles
    let dayIndex: Int
    let exerciseIndex: Int
    
    @Environment(\.dismiss) private var dismiss
    @State private var editingSets: [ExerciseSet]

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
        NavigationView {
            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(exercise.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text("\(editingSets.count) sets")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemGray6))

                List {
                    ForEach(editingSets.indices, id: \.self) { i in
                        SetRowView(
                            setNumber: i + 1,
                            set: $editingSets[i]
                        )
                    }
                    .onDelete(perform: deleteSets)

                    Button(action: addSet) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.blue)
                            Text("Add Set")
                                .foregroundColor(.blue)
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
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
                }
            }
        }
    }

    private func addSet() {
        // Find the next available setIndex
        let nextIndex = (editingSets.map { $0.setIndex }.max() ?? -1) + 1
        let newSet = ExerciseSet(setIndex: nextIndex, weight: nil, reps: nil)
        editingSets.append(newSet)
    }

    private func deleteSets(at offsets: IndexSet) {
        // Remove the sets
        editingSets.remove(atOffsets: offsets)
        
        // Reassign setIndex to maintain order and uniqueness
        for (i, set) in editingSets.enumerated() {
            set.setIndex = i
        }
    }

    private func saveChanges() {
        guard let day = cycle.trainingDays.first(where: { $0.dayIndex == dayIndex }) else { return }
        guard let exercise = day.day.first(where: { $0.exerciseIndex == exerciseIndex }) else { return }
        exercise.sets = editingSets
    }
}


struct SetRowView: View {
    let setNumber: Int
    @Binding var set: ExerciseSet
    
    var body: some View {
        HStack(spacing: 16) {
            // Set number
            Text("Set \(setNumber)")
                .font(.headline)
                .frame(width: 60, alignment: .leading)
            
            // Reps input
            VStack(alignment: .leading, spacing: 4) {
                Text("Reps")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                TextField("0", value: $set.reps, formatter: NumberFormatter())
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .frame(width: 80)
            }

            // Weight input
            VStack(alignment: .leading, spacing: 4) {
                Text("Weight (lbs)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                TextField("0", value: $set.weight, formatter: {
                    let formatter = NumberFormatter()
                    formatter.numberStyle = .decimal
                    formatter.maximumFractionDigits = 1
                    return formatter
                }())
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.decimalPad)
                .frame(width: 100)
            }

            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

// Usage in your main view - replace the exercise VStack with this:
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
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(exercise.name)
                    .font(.subheadline)
                    .bold()

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            ForEach(Array(exercise.sets.sorted(by: { $0.setIndex < $1.setIndex }).enumerated()), id: \.element.setIndex) { displayIndex, set in
                HStack {
                    Text("Set \(displayIndex + 1)")
                    Spacer()
                    Text("\(set.reps ?? 0) reps")
                        .foregroundColor(set.reps == nil ? .secondary : .primary)
                    Text("@ \(set.weight ?? 0, specifier: "%.1f") lbs")
                        .foregroundColor(set.weight == nil ? .secondary : .primary)
                }
                .font(.footnote)
                .foregroundColor(.secondary)
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
