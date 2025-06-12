//
//  ChartOnly.swift
//  Strength Cycles
//
//  Created by Matthew Bunce on 2025-06-12.
//

import SwiftUI
import SwiftData
import Charts

struct ChartOnly: View {
    @Environment(\.modelContext) var context
    @Query(sort: \Cycles.startDate, order: .forward) var cycles: [Cycles] // Changed to forward order

    private let targetLifts = [
        "Squat",
        "Deadlift",
        "Bench Press",
        "Overhead Press"
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(targetLifts, id: \.self) { lift in
                        liftProgressionChart(for: lift)
                    }
                }
                .padding()
            }
            .navigationTitle("Progress")
            .navigationBarTitleDisplayMode(.inline)
        }
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
                    .symbolSize(25) // Slightly smaller since we might have more points
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
                .chartXScale(domain: .automatic) // Let SwiftUI handle the domain automatically
                .chartYScale(domain: .automatic)
                
                // Show current max from most recent workout
                if let mostRecentWorkout = progressionData.last {
                    HStack {
                        Text("Latest Projected 1RM:")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("\(mostRecentWorkout.oneRM, specifier: "%.1f") lbs")
                            .font(.caption)
                            .bold()
                    }
                }
                
                // Show overall personal best
                if let personalBest = progressionData.max(by: { $0.oneRM < $1.oneRM }),
                   personalBest.oneRM != progressionData.last?.oneRM {
                    HStack {
                        Text("Personal Best:")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("\(personalBest.oneRM, specifier: "%.1f") lbs")
                            .font(.caption)
                            .bold()
                            .foregroundColor(.green)
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
        
        // Process all cycles in chronological order
        for cycle in cycles {
            // Get all completed training days and sort them by completion date
            let completedTrainingDays = cycle.trainingDays
                .compactMap { trainingDay -> (trainingDay: TrainingDay, completedDate: Date)? in
                    guard let completedDate = trainingDay.completedDate else { return nil }
                    return (trainingDay: trainingDay, completedDate: completedDate)
                }
                .sorted { $0.completedDate < $1.completedDate }
            
            // Process each completed training day
            for (trainingDay, completedDate) in completedTrainingDays {
                var maxOneRMForWorkout: Double = 0
                
                // Find all exercises for this lift in this workout
                for exercise in trainingDay.day {
                    if exercise.name == lift {
                        // Calculate 1RM for each set and find the maximum for this exercise
                        for set in exercise.sets {
                            if let weight = set.weight, let reps = set.reps, weight > 0, reps > 0 {
                                let oneRM = calculate1RM(weight: weight, reps: reps)
                                maxOneRMForWorkout = max(maxOneRMForWorkout, oneRM)
                            }
                        }
                    }
                }
                
                // Only add data point if we found a valid 1RM for this workout
                if maxOneRMForWorkout > 0 {
                    dataPoints.append(OneRMDataPoint(date: completedDate, oneRM: maxOneRMForWorkout))
                }
            }
        }
        
        // Sort all data points by date (oldest first) to ensure chronological order
        dataPoints.sort { $0.date < $1.date }
        
        // Debug print to see what we're getting
        print("DEBUG: Data points for \(lift) (\(dataPoints.count) workouts):")
        for (index, point) in dataPoints.enumerated() {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .short
            print("  \(index + 1). Date: \(formatter.string(from: point.date)), 1RM: \(String(format: "%.1f", point.oneRM)) lbs")
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
