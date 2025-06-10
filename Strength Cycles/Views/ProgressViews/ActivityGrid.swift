//
//  ProgressView.swift
//  Strength Cycles
//
//  Created by Matthew Bunce on 2025-05-28.
//
import SwiftUI
import SwiftData

struct ActivityView: View {
    @Environment(\.modelContext) var context
    @Query(sort: \Cycles.startDate, order: .reverse) var cycles: [Cycles]
    
    private let daysInWeek = 7
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Title and stats
                    VStack(spacing: 8) {
                        Text("\(completedWorkoutsCount) workouts completed")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top)
                    
                    // Activity Grid - Vertical Layout
                    VStack(spacing: 12) {
                        // Day labels header
                        HStack {
                            Text("Week:")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                                .frame(width: 40, alignment: .leading)
                            
                            HStack(spacing: 3) {
                                Text("S").font(.caption2).foregroundColor(.secondary).frame(width: 15)
                                Text("M").font(.caption2).foregroundColor(.secondary).frame(width: 15)
                                Text("T").font(.caption2).foregroundColor(.secondary).frame(width: 15)
                                Text("W").font(.caption2).foregroundColor(.secondary).frame(width: 15)
                                Text("T").font(.caption2).foregroundColor(.secondary).frame(width: 15)
                                Text("F").font(.caption2).foregroundColor(.secondary).frame(width: 15)
                                Text("S").font(.caption2).foregroundColor(.secondary).frame(width: 15)
                            }
                        }
                        
                        // Activity rows (weeks arranged vertically)
                        VStack(spacing: 3) {
                            ForEach(Array(weeklyData.enumerated()), id: \.offset) { weekIndex, week in
                                HStack {
                                    // Week/Month label
                                    Text(getMonthLabel(for: weekIndex))
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                        .frame(width: 40, alignment: .leading)
                                    
                                    // Week row (7 days horizontally)
                                    HStack(spacing: 3) {
                                        ForEach(Array(week.enumerated()), id: \.offset) { dayIndex, date in
                                            if let date = date {
                                                ActivitySquare(
                                                    date: date,
                                                    isCompleted: isWorkoutCompleted(on: date)
                                                )
                                                .frame(width: 15, height: 15)
                                            } else {
                                                Rectangle()
                                                    .fill(Color.clear)
                                                    .frame(width: 15, height: 15)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }

                    
                    // Recent activity summary
                    if completedWorkoutsCount > 0 {
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
        }
    }
    
    // MARK: - Computed Properties
    
private var weeklyData: [[Date?]] {
    let calendar = Calendar.current
    let today = Date()
    
    // Start from the beginning of current year
    let currentYear = calendar.component(.year, from: today)
    guard let yearStart = calendar.date(from: DateComponents(year: currentYear, month: 1, day: 1)) else {
        return []
    }
    
    // Find the start of the first week (Sunday) of the year
    var weekStart = yearStart
    while calendar.component(.weekday, from: weekStart) != 1 { // 1 = Sunday
        weekStart = calendar.date(byAdding: .day, value: -1, to: weekStart) ?? weekStart
    }
    
    var weeks: [[Date?]] = []
    var currentWeekStart = weekStart
    
    // Generate weeks from year start to today
    while currentWeekStart <= today {
        var week: [Date?] = []
        
        for dayOffset in 0..<7 {
            let date = calendar.date(byAdding: .day, value: dayOffset, to: currentWeekStart)
            
            // Only include dates from year start to today
            if let date = date, date >= yearStart && date <= today {
                week.append(date)
            } else if let date = date, date < yearStart {
                week.append(nil) // Empty space for days before year start
            } else {
                week.append(date) // Include future dates up to end of current week
            }
        }
        
        weeks.append(week)
        currentWeekStart = calendar.date(byAdding: .weekOfYear, value: 1, to: currentWeekStart) ?? currentWeekStart
    }
    
    // Reverse to show most recent weeks first
    return weeks.reversed()
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
    


private func getMonthLabel(for weekIndex: Int) -> String {
    guard weekIndex < weeklyData.count else { return "" }
    
    let week = weeklyData[weekIndex]
    guard let firstDateInWeek = week.compactMap({ $0 }).first else { return "" }
    
    let calendar = Calendar.current
    let month = calendar.component(.month, from: firstDateInWeek)
    let year = calendar.component(.year, from: firstDateInWeek)
    let currentYear = calendar.component(.year, from: Date())
    
    // Check if this week contains the first occurrence of this month
    // Since weeks are reversed, we need to check if this is the last week for this month in our array
    let isFirstWeekOfMonth: Bool = {
        guard let nextWeek = weeklyData[safe: weekIndex + 1] else { return true }
        guard let nextWeekDate = nextWeek.compactMap({ $0 }).first else { return true }
        
        let nextMonth = calendar.component(.month, from: nextWeekDate)
        let nextYear = calendar.component(.year, from: nextWeekDate)
        
        return month != nextMonth || year != nextYear
    }()
    
    if isFirstWeekOfMonth {
        let monthName = String(calendar.monthSymbols[month - 1].prefix(3))
        
        // Show year for January or if it's a different year than current
        if month == 1 && year != currentYear {
            return "\(monthName) '\(String(year).suffix(2))"
        }
        return monthName
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
            .frame(width: 15, height: 15)
            .cornerRadius(3)
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

// Add this extension at the end of your file
extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
