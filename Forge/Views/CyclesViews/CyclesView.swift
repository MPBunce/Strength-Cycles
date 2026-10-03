//
//  CyclesView.swift
//  Forge
//
//  Created by Matthew Bunce on 2025-05-28.
//

import SwiftUI
import SwiftData

struct CyclesView: View {
    enum Kind: String, CaseIterable, Identifiable {
        case strength = "Strength"
        case running = "Running"
        var id: Self { self }
    }

    @State private var kind: Kind = DemoData.launchOption("ForgeTraining") == "running" ? .running : .strength
    @State private var showingAddStrength = false
    @State private var showingAddRun = false
    @Query private var cycles: [Cycles]
    @Query private var runPlans: [RunPlan]

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("Type", selection: $kind) {
                    ForEach(Kind.allCases) { Text($0.rawValue).tag($0) }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .padding(.vertical, 8)

                switch kind {
                case .strength:
                    StrengthCyclesList(showingAddCycle: $showingAddStrength)
                case .running:
                    RunPlansList(showingAddPlan: $showingAddRun)
                }
            }
            .navigationTitle("Training")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // The empty states have their own add button.
                if kind == .strength ? !cycles.isEmpty : !runPlans.isEmpty {
                    Button(kind == .strength ? "Add Cycle" : "Add Running Plan", systemImage: "plus") {
                        if kind == .strength { showingAddStrength = true } else { showingAddRun = true }
                    }
                }
            }
        }
    }
}

/// Strength training cycles.
struct StrengthCyclesList: View {
    @Environment(\.modelContext) var context
    @Query(sort: \Cycles.startDate, order: .reverse) var cycles: [Cycles]
    @Binding var showingAddCycle: Bool

    var body: some View {
        List {
            ForEach(cycles) { cycle in
                NavigationLink(destination: CyclesDetailView(cycleId: cycle.id)) {
                    CycleCell(cycle: cycle)
                }
            }
            .onDelete { indexSet in
                for index in indexSet {
                    context.delete(cycles[index])
                }
            }
        }
        .sheet(isPresented: $showingAddCycle) { CycleSelectionSheet() }
        .overlay {
            if cycles.isEmpty {
                ContentUnavailableView(label: {
                    Label("No Cycles", systemImage: "list.bullet.rectangle.portrait")
                }, description: {
                    Text("Start an exercise routine by adding a cycle!")
                }, actions: {
                    Button("Add A Cycle") { showingAddCycle = true }
                })
                .offset(y: -60)
            }
        }
    }
}

struct CycleSelectionSheet: View {
    @Environment(\.modelContext) var context
    @Query var settings: [Settings]
    @Query(sort: \CustomTemplate.createdAt) private var customTemplates: [CustomTemplate]
    @Environment(\.dismiss) var dismiss
    @State private var editingTemplate: CustomTemplate?
    @State private var creatingTemplate = false
    @State private var showingPlus = false
    private var plus = ForgePlus.shared
    
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
                Section {
                    ForEach(customTemplates) { template in
                        templateRow(
                            name: template.name,
                            description: template.details.isEmpty ? nil : template.details,
                            duration: "\(template.days.count) \(template.days.count == 1 ? "day" : "days")"
                        ) {
                            context.insert(template.createCycle(usesKilograms: userSettings.usesKilograms))
                            dismiss()
                        }
                        .swipeActions {
                            Button("Delete", role: .destructive) { context.delete(template) }
                            Button("Edit") {
                                if plus.isActive { editingTemplate = template } else { showingPlus = true }
                            }
                            .tint(.blue)
                        }
                    }
                    Button {
                        if plus.isActive { creatingTemplate = true } else { showingPlus = true }
                    } label: {
                        HStack {
                            Label("Create Template", systemImage: plus.isActive ? "plus" : "lock")
                            if !plus.isActive {
                                Spacer()
                                PlusBadge()
                            }
                        }
                    }
                } header: {
                    Text("My Templates")
                } footer: {
                    if !customTemplates.isEmpty {
                        Text("Swipe a template to edit or delete it.")
                    }
                }
                
                Section("Programs") {
                    ForEach(Template.loadTemplates()) { template in
                        templateRow(name: template.name, description: template.description, duration: template.duration) {
                            let userSettings = UserSettings(from: userSettings)
                            context.insert(template.createCycle(with: userSettings))
                            dismiss()
                        }
                    }
                }
            }
            .navigationTitle("Select a Cycle")
            .navigationDestination(isPresented: $showingPlus) {
                ForgePlusView()
            }
            .navigationDestination(isPresented: $creatingTemplate) {
                TemplateEditorView(template: nil)
            }
            .navigationDestination(item: $editingTemplate) { template in
                TemplateEditorView(template: template)
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func templateRow(name: String, description: String?, duration: String, onSelect: @escaping () -> Void) -> some View {
        Button(action: onSelect) {
            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(.headline)
                    .foregroundStyle(.primary)
                if let description {
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Text(duration)
                    .font(.caption2)
                    .foregroundColor(.blue)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
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
                Text(cycle.trainingDays.count == 1 ? "1 day" : "\(cycle.trainingDays.count) days")
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
