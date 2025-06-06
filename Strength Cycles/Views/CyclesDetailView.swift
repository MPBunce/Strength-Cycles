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
                        List {
                            ForEach(Array(cycle.trainingDays.enumerated()), id: \.offset) { dayIndex, day in
                                Section(header: Text("Day \(dayIndex + 1)").font(.headline)) {
                                    ForEach(day.day, id: \.name) { exercise in
                                        VStack(alignment: .leading, spacing: 6) {
                                            Text(exercise.name)
                                                .font(.subheadline)
                                                .bold()

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
