import SwiftUI
import SwiftData

struct CyclesDetailView: View {
    @Environment(\.modelContext) var context
    @State private var isShowingItemSheet = false
    @Query var settings: [Settings]
    @Query(sort: \Cycles.startDate, order: .reverse)
    private var cycles: [Cycles]

    let cycleId: UUID
    @State private var selectedDayIndex: Int = 0

    private var selectedCycle: Cycles? {
        let match = cycles.first { $0.id == cycleId }
        print("Selected cycle for ID \(cycleId): \(String(describing: match?.template))")
        return match
    }

    private var validSelectedDayIndex: Int {
        guard let cycle = selectedCycle, !cycle.trainingDays.isEmpty else { return 0 }
        let sortedDays = cycle.trainingDays.sorted(by: { $0.dayIndex < $1.dayIndex })
        
        // If selectedDayIndex doesn't exist in the training days, use the first day's index
        if cycle.trainingDays.contains(where: { $0.dayIndex == selectedDayIndex }) {
            return selectedDayIndex
        } else {
            return sortedDays.first?.dayIndex ?? 0
        }
    }

    init(cycleId: UUID) {
        print("Initializing CyclesDetailView with cycleId: \(cycleId)")
        self.cycleId = cycleId
        let predicate = #Predicate<Cycles> { cycle in
            cycle.id == cycleId
        }
        self._cycles = Query(filter: predicate)
    }

    var body: some View {
        let cycle = selectedCycle

        return Group {
            if let cycle = cycle {
                VStack(spacing: 0) {
                    if cycle.trainingDays.isEmpty {
                        emptyStateView
                    } else {
                        daySelectionDropdown(for: cycle)
                        exercisesList(for: cycle)
                    }
                }
            } else {
                cycleNotFoundView
            }
        }
        .navigationTitle(cycle?.template ?? "Cycle Detail")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isShowingItemSheet) {
            Text("Item Sheet Content")
        }
    }

    private var emptyStateView: some View {
        ContentUnavailableView(
            label: {
                Label("No Training Days", systemImage: "calendar.badge.exclamationmark")
            },
            description: {
                Text("This cycle has no training days.")
            }
        )
    }

    private var cycleNotFoundView: some View {
        ContentUnavailableView(
            label: {
                Label("Cycle Not Found", systemImage: "exclamationmark.triangle")
            },
            description: {
                Text("The requested cycle could not be found.")
            }
        )
    }

    private func daySelectionDropdown(for cycle: Cycles) -> some View {
        HStack {
            Image(systemName: "calendar")
                .foregroundColor(.blue)
                .font(.title3)
            
            Text("Training Day:")
                .font(.headline)
                .foregroundColor(.primary)
            
            Spacer()
            
            Menu {
                ForEach(sortedTrainingDays(for: cycle), id: \.dayIndex) { day in
                    Button(action: {
                        selectedDayIndex = day.dayIndex
                    }) {
                        HStack {
                            Text("Day \(day.dayIndex + 1): \(day.dayName)")
                            
                            if validSelectedDayIndex == day.dayIndex {
                                Spacer()
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
            } label: {
                HStack(spacing: 8) {
                    if let selectedDay = cycle.trainingDays.first(where: { $0.dayIndex == validSelectedDayIndex }) {
                        VStack(alignment: .trailing, spacing: 2) {
                            Text("Day \(selectedDay.dayIndex + 1)")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                            Text(selectedDay.dayName)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    } else {
                        Text("Select Day")
                            .font(.subheadline)
                            .foregroundColor(.primary)
                    }
                    
                    Image(systemName: "chevron.down")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                .contentShape(Rectangle())
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(Color(.systemBackground))
        .overlay(
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(Color(.systemGray4)),
            alignment: .bottom
        )
    }

    private func exercisesList(for cycle: Cycles) -> some View {
        List {
            if let selectedDay = cycle.trainingDays.first(where: { $0.dayIndex == validSelectedDayIndex }) {
                Section(header:
                    HStack {
                        Text("\(selectedDay.dayName)")
                            .font(.subheadline)
                        
                        Spacer()
                        
                        Button(action: {
                            toggleDayCompletion(selectedDay)
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: selectedDay.completedDate != nil ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(selectedDay.completedDate != nil ? .green : .blue)
                                
                                Text(selectedDay.completedDate != nil ? "Complete" : "Mark Complete")
                                    .font(.caption)
                                    .foregroundColor(selectedDay.completedDate != nil ? .green : .blue)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                ) {
                    ForEach(sortedExercises(for: selectedDay), id: \.exerciseIndex) { exercise in
                        NavigationLink(destination: ExerciseDetailView(
                            cycle: cycle,
                            dayIndex: selectedDay.dayIndex,
                            exerciseIndex: exercise.exerciseIndex
                        )) {
                            ExerciseRowView(exercise: exercise)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Exercise Row View
    struct ExerciseRowView: View {
        let exercise: Exercise
        
        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                // Exercise header with name and completion status
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(exercise.name)
                            .font(.headline)
                            .foregroundColor(.primary)
                    }
                    
                    Spacer()
                    
                    // Completion indicator
                    if !exercise.sets.isEmpty {
                        let completedSets = exercise.sets.filter { $0.isCompleted }.count
                        let totalSets = exercise.sets.count
                        
                        HStack(spacing: 4) {
                            Text("\(completedSets)/\(totalSets)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Image(systemName: completedSets == totalSets ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(completedSets == totalSets ? .green : .secondary)
                                .font(.caption)
                        }
                    }
                }
                
                // Sets preview (show first few sets) - FIXED VERSION
                if !exercise.sets.isEmpty {
                    VStack(spacing: 4) {
                        // Get the first 3 sets safely
                        let setsToShow = Array(exercise.sets.prefix(3))
                        
                        ForEach(setsToShow.indices, id: \.self) { index in
                            let set = setsToShow[index]  // Now accessing the safe subarray
                            HStack {
                                Text("Set \(index + 1):")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                if let reps = set.reps, let weight = set.weight {
                                    Text("\(reps) reps @ \(weight, specifier: "%.1f") lbs")
                                        .font(.caption)
                                        .foregroundColor(.primary)
                                } else if let reps = set.reps {
                                    Text("\(reps) reps")
                                        .font(.caption)
                                        .foregroundColor(.primary)
                                } else if let weight = set.weight {
                                    Text("\(weight, specifier: "%.1f") lbs")
                                        .font(.caption)
                                        .foregroundColor(.primary)
                                } else {
                                    Text("Not set")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                if set.isCompleted {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                        .font(.caption)
                                }
                            }
                        }
                        
                        // Show "and X more" if there are more than 3 sets
                        if exercise.sets.count > 3 {
                            HStack {
                                Text("and \(exercise.sets.count - 3) more sets...")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .italic()
                                Spacer()
                            }
                        }
                    }
                    .padding(.leading, 8)
                }
            }
            .padding(.vertical, 4)
        }
    }

    // MARK: - Helper Methods
    private func toggleDayCompletion(_ trainingDay: TrainingDay) {
        if trainingDay.completedDate != nil {
            trainingDay.completedDate = nil
        } else {
            trainingDay.completedDate = Date()
        }
    }
    
    private func sortedTrainingDays(for cycle: Cycles) -> [TrainingDay] {
        cycle.trainingDays.sorted(by: { $0.dayIndex < $1.dayIndex })
    }

    private func sortedExercises(for day: TrainingDay) -> [Exercise] {
        day.day.sorted(by: { $0.exerciseIndex < $1.exerciseIndex })
    }
}
