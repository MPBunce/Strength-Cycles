import SwiftUI
import SwiftData

/// The Progress tab: lift charts, a workout calendar and strength goals.
/// (Named to avoid clashing with SwiftUI's built-in `ProgressView` spinner.)
struct ProgressTabView: View {
    /// A habit to open straight away, from a tapped widget.
    @Binding var openedMetric: ActivityMetric?
    @State private var selectedSection: ProgressSection = ProgressSection(rawValue: DemoData.launchOption("ForgeProgress") ?? "") ?? .activity
    
    enum ProgressSection: String, CaseIterable, Identifiable {
        case activity = "Activity"
        case charts = "Charts"
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
                case .activity:
                    ActivityView()
                case .charts:
                    ChartOnly()
                case .goals:
                    GoalsView()
                }
            }
            .navigationTitle("Progress")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(item: $openedMetric) { metric in
                ActivityHistoryView(metric: metric)
            }
            .onChange(of: openedMetric) { _, metric in
                if metric != nil { selectedSection = .activity }
            }
        }
    }
}

#Preview {
    ProgressTabView(openedMetric: .constant(nil))
        .modelContainer(for: [Cycles.self, Goal.self, Settings.self], inMemory: true)
}
