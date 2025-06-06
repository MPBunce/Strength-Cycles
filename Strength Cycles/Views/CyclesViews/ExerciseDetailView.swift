import SwiftUI

struct ExerciseDetailView: View {
    let cycle: Cycles
    let dayIndex: Int
    let exerciseIndex: Int
    @Environment(\.dismiss) private var dismiss
    @State private var editingSets: [ExerciseSet]
    
    private var exercise: Exercise {
        cycle.trainingDays[dayIndex].day[exerciseIndex]
    }
    
    init(cycle: Cycles, dayIndex: Int, exerciseIndex: Int) {
        self.cycle = cycle
        self.dayIndex = dayIndex
        self.exerciseIndex = exerciseIndex
        self._editingSets = State(initialValue: cycle.trainingDays[dayIndex].day[exerciseIndex].sets)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header with exercise name
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
                
                // Sets list
                List {
                    ForEach(editingSets.indices, id: \.self) { index in
                        SetRowView(
                            setNumber: index + 1,
                            set: $editingSets[index]
                        )
                    }
                    .onDelete(perform: deleteSets)
                    
                    // Add set button
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
        let newSet = ExerciseSet(weight: 0.0, reps: 10)
        editingSets.append(newSet)
    }
    
    private func deleteSets(at offsets: IndexSet) {
        editingSets.remove(atOffsets: offsets)
    }
    
    private func saveChanges() {
        cycle.trainingDays[dayIndex].day[exerciseIndex].sets = editingSets
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
                
                TextField("0", text: Binding(
                    get: { String(Int(set.reps)) },
                    set: { newValue in
                        if let intValue = Int(newValue) {
                            set.reps = intValue
                        }
                    }
                ))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .frame(width: 80)
            }
            
            // Weight input
            VStack(alignment: .leading, spacing: 4) {
                Text("Weight (lbs)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                TextField("0", text: Binding(
                    get: {
                        if set.weight == floor(set.weight) {
                            String(Int(set.weight))
                        } else {
                            String(format: "%.1f", set.weight)
                        }
                    },
                    set: { newValue in
                        if let doubleValue = Double(newValue) {
                            set.weight = doubleValue
                        }
                    }
                ))
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
        cycle.trainingDays[dayIndex].day[exerciseIndex]
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

            ForEach(exercise.sets.indices, id: \.self) { i in
                let set = exercise.sets[i]
                HStack {
                    Text("Set \(i + 1)")
                    Spacer()
                    Text("\(Int(set.reps)) reps")
                    Text("@ \(set.weight, specifier: "%.1f") lbs")
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
