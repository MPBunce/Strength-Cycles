import SwiftUI
import SwiftData

struct CyclesDetailView: View {
    @Environment(\.modelContext) var context
    let cycle: Cycles // The specific cycle passed from the previous view
    @State private var isShowingItemSheet = false
    @State private var selectedDayIndex: Int = 0
    
    var body: some View {
        VStack(spacing: 0) {
            // Horizontal scroll for days
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(Array(cycle.trainingDays.enumerated()), id: \.offset) { index, _ in
                        Button("Day \(index + 1)") {
                            selectedDayIndex = index
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(selectedDayIndex == index ? Color.blue : Color.gray.opacity(0.2))
                        .foregroundColor(selectedDayIndex == index ? .white : .primary)
                        .cornerRadius(8)
                    }
                }
                .padding()
            }
            .background(Color(.systemGray6))
            
            // Main content for selected day
            if selectedDayIndex < cycle.trainingDays.count {
                let selectedDay = cycle.trainingDays[selectedDayIndex]
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Day \(selectedDayIndex + 1)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        // Show exercises for this day
                        ForEach(selectedDay.day, id: \.name) { exercise in
                            VStack(alignment: .leading, spacing: 8) {
                                Text(exercise.name)
                                    .font(.headline)
                                
                                ForEach(Array(exercise.sets.enumerated()), id: \.offset) { setIndex, set in
                                    HStack {
                                        Text("Set \(setIndex + 1):")
                                        Text("\(set.reps) reps")
                                        if set.weight > 0 {
                                            Text("@ \(Int(set.weight)) lbs")
                                        }
                                        Spacer()
                                    }
                                    .font(.subheadline)
                                }
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .padding(.horizontal)
                        }
                        
                        // Show completion status
                        if let completedDate = selectedDay.completedDate {
                            Text("Completed: \(completedDate, style: .date)")
                                .font(.subheadline)
                                .foregroundColor(.green)
                                .padding(.horizontal)
                        } else {
                            Button("Mark Complete") {
                                selectedDay.completedDate = Date()
                                try? context.save()
                            }
                            .buttonStyle(.borderedProminent)
                            .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                }
            }
            
            Spacer()
        }
        .navigationTitle("Cycle Detail")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isShowingItemSheet) {
            Text("Item Sheet Content")
        }
    }
}
