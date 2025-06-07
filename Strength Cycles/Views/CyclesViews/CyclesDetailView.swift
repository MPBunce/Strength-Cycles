import SwiftUI
import SwiftData

struct CyclesDetailView: View {
    @Environment(\.modelContext) var context
    @State private var isShowingItemSheet = false
    @Query(sort: \Cycles.dateStarted, order: .reverse)
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
                        trainingDaysHeader(for: cycle)
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

    // MARK: - Helper Views
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

    private func trainingDaysHeader(for cycle: Cycles) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(sortedTrainingDays(for: cycle), id: \.dayIndex) { day in
                    dayHeaderButton(for: day)
                }
            }
            .padding(.horizontal, 20)
        }
        .background(Color(.systemGray6))
        .frame(height: 60)
    }

    private func dayHeaderButton(for day: TrainingDay) -> some View {
        let isSelected = validSelectedDayIndex == day.dayIndex
        return Text("Day \(day.dayIndex + 1)")
            .font(.headline)
            .fontWeight(isSelected ? .bold : .medium)
            .foregroundColor(isSelected ? .primary : .secondary)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? Color(.systemGray4) : Color.clear)
            )
            .onTapGesture {
                selectedDayIndex = day.dayIndex
            }
    }

    private func exercisesList(for cycle: Cycles) -> some View {
        List {
            if let selectedDay = cycle.trainingDays.first(where: { $0.dayIndex == validSelectedDayIndex }) {
                Section(header: Text("Day \(selectedDay.dayIndex + 1)").font(.headline)) {
                    ForEach(sortedExercises(for: selectedDay), id: \.exerciseIndex) { exercise in
                        ExerciseRowView(
                            cycle: cycle,
                            dayIndex: selectedDay.dayIndex,
                            exerciseIndex: exercise.exerciseIndex
                        )
                    }
                }
            }
        }
    }

    // MARK: - Helper Methods
    private func sortedTrainingDays(for cycle: Cycles) -> [TrainingDay] {
        cycle.trainingDays.sorted(by: { $0.dayIndex < $1.dayIndex })
    }

    private func sortedExercises(for day: TrainingDay) -> [Exercise] {
        day.day.sorted(by: { $0.exerciseIndex < $1.exerciseIndex })
    }
}
