import SwiftUI
import SwiftData
import Charts

struct ChartsView: View {
    @Environment(\.modelContext) var context
    @Query(sort: \Cycles.startDate, order: .reverse) var cycles: [Cycles]

    private let targetLifts = [
        "Barbell Squat",
        "Barbell Bench Press",
        "Deadlift",
        "Barbell Overhead Press"
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                ForEach(targetLifts, id: \.self) { lift in
                    liftProgressionChart(for: lift)
                }
            }
            .padding()
        }
        .navigationTitle("Charts")
    }

    // MARK: - 1RM Progression Chart for each lift
    @ViewBuilder
    private func liftProgressionChart(for lift: String) -> some View {
        let progressionData = get1RMProgression(for: lift)
        
        VStack(alignment: .leading, spacing: 12) {
            Text(lift)
                .font(.title2)
                .bold()
            
            if progressionData.isEmpty {
                Text("No data available")
                    .foregroundColor(.secondary)
                    .padding(.vertical, 40)
                    .frame(maxWidth: .infinity)
            } else {
                Chart(progressionData) { dataPoint in
                    LineMark(
                        x: .value("Date", dataPoint.date),
                        y: .value("1RM", dataPoint.oneRM)
                    )
                    .foregroundStyle(.blue)
                    .lineStyle(StrokeStyle(lineWidth: 2))
                    
                    PointMark(
                        x: .value("Date", dataPoint.date),
                        y: .value("1RM", dataPoint.oneRM)
                    )
                    .foregroundStyle(.blue)
                    .symbolSize(30)
                }
                .frame(height: 200)
                .chartYAxis {
                    AxisMarks(position: .leading) { value in
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel {
                            if let weight = value.as(Double.self) {
                                Text("\(Int(weight)) lbs")
                            }
                        }
                    }
                }
                .chartXAxis {
                    AxisMarks { value in
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel(format: .dateTime.month(.abbreviated).day())
                    }
                }
                
                // Show current max
                if let currentMax = progressionData.last {
                    HStack {
                        Text("Current Projected 1RM:")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("\(currentMax.oneRM, specifier: "%.1f") lbs")
                            .font(.caption)
                            .bold()
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }

    // MARK: - Data Structure for 1RM Progression
    struct OneRMDataPoint: Identifiable {
        let id = UUID()
        let date: Date
        let oneRM: Double
    }

    // MARK: - 1RM Calculation and Data Extraction
    private func get1RMProgression(for lift: String) -> [OneRMDataPoint] {
        var dataPoints: [OneRMDataPoint] = []
        
        // Go through all cycles in chronological order (reverse the reversed query)
        for cycle in cycles.reversed() {
            // Go through training days in chronological order
            for day in cycle.trainingDays.sorted(by: { ($0.completedDate ?? Date.distantPast) < ($1.completedDate ?? Date.distantPast) }) {
                // Only include completed training days
                guard let completedDate = day.completedDate else { continue }
                
                var maxOneRMForDay: Double = 0
                
                // Find all exercises for this lift on this day
                for exercise in day.day {
                    if exercise.name == lift {
                        // Calculate 1RM for each set and find the maximum
                        for set in exercise.sets {
                            if let weight = set.weight, let reps = set.reps, weight > 0, reps > 0 {
                                let oneRM = calculate1RM(weight: weight, reps: reps)
                                maxOneRMForDay = max(maxOneRMForDay, oneRM)
                            }
                        }
                    }
                }
                
                // Only add data point if we found a valid 1RM for this day
                if maxOneRMForDay > 0 {
                    dataPoints.append(OneRMDataPoint(date: completedDate, oneRM: maxOneRMForDay))
                }
            }
        }
        
        return dataPoints
    }
    
    // MARK: - 1RM Calculation using Epley Formula
    private func calculate1RM(weight: Double, reps: Int) -> Double {
        // Epley formula: 1RM = weight × (1 + reps/30)
        // For 1 rep, this returns the weight itself
        return weight * (1.0 + Double(reps) / 30.0)
    }
}
