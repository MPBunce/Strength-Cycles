import SwiftUI
import SwiftData

struct CyclesDetailView: View {
    @Environment(\.modelContext) var context
    @State private var isShowingItemSheet = false
    @Query(sort: \Cycles.dateStarted, order: .reverse)
    
    private var cycles: [Cycles]
    let cycleId: UUID

    private var selectedCycle: Cycles? {
        let match = cycles.first { $0.id == cycleId }
        print("Selected cycle for ID \(cycleId): \(String(describing: match?.template))")
        return match
    }


    init(cycleId: UUID) {
        print("Initializing CyclesDetailView with cycleId: \(cycleId)")
        self.cycleId = cycleId
        let predicate = #Predicate<Cycles> { cycle in
            cycle.id == cycleId
        }
        self._cycles = Query(filter: predicate)
    }


    @State private var selectedDayIndex: Int = 0

    var body: some View {
        let cycle = selectedCycle

        return Group {
            if let cycle = cycle {
                VStack(spacing: 0) {
                    if cycle.trainingDays.isEmpty {
                        ContentUnavailableView(
                            label: {
                                Label("No Training Days", systemImage: "calendar.badge.exclamationmark")
                            },
                            description: {
                                Text("This cycle has no training days.")
                            }
                        )
                    } else {
                        // Grey header with scrollable days
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                ForEach(Array(cycle.trainingDays.enumerated()), id: \.offset) { dayIndex, _ in
                                    Text("Day \(dayIndex + 1)")
                                        .font(.headline)
                                        .fontWeight(selectedDayIndex == dayIndex ? .bold : .medium)
                                        .foregroundColor(selectedDayIndex == dayIndex ? .primary : .secondary)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(selectedDayIndex == dayIndex ? Color(.systemGray4) : Color.clear)
                                        )                                        .onTapGesture {
                                            selectedDayIndex = dayIndex
                                        }
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        .background(Color(.systemGray6))
                        .frame(height: 60)
                        
                        // Main content list - only show selected day
                        List {
                            if selectedDayIndex < cycle.trainingDays.count {
                                let selectedDay = cycle.trainingDays[selectedDayIndex]
                                Section(header: Text("Day \(selectedDayIndex + 1)").font(.headline)) {
                                    ForEach(selectedDay.day.indices, id: \.self) { exerciseIndex in
                                        ExerciseRowView(
                                            cycle: cycle,
                                            dayIndex: selectedDayIndex,
                                            exerciseIndex: exerciseIndex
                                        )
                                    }
                                }
                            }
                        }
                    }
                }
            } else {
                ContentUnavailableView(
                    label: {
                        Label("Cycle Not Found", systemImage: "exclamationmark.triangle")
                    },
                    description: {
                        Text("The requested cycle could not be found.")
                    }
                )
            }
        }
        .navigationTitle(cycle?.template ?? "Cycle Detail")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isShowingItemSheet) {
            Text("Item Sheet Content")
        }
    }
    
    
}
