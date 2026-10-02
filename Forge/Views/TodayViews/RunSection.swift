//
//  RunSection.swift
//  Forge
//
//  Today's card for the active running plan: the next run, ready to start or tick off.
//

import SwiftUI
import SwiftData

struct RunSection: View {
    @Query(sort: \RunPlan.startDate, order: .reverse) private var plans: [RunPlan]
    /// The run whose sheet is open. Driving the sheet from this value (not a separate Bool)
    /// means the sheet always has its run when it appears.
    @State private var openSession: OpenRun?

    private struct OpenRun: Identifiable {
        let plan: RunPlan
        let id: UUID
    }

    private let day: Date

    init(day: Date) {
        self.day = day
    }

    /// The most recently started plan that still has runs left.
    private var activePlan: RunPlan? {
        plans.first { !$0.isCompleted }
    }

    /// A run already ticked off today, if any.
    private var doneToday: RunSession? {
        guard let plan = activePlan else { return nil }
        return plan.sessions.first { session in
            session.completedDate.map { Calendar.current.isDate($0, inSameDayAs: day) } ?? false
        }
    }

    var body: some View {
        if let plan = activePlan {
            Section {
                if let done = doneToday {
                    RunSessionRow(session: done,
                                  onToggle: { withAnimation { plan.setCompleted(done.id, on: nil) } },
                                  onOpen: { open(plan, done.id) })
                } else if let next = plan.nextSession {
                    RunSessionRow(session: next,
                                  isNext: true,
                                  onToggle: { withAnimation { plan.setCompleted(next.id, on: Date()) } },
                                  onOpen: { open(plan, next.id) })
                }
            } header: {
                HStack {
                    Text("Run")
                    Spacer()
                    Text(plan.name)
                        .font(.subheadline)
                        .textCase(nil)
                }
                .sheet(item: $openSession) { open in
                    RunSessionSheet(plan: open.plan, sessionID: open.id)
                }
            } footer: {
                if let next = plan.nextSession, doneToday == nil {
                    Text("Week \(next.week) of \(plan.weekCount). Tap to see the run or start the guided timer.")
                }
            }
        }
    }

    private func open(_ plan: RunPlan, _ id: UUID) {
        openSession = OpenRun(plan: plan, id: id)
    }
}
