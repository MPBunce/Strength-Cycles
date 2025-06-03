import SwiftUI
import SwiftData



struct CyclesDetailView: View {
    @Environment(\.modelContext) var context
    let cycle: Cycles // The specific cycle passed from the previous view
    @State private var isShowingItemSheet = false
    
    var body: some View {
        VStack {
            // Display cycle details here
            Text("Cycle Details")
                .font(.largeTitle)
                .padding()
            
            // Example of displaying cycle information
            VStack(alignment: .leading, spacing: 10) {
                Text("Date Started: \(cycle.dateStarted, style: .date)")
                // Add other cycle properties here
            }
            .padding()
            
            Spacer()
            
            // Example button that might show the sheet
            Button("Show Item Sheet") {
                isShowingItemSheet = true
            }
            .padding()
        }
        .navigationTitle("Cycle Detail")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isShowingItemSheet) {
            // Your sheet content here
            Text("Item Sheet Content")
        }
    }
}
