//
//  CyclesView.swift
//  Strength Cycles
//
//  Created by Matthew Bunce on 2025-05-28.
//

import SwiftUI
import SwiftData

struct CyclesView: View {
    @Environment(\.modelContext) var context
    @Query var settings: [Settings]
    @Query(sort: \Cycles.startDate, order: .reverse) var cycles: [Cycles]
    @State private var selectedCycle: Cycles?
    @State private var isShowingItemSheet = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(cycles) { cycle in
                    NavigationLink(destination: CyclesDetailView(cycleId: cycle.id)) {
                        CycleCell(cycle: cycle)
                    }
                }
                .onDelete { indexSet in
                    for index in indexSet{
                        context.delete(cycles[index])
                    }
                }
            }
            .navigationTitle("Cycles")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $isShowingItemSheet){ CycleSelectionSheet() }
            .toolbar {
                if !cycles.isEmpty {
                    Button("Add Cycle", systemImage: "plus"){
                        isShowingItemSheet = true
                    }
                }
            }
            .overlay {
                if cycles.isEmpty{
                    ContentUnavailableView( label: {
                            Label("No Cycles", systemImage: "list.bullet.rectangle.portrait")
                        }, description: {
                            Text("Start an exercise routine by adding a cycle!")
                        }, actions: {
                            Button("Add A Cycle") { isShowingItemSheet = true}
                        }
                    )
                    .offset(y: -60)
                }
            }
        }
    }
}

struct CycleSelectionSheet: View {
    @Environment(\.modelContext) var context
    @Query var settings: [Settings]
    @Environment(\.dismiss) var dismiss
    
    private var userSettings: Settings {
        if let existingSettings = settings.first {
            return existingSettings
        } else {
            // Fallback to default settings
            let newSettings = Settings.defaultSettings
            context.insert(newSettings)
            try? context.save()
            return newSettings
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(Template.loadTemplates()) { template in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(template.name)
                            .font(.headline)
                        Text(template.description)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(template.duration)
                            .font(.caption2)
                            .foregroundColor(.blue)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        let userSettings = UserSettings(from: userSettings)
                        let cycle = template.createCycle(with: userSettings)
                        
                        context.insert(cycle)
                        print("Created cycle: \(cycle.id.uuidString)")
                        dismiss()
                    }
                }
            }
            .navigationTitle("Select a Cycle")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct CycleCell: View {
    let cycle: Cycles
    var body: some View {
        
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(cycle.template)
                    .font(.headline)
                Text(cycle.startDate, format: .dateTime.month(.abbreviated).day())
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("\(cycle.trainingDays.count) days")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            
            if cycle.isCompleted {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                    .font(.title2)
            }
        }
        .padding(.vertical, 8)

    }
}

struct Cycles_Preview: PreviewProvider {
    static var previews: some View {
        CyclesView()
    }
}
