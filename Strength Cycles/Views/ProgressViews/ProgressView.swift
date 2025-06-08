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
    
    @State private var selectedYear: Int = Calendar.current.component(.year, from: Date())
    
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
                    
                    // Year selector
                    if activeYears.count > 1 {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(activeYears.sorted(by: >), id: \.self) { year in
                                    Button(action: {
                                        selectedYear = year
                                    }) {
                                        Text("\(year)")
                                            .font(.subheadline)
                                            .fontWeight(selectedYear == year ? .semibold : .regular)
                                            .foregroundColor(selectedYear == year ? .white : .primary)
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 8)
                                            .background(
                                                RoundedRectangle(cornerRadius: 20)
                                                    .fill(selectedYear == year ? Color.blue : Color(.systemGray5))
                                            )
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
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
                    
                    // Recent activity summary for selected year
                    if !cycles.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Activity in \(selectedYear)")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            ForEach(recentCompletedDaysForYear.prefix(5), id: \.date) { activity in
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
                            
                            if recentCompletedDaysForYear.isEmpty {
                                Text("No workouts completed in \(selectedYear)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .italic()
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
            .onAppear {
                // Set initial year to the most recent year with activity, or current year
                if let mostRecentYear = activeYears.max() {
                    selectedYear = mostRecentYear
                }
            }
        }
    }
    
    // MARK: - Computed Properties
    
    private var activeYears: Set<Int> {
        let calendar = Calendar.current
        let completedDates = cycles.flatMap { cycle in
            cycle.trainingDays.compactMap { $0.completedDate }
        }
        
        let years = Set(completedDates.map { calendar.component(.year, from: $0) })
        
        // Always include current year if there are any cycles at all
        let currentYear = calendar.component(.year, from: Date())
        if !cycles.isEmpty {
            return years.union([currentYear])
        }
        
        return years.isEmpty ? [currentYear] : years
    }
    
    private var weeklyData: [[Date?]] {
        let calendar = Calendar.current
        let today = Date()
        
        // Create date range for selected year
        let startOfYear = calendar.date(from: DateComponents(year: selectedYear, month: 1, day: 1)) ?? today
        let endOfYear = calendar.date(from: DateComponents(year: selectedYear, month: 12, day: 31)) ?? today
        
        // Use today if we're looking at current year, otherwise use end of selected year
        let endDate = selectedYear == calendar.component(.year, from: today) ? today : endOfYear
        
        // Find the start of the first week (Sunday)
        var weekStart = startOfYear
        while calendar.component(.weekday, from: weekStart) != 1 { // 1 = Sunday
            weekStart = calendar.date(byAdding: .day, value: -1, to: weekStart) ?? weekStart
        }
        
        var weeks: [[Date?]] = []
        var currentWeekStart = weekStart
        
        while currentWeekStart <= endDate {
            var week: [Date?] = []
            
            for dayOffset in 0..<7 {
                let date = calendar.date(byAdding: .day, value: dayOffset, to: currentWeekStart)
                
                // Only include dates within our selected year range
                if let date = date, date >= startOfYear && date <= endDate {
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
        let calendar = Calendar.current
        return cycles.flatMap { cycle in
            cycle.trainingDays.compactMap { trainingDay -> Int? in
                guard let completedDate = trainingDay.completedDate else { return nil }
                let year = calendar.component(.year, from: completedDate)
                return year == selectedYear ? 1 : nil
            }
        }.count
    }
    
    private var recentCompletedDaysForYear: [(date: Date, cycleName: String)] {
        let calendar = Calendar.current
        let completed = cycles.flatMap { cycle in
            cycle.trainingDays.compactMap { trainingDay -> (date: Date, cycleName: String)? in
                guard let completedDate = trainingDay.completedDate else { return nil }
                let year = calendar.component(.year, from: completedDate)
                if year == selectedYear {
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
