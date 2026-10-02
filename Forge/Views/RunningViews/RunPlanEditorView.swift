//
//  RunPlanEditorView.swift
//  Forge
//
//  Build or edit a custom running plan (Forge Plus).
//

import SwiftUI
import SwiftData

struct RunPlanEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context

    /// nil when creating a new plan.
    let plan: CustomRunPlan?

    @State private var name = ""
    @State private var details = ""
    @State private var runsPerWeek = 3
    @State private var runs: [CustomRun] = [CustomRun()]
    @State private var loaded = false

    private var canSave: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty && !runs.isEmpty
    }

    var body: some View {
        Form {
            Section {
                TextField("Plan name", text: $name)
                TextField("Description (optional)", text: $details, axis: .vertical)
                    .lineLimit(1...3)
                Stepper(value: $runsPerWeek, in: 1...7) {
                    LabeledContent("Runs per week", value: "\(runsPerWeek)")
                }
            }

            Section {
                ForEach(Array($runs.enumerated()), id: \.element.id) { index, $run in
                    NavigationLink {
                        CustomRunEditor(run: $run)
                    } label: {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Week \(index / runsPerWeek + 1) · Run \(index % runsPerWeek + 1)")
                            Text(run.summary)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .onDelete { runs.remove(atOffsets: $0) }
                .onMove { runs.move(fromOffsets: $0, toOffset: $1) }

                Button {
                    // Start from a copy of the last run, since plans usually build gradually.
                    var next = runs.last ?? CustomRun()
                    next.id = UUID()
                    runs.append(next)
                } label: {
                    Label("Add Run", systemImage: "plus")
                }
            } header: {
                Text("Runs")
            } footer: {
                Text("\(runs.count) runs over \(runs.isEmpty ? 0 : (runs.count - 1) / runsPerWeek + 1) weeks. New runs copy the one before; tap a run to change it.")
            }
        }
        .navigationTitle(plan == nil ? "New Running Plan" : "Edit Running Plan")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save", action: save)
                    .fontWeight(.semibold)
                    .disabled(!canSave)
            }
        }
        .onAppear {
            guard !loaded else { return }
            loaded = true
            if let plan {
                name = plan.name
                details = plan.details
                runsPerWeek = plan.runsPerWeek
                runs = plan.runs
            }
        }
    }

    private func save() {
        let trimmedName = name.trimmingCharacters(in: .whitespaces)
        let trimmedDetails = details.trimmingCharacters(in: .whitespacesAndNewlines)
        if let plan {
            plan.name = trimmedName
            plan.details = trimmedDetails
            plan.runsPerWeek = runsPerWeek
            plan.runs = runs
        } else {
            context.insert(CustomRunPlan(name: trimmedName, details: trimmedDetails, runsPerWeek: runsPerWeek, runs: runs))
        }
        dismiss()
    }
}

private struct CustomRunEditor: View {
    @Binding var run: CustomRun

    var body: some View {
        Form {
            Section {
                Picker("Type", selection: $run.kind) {
                    ForEach(CustomRun.Kind.allCases) { Text($0.title).tag($0) }
                }
                .pickerStyle(.segmented)
            } footer: {
                Text(help)
            }

            Section {
                switch run.kind {
                case .intervals:
                    Stepper(value: $run.runSeconds, in: 15...1800, step: 15) {
                        LabeledContent("Run", value: RunSegment.formatDuration(run.runSeconds))
                    }
                    Stepper(value: $run.walkSeconds, in: 0...600, step: 15) {
                        LabeledContent("Walk", value: run.walkSeconds == 0 ? "None" : RunSegment.formatDuration(run.walkSeconds))
                    }
                    Stepper(value: $run.repeats, in: 1...20) {
                        LabeledContent("Repeats", value: "× \(run.repeats)")
                    }
                case .steady:
                    Stepper(value: $run.minutes, in: 5...240, step: 5) {
                        LabeledContent("Run for", value: "\(run.minutes) min")
                    }
                case .distance:
                    Stepper(value: $run.kilometres, in: 0.5...50, step: 0.5) {
                        LabeledContent("Distance", value: RunSegment.formatKm(run.kilometres))
                    }
                }
                if run.kind != .distance {
                    Toggle("Warm-up and cool-down walk", isOn: $run.warmUpAndCoolDown)
                }
            } footer: {
                Text(run.summary)
            }
        }
        .navigationTitle("Run")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var help: String {
        switch run.kind {
        case .intervals: return "Alternate running and walking. Followed with the guided timer."
        case .steady: return "Run continuously for a set time. Followed with the guided timer."
        case .distance: return "Run a set distance at your own pace; log your time afterwards."
        }
    }
}
