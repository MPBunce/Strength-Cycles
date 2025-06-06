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
    @Query(sort: \Cycles.dateStarted, order: .reverse) var cycles: [Cycles]
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
    @Environment(\.dismiss) var dismiss
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
                        let cycle = Cycles( dateStarted: Date(), template: template.name, trainingDays: template.trainingDays)
                        
                        print("🟢 New cycle created:")
                        print("- ID: \(cycle.id)")
                        print("- Template: \(cycle.template)")
                        print("- Training days: \(cycle.trainingDays.count)")
                        for (i, day) in cycle.trainingDays.enumerated() {
                            print("  Day \(i + 1): \(day.day.map(\.name))")
                        }
                        
                        context.insert(cycle)
                        print("Selected: \(cycle.id.uuidString)")
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
            }            
            Spacer()
            VStack(alignment: .trailing, spacing: 2) {
                Text("\(cycle.trainingDays.count) days")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }

    }
}

struct Cycles_Preview: PreviewProvider {
    static var previews: some View {
        CyclesView()
    }
}
