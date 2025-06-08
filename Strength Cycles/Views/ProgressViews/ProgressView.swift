//
//  ProgressView.swift
//  Strength Cycles
//
//  Created by Matthew Bunce on 2025-05-28.
//
import SwiftUI
import SwiftData

struct ProgressView: View {
    @Environment(\.modelContext) var context
    @Query(sort: \Cycles.dateStarted, order: .reverse) var cycles: [Cycles]
    
    private let daysInWeek = 7
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Title and stats
                    VStack(spacing: 8) {
                        Text("Workout Activity")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("\(completedWorkoutsCount) workouts completed")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top)
                    
                    // Activity Grid - Vertical Layout
                    ScrollView(.horizontal, showsIndicators: false) {
                        VStack(spacing: 12) {
                            // Month labels at top
                            HStack(spacing: 2) {
                                // Day labels column
                                VStack(spacing: 2) {
                                    Text("").font(.caption2) // Spacer for month row
                                    Text("S").font(.caption2).foregroundColor(.secondary)
                                    Text("M").font(.caption2).foregroundColor(.secondary)
                                    Text("T").font(.caption2).foregroundColor(.secondary)
                                    Text("W").font(.caption2).foregroundColor(.secondary)
                                    Text("T").font(.caption2).foregroundColor(.secondary)
                                    Text("F").font(.caption2).foregroundColor(.secondary)
                                    Text("S").font(.caption2).foregroundColor(.secondary)
                                }
                                .frame(width: 15)
                                
                                // Activity columns
                                HStack(spacing: 2) {
                                    ForEach(Array(weeklyData.enumerated()), id: \.offset) { weekIndex, week in
                                        VStack(spacing: 2) {
                                            // Month label
                                            Text(getMonthLabel(for: weekIndex))
                                                .font(.caption2)
                                                .foregroundColor(.secondary)
                                                .frame(height: 12)
                                            
                                            // Week column
                                            ForEach(Array(week.enumerated()), id: \.offset) { dayIndex, date in
                                                if let date = date {
                                                    ActivitySquare(
                                                        date: date,
                                                        isCompleted: isWorkoutCompleted(on: date)
                                                    )
                                                } else {
                                                    Rectangle()
                                                        .fill(Color.clear)
                                                        .frame(width: 10, height: 10)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    // Legend
                    HStack {
                        Text("Less")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        
                        HStack(spacing: 2) {
                            Rectangle()
                                .fill(Color(.systemGray5))
                                .frame(width: 10, height: 10)
                                .cornerRadius(2)
                            
                            Rectangle()
                                .fill(Color.green.opacity(0.3))
                                .frame(width: 10, height: 10)
                                .cornerRadius(2)
                            
                            Rectangle()
                                .fill(Color.green.opacity(0.6))
                                .frame(width: 10, height: 10)
                                .cornerRadius(2)
                            
                            Rectangle()
                                .fill(Color.green)
                                .frame(width: 10, height: 10)
                                .cornerRadius(2)
                        }
                        
                        Text("More")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 10)
                    
                    // Recent activity summary
                    if !cycles.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Recent Activity")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            ForEach(recentCompletedDays.prefix(5), id: \.date) { activity in
                                HStack {
                                    Circle()
                                        .fill(Color.green)
                                        .frame(width: 8, height: 8)
                                    
                                    Text(activity.date, style: .date)
                                        .font(.subheadline)
                                    
                                    Spacer()
                                    
                                    Text(activity.cycleName)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                    
                    Spacer()
                }
            }
            .navigationTitle("Progress")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("About") {
                        print("About tapped!")
                    }
                }
            }
        }
    }
    
    // MARK: - Computed Properties
    
    private var weeklyData: [[Date?]] {
        let calendar = Calendar.current
        let today = Date()
        let startDate = calendar.date(byAdding: .day, value: -365, to: today) ?? today
        
        // Find the start of the first week (Sunday)
        var weekStart = startDate
        while calendar.component(.weekday, from: weekStart) != 1 { // 1 = Sunday
            weekStart = calendar.date(byAdding: .day, value: -1, to: weekStart) ?? weekStart
        }
        
        var weeks: [[Date?]] = []
        var currentWeekStart = weekStart
        
        while currentWeekStart <= today {
            var week: [Date?] = []
            
            for dayOffset in 0..<7 {
                let date = calendar.date(byAdding: .day, value: dayOffset, to: currentWeekStart)
                
                // Only include dates within our range
                if let date = date, date >= startDate && date <= today {
                    week.append(date)
                } else {
                    week.append(nil)
                }
            }
            
            weeks.append(week)
            currentWeekStart = calendar.date(byAdding: .weekOfYear, value: 1, to: currentWeekStart) ?? currentWeekStart
        }
        
        return weeks
    }
    
    private var completedWorkoutsCount: Int {
        cycles.flatMap { cycle in
            cycle.trainingDays.compactMap { $0.completedDate }
        }.count
    }
    
    private var recentCompletedDays: [(date: Date, cycleName: String)] {
        let completed = cycles.flatMap { cycle in
            cycle.trainingDays.compactMap { trainingDay in
                if let completedDate = trainingDay.completedDate {
                    return (date: completedDate, cycleName: cycle.template)
                }
                return nil
            }
        }
        
        return completed.sorted { $0.date > $1.date }
    }
    
    // MARK: - Helper Methods
    
    private func getMonthLabel(for weekIndex: Int) -> String {
        guard weekIndex < weeklyData.count else { return "" }
        
        let week = weeklyData[weekIndex]
        guard let firstDateInWeek = week.compactMap({ $0 }).first else { return "" }
        
        let calendar = Calendar.current
        let month = calendar.component(.month, from: firstDateInWeek)
        let day = calendar.component(.day, from: firstDateInWeek)
        
        // Show month label only for the first week of each month or first few days
        if day <= 7 {
            return String(calendar.monthSymbols[month - 1].prefix(3))
        }
        
        return ""
    }
    
    private func isWorkoutCompleted(on date: Date) -> Bool {
        let calendar = Calendar.current
        
        return cycles.contains { cycle in
            cycle.trainingDays.contains { trainingDay in
                guard let completedDate = trainingDay.completedDate else { return false }
                return calendar.isDate(completedDate, inSameDayAs: date)
            }
        }
    }
    
    private func getActivityIntensity(for date: Date) -> Double {
        let calendar = Calendar.current
        let workoutsOnDate = cycles.flatMap { cycle in
            cycle.trainingDays.compactMap { trainingDay in
                guard let completedDate = trainingDay.completedDate else { return nil }
                return calendar.isDate(completedDate, inSameDayAs: date) ? 1 : 0
            }
        }.reduce(0, +)
        
        // Return intensity based on number of workouts (0.0 to 1.0)
        return min(Double(workoutsOnDate) / 2.0, 1.0) // Cap at 2 workouts = full intensity
    }
}

struct ActivitySquare: View {
    let date: Date
    let isCompleted: Bool
    
    @State private var showTooltip = false
    
    var body: some View {
        Rectangle()
            .fill(isCompleted ? Color.green : Color(.systemGray5))
            .frame(width: 10, height: 10)
            .cornerRadius(2)
            .onTapGesture {
                showTooltip.toggle()
            }
            .overlay(
                // Tooltip
                Group {
                    if showTooltip {
                        VStack {
                            Text(date, style: .date)
                                .font(.caption2)
                            Text(isCompleted ? "Workout completed" : "No workout")
                                .font(.caption2)
                        }
                        .padding(6)
                        .background(Color(.systemBackground))
                        .cornerRadius(6)
                        .shadow(radius: 4)
                        .offset(y: -30)
                        .zIndex(1)
                    }
                }
            )
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.2)) {
                    showTooltip.toggle()
                }
                
                // Auto-hide after 2 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        showTooltip = false
                    }
                }
            }
    }
}

struct Progress_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView()
            .modelContainer(for: Cycles.self, inMemory: true)
    }
}
