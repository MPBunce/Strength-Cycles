//
//  RunPlansView.swift
//  Forge
//
//  The Running side of the Cycles tab: running plans, kept apart from strength cycles.
//

import SwiftUI
import SwiftData

/// List of running plans; lives inside the Cycles tab's navigation stack.
struct RunPlansList: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \RunPlan.startDate, order: .reverse) private var plans: [RunPlan]
    @Binding var showingAddPlan: Bool

    var body: some View {
        List {
            RacesSection()

            Section("Plans") {
                if plans.isEmpty {
                    Button {
                        showingAddPlan = true
                    } label: {
                        Label("Add a Running Plan", systemImage: "figure.run")
                    }
                }
                ForEach(plans) { plan in
                    NavigationLink {
                        RunPlanDetailView(plan: plan)
                    } label: {
                        RunPlanRow(plan: plan)
                    }
                }
                .onDelete { offsets in
                    for index in offsets { context.delete(plans[index]) }
                }
            }
        }
        .sheet(isPresented: $showingAddPlan) {
            RunPlanSelectionSheet()
        }
    }
}

private struct RunPlanRow: View {
    let plan: RunPlan

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(plan.name)
                    .font(.headline)
                Text(plan.startDate, format: .dateTime.month(.abbreviated).day())
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("\(plan.completedCount) of \(plan.sessions.count) runs")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            if plan.isCompleted {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
                    .font(.title2)
            }
        }
        .padding(.vertical, 8)
    }
}

private struct RunPlanSelectionSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context

    var body: some View {
        NavigationStack {
            List(RunPlanTemplate.all) { template in
                Button {
                    context.insert(template.createPlan())
                    dismiss()
                } label: {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(template.name)
                            .font(.headline)
                            .foregroundStyle(.primary)
                        Text(template.summary)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text(template.duration)
                            .font(.caption2)
                            .foregroundStyle(.blue)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
            .navigationTitle("Select a Running Plan")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}

// MARK: - Plan detail

struct RunPlanDetailView: View {
    @Bindable var plan: RunPlan
    @State private var openSession: RunSession?

    private var weeks: [(week: Int, sessions: [RunSession])] {
        Dictionary(grouping: plan.orderedSessions, by: \.week)
            .sorted { $0.key < $1.key }
            .map { ($0.key, $0.value) }
    }

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Text("\(plan.completedCount) of \(plan.sessions.count) runs done")
                        .font(.subheadline.weight(.semibold))
                    SwiftUI.ProgressView(value: Double(plan.completedCount), total: Double(max(plan.sessions.count, 1)))
                        .tint(.orange)
                }
                .padding(.vertical, 4)
            }

            ForEach(weeks, id: \.week) { week in
                Section("Week \(week.week)") {
                    ForEach(week.sessions) { session in
                        RunSessionRow(session: session,
                                      isNext: session.id == plan.nextSession?.id,
                                      onToggle: { toggle(session) },
                                      onOpen: { openSession = session })
                    }
                }
            }
        }
        .navigationTitle(plan.name)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $openSession) { session in
            RunSessionSheet(plan: plan, sessionID: session.id)
        }
    }

    private func toggle(_ session: RunSession) {
        withAnimation {
            plan.setCompleted(session.id, on: session.isCompleted ? nil : Date())
        }
    }
}

struct RunSessionRow: View {
    let session: RunSession
    var isNext: Bool = false
    let onToggle: () -> Void
    let onOpen: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Button(action: onToggle) {
                Image(systemName: session.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundStyle(session.isCompleted ? .green : .secondary)
            }
            .buttonStyle(.plain)
            .accessibilityLabel(session.isCompleted ? "Mark not done" : "Mark done")

            Button(action: onOpen) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        HStack(spacing: 6) {
                            Text("Run \(session.number)")
                                .foregroundStyle(.primary)
                            if isNext {
                                Text("NEXT")
                                    .font(.caption2.weight(.bold))
                                    .foregroundStyle(.orange)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(Color.orange.opacity(0.15), in: Capsule())
                            }
                        }
                        Text(session.summary)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        if let date = session.completedDate {
                            Text("Done \(date.formatted(.dateTime.month(.abbreviated).day()))")
                                .font(.caption2)
                                .foregroundStyle(.green)
                        }
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 2)
    }
}

// MARK: - Session sheet

/// A session's segments, with the guided timer for timed runs and a manual tick-off.
struct RunSessionSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var plan: RunPlan
    let sessionID: UUID
    @State private var guiding = false
    @State private var loggingRace = false
    @State private var distanceText = ""
    @FocusState private var distanceFocused: Bool

    private var session: RunSession? { plan.sessions.first { $0.id == sessionID } }

    var body: some View {
        NavigationStack {
            if let session {
                List {
                    Section {
                        if session.isTimed {
                            Button {
                                guiding = true
                            } label: {
                                Label("Start Guided Run", systemImage: "play.circle.fill")
                            }
                        }
                        if let race = session.raceDistance {
                            Button {
                                loggingRace = true
                            } label: {
                                Label("Log \(race.name) Result", systemImage: "flag.checkered")
                            }
                            .sheet(isPresented: $loggingRace) {
                                LogRaceSheet(initialDistance: race)
                            }
                        }
                        if session.isCompleted {
                            LabeledContent {
                                HStack(spacing: 4) {
                                    TextField(session.isTimed ? "Enter" : RunSegment.formatKm(session.runningKilometres),
                                              text: $distanceText)
                                        .keyboardType(.decimalPad)
                                        .multilineTextAlignment(.trailing)
                                        .focused($distanceFocused)
                                        .frame(maxWidth: 90)
                                    Text("km").foregroundStyle(.secondary)
                                }
                            } label: {
                                Label("Distance", systemImage: "ruler")
                            }
                        }
                        Button {
                            plan.setCompleted(session.id, on: session.isCompleted ? nil : Date())
                            if session.isTimed && !session.isCompleted {
                                // Stay open so the distance can be entered.
                                distanceFocused = true
                            } else {
                                dismiss()
                            }
                        } label: {
                            Label(session.isCompleted ? "Mark Not Done" : "Mark Done",
                                  systemImage: session.isCompleted ? "arrow.uturn.backward" : "checkmark.circle")
                        }
                    } footer: {
                        if session.isCompleted && session.isTimed && session.loggedKilometres == nil {
                            Text("Add how far you ran so it counts towards your distance badges.")
                        }
                    }

                    Section {
                        ForEach(Array(session.segments.enumerated()), id: \.offset) { index, segment in
                            SegmentRow(index: index, segment: segment)
                        }
                    } footer: {
                        if session.isTimed {
                            Text("About \(session.totalSeconds / 60) minutes including warm-up and cool-down.")
                        } else {
                            Text("Run at an easy, conversational pace unless it's race day.")
                        }
                    }
                }
                .navigationTitle(session.title)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done") { dismiss() }.fontWeight(.semibold)
                    }
                }
                .fullScreenCover(isPresented: $guiding) {
                    GuidedRunView(session: session) {
                        plan.setCompleted(session.id, on: Date())
                        // Back on this sheet, ready for the distance.
                        distanceFocused = true
                    }
                }
                .onAppear {
                    distanceText = session.loggedKilometres.map { RunSegment.formatKm($0).replacingOccurrences(of: " km", with: "") } ?? ""
                }
                .onChange(of: distanceText) { _, text in
                    let value = Double(text.replacingOccurrences(of: ",", with: "."))
                    plan.setDistance(session.id, kilometres: text.isEmpty ? nil : value)
                }
            }
        }
    }
}

private struct SegmentRow: View {
    let index: Int
    let segment: RunSegment

    var body: some View {
        HStack(spacing: 12) {
            Text("\(index + 1)")
                .font(.subheadline.monospacedDigit())
                .foregroundStyle(.secondary)
                .frame(width: 20)
            Image(systemName: segment.kind.isRunning ? "figure.run" : "figure.walk")
                .foregroundStyle(segment.kind.isRunning ? .orange : .green)
                .frame(width: 24)
            Text(segment.label)
        }
    }
}
