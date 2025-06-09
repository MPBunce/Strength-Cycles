import SwiftUI
import SwiftData

struct GoalsView: View {
    @Environment(\.modelContext) var context
    @Query var goals: [Goal]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("Strength Goals")
                        .font(.title2)
                        .bold()
                    Text("Track your progress towards these common strength milestones")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 8)
                
                // Goals List
                LazyVStack(spacing: 12) {
                    ForEach(goals) { goal in
                        goalRow(for: goal)
                    }
                }
            }
            .padding()
        }
        .onAppear {
            initializeDefaultGoalsIfNeeded()
        }
    }
    
    // MARK: - Goal Row View
    @ViewBuilder
    private func goalRow(for goal: Goal) -> some View {
        HStack(spacing: 12) {
            // Checkbox
            Button(action: {
                toggleGoalCompletion(goal)
            }) {
                Image(systemName: goal.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(goal.isCompleted ? .green : .gray)
            }
            .buttonStyle(PlainButtonStyle())
            
            // Goal text
            VStack(alignment: .leading, spacing: 4) {
                Text(goal.goal)
                    .font(.body)
                    .strikethrough(goal.isCompleted)
                    .foregroundColor(goal.isCompleted ? .secondary : .primary)
                
                if goal.isCompleted, let completionDate = goal.completionDate {
                    Text("Completed on \(completionDate, formatter: dateFormatter)")
                        .font(.caption)
                        .foregroundColor(.green)
                }
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .animation(.easeInOut(duration: 0.2), value: goal.isCompleted)
    }
    
    // MARK: - Goal Management Functions
    private func initializeDefaultGoalsIfNeeded() {
        // Only initialize if no goals exist
        if goals.isEmpty {
            for defaultGoal in Goal.defaultGoals {
                context.insert(defaultGoal)
            }
            
            do {
                try context.save()
            } catch {
                print("Failed to save default goals: \(error)")
            }
        }
    }
    
    private func toggleGoalCompletion(_ goal: Goal) {
        withAnimation(.easeInOut(duration: 0.2)) {
            goal.isCompleted.toggle()
            
            if goal.isCompleted {
                goal.completionDate = Date()
            } else {
                goal.completionDate = nil
            }
            
            do {
                try context.save()
            } catch {
                print("Failed to save goal update: \(error)")
            }
        }
    }
    
    // MARK: - Date Formatter
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
}


#Preview {
    GoalsView()
        .modelContainer(for: Goal.self, inMemory: true)
}
