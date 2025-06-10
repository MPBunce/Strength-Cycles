import SwiftUI
import SwiftData

struct ProgressView: View {
    @Environment(\.modelContext) var context
    @Query(sort: \Cycles.startDate, order: .reverse) var cycles: [Cycles]
    @Query var goals: [Goal]
    @State private var selectedTab: ProgressTab = .activity
    
    private let daysInWeek = 7
    
    enum ProgressTab: String, CaseIterable {
        case goals = "Goals"
        case activity = "Activity"
        case charts = "Charts"
        
        var icon: String {
            switch self {
            case .goals: return "target"
            case .activity: return "calendar"
            case .charts: return "chart.line.uptrend.xyaxis"
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Custom Tab Bar
                tabNavigationBar
                
                // Content based on selected tab
                Group {
                    switch selectedTab {
                    case .goals:
                        GoalsView()
                    case .activity:
                        ActivityView()
                    case .charts:
                        ChartsView()
                    }
                }
            }
            .navigationTitle("Progress")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    // MARK: - Tab Navigation Bar
    private var tabNavigationBar: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(Array(ProgressTab.allCases.enumerated()), id: \.element) { index, tab in
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedTab = tab
                        }
                    }) {
                        VStack(spacing: 4) {
                            Image(systemName: tab.icon)
                                .font(.system(size: 16, weight: .medium))
                            Text(tab.rawValue)
                                .font(.caption)
                                .fontWeight(.medium)
                        }
                        .foregroundColor(selectedTab == tab ? .blue : .secondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .overlay(
                // Animated underline
                GeometryReader { geometry in
                    let tabWidth = geometry.size.width / CGFloat(ProgressTab.allCases.count)
                    let selectedIndex = ProgressTab.allCases.firstIndex(of: selectedTab) ?? 0
                    let underlineOffset = tabWidth * CGFloat(selectedIndex)
                    
                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: tabWidth, height: 2)
                        .offset(x: underlineOffset)
                        .animation(.easeInOut(duration: 0.2), value: selectedTab)
                }
                .frame(height: 2)
                , alignment: .bottom
            )
        }
        .frame(height: 60)
        .background(Color(.systemGray6))
    }
    
    // MARK: - Computed Properties
    
    private var completedWorkoutsCount: Int {
        cycles.flatMap { cycle in
            cycle.trainingDays.compactMap { $0.completedDate }
        }.count
    }
    
    
}

struct Progress_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView()
            .modelContainer(for: Cycles.self, inMemory: true)
    }
}
