import SwiftUI
import SwiftData

struct CyclesDetailView: View {
    @Environment(\.modelContext) var context
    @Query(sort: \Cycles.startDate, order: .reverse)
    private var cycles: [Cycles]

    let cycleId: UUID
    @State private var selectedDayIndex: Int = 0

    private var selectedCycle: Cycles? {
        cycles.first { $0.id == cycleId }
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
        .environment(\.weightUnit, cycle?.weightUnit ?? "lbs")
        .navigationTitle(cycle?.template ?? "Cycle Detail")
        .navigationBarTitleDisplayMode(.inline)
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
        @Environment(\.weightUnit) private var unit
        
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
                
                // Preview of the first few sets, in set order
                if !exercise.sets.isEmpty {
                    let orderedSets = exercise.orderedSets
                    VStack(alignment: .leading, spacing: 4) {
                        ForEach(Array(orderedSets.prefix(3).enumerated()), id: \.offset) { index, set in
                            HStack(spacing: 8) {
                                Text("Set \(index + 1)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .frame(width: 40, alignment: .leading)
                                
                                Text(CyclesDetailView.setSummary(set, unit: unit))
                                    .font(.caption)
                                    .monospacedDigit()
                                    .foregroundColor(set.reps == nil && set.weight == nil ? .secondary : .primary)
                                
                                Spacer()
                                
                                if set.isCompleted {
                                    Image(systemName: set.wasSuccessful ? "checkmark.circle.fill" : "xmark.circle.fill")
                                        .foregroundColor(set.wasSuccessful ? .green : .red)
                                        .font(.caption)
                                }
                            }
                        }
                        
                        if orderedSets.count > 3 {
                            Text("+ \(orderedSets.count - 3) more")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.leading, 8)
                }
            }
            .padding(.vertical, 4)
        }
    }

    // MARK: - Helper Methods
    private static func setSummary(_ set: ExerciseSet, unit: String) -> String {
        let reps = set.reps.map { "\($0)\(set.isAmrap ? "+" : "") reps" }
        let weight = set.weight.map { "\(WeightConverter.format($0)) \(unit)" }
        switch (reps, weight) {
        case let (r?, w?): return "\(r) @ \(w)"
        case let (r?, nil): return r
        case let (nil, w?): return w
        default: return "Not set"
        }
    }

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
