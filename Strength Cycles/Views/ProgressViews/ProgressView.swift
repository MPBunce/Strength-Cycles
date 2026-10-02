import SwiftUI
import SwiftData

/// The Progress tab: lift charts, a workout calendar and strength goals.
/// (Named to avoid clashing with SwiftUI's built-in `ProgressView` spinner.)
struct ProgressTabView: View {
    @State private var selectedSection: ProgressSection = .charts
    
    enum ProgressSection: String, CaseIterable, Identifiable {
        case charts = "Charts"
        case activity = "Activity"
        case goals = "Goals"
        
        var id: Self { self }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("Section", selection: $selectedSection) {
                    ForEach(ProgressSection.allCases) { section in
                        Text(section.rawValue).tag(section)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .padding(.vertical, 8)
                
                switch selectedSection {
                case .charts:
                    ChartOnly()
                case .activity:
                    ActivityView()
                case .goals:
                    GoalsView()
                }
            }
            .navigationTitle("Progress")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ProgressTabView()
        .modelContainer(for: [Cycles.self, Goal.self, Settings.self], inMemory: true)
}
