//
//  DailyWorkSection.swift
//  Forge
//

import SwiftUI
import SwiftData

struct DailyWorkSection: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \DailyWorkItem.order) private var items: [DailyWorkItem]
    @Query private var entries: [DailyWorkEntry]
    @State private var showingEditor = false
    @State private var loggingItem: DailyWorkItem?

    private let day: Date

    init(day: Date) {
        self.day = day
        _entries = Query(filter: #Predicate<DailyWorkEntry> { $0.day == day })
    }

    var body: some View {
        Section {
            if items.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Add bodyweight work you do every day, like push-ups or chin-ups, and log reps as you go.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Button("Set Up Daily Work") { showingEditor = true }
                }
                .padding(.vertical, 4)
            } else {
                ForEach(items) { item in
                    DailyWorkRow(
                        item: item,
                        reps: reps(for: item),
                        onQuickAdd: { log(item, adding: item.quickAddAmount) },
                        onTap: { loggingItem = item }
                    )
                }
            }
        } header: {
            HStack {
                Text("Daily Work")
                Spacer()
                if !items.isEmpty {
                    Button("Edit") { showingEditor = true }
                        .font(.subheadline)
                        .textCase(nil)
                }
            }
            // Sheets live on the header: on the Section itself they were attached to the
            // rows, which get replaced when the first item is added, re-presenting the sheet.
            .sheet(isPresented: $showingEditor) {
                DailyWorkEditor()
            }
            .sheet(item: $loggingItem) { item in
                DailyWorkLogSheet(item: item, initialReps: reps(for: item)) { newTotal in
                    setReps(for: item, to: newTotal)
                }
            }
        }
    }

    private func entry(for item: DailyWorkItem) -> DailyWorkEntry? {
        entries.first { $0.itemID == item.id }
    }

    private func reps(for item: DailyWorkItem) -> Int {
        entry(for: item)?.reps ?? 0
    }

    private func log(_ item: DailyWorkItem, adding amount: Int) {
        setReps(for: item, to: reps(for: item) + amount)
    }

    private func setReps(for item: DailyWorkItem, to total: Int) {
        let total = max(0, total)
        withAnimation {
            if let existing = entry(for: item) {
                existing.reps = total
            } else if total > 0 {
                context.insert(DailyWorkEntry(itemID: item.id, day: day, reps: total))
            }
        }
    }
}

private struct DailyWorkRow: View {
    let item: DailyWorkItem
    let reps: Int
    let onQuickAdd: () -> Void
    let onTap: () -> Void

    private var isDone: Bool { reps >= item.dailyTarget }

    var body: some View {
        HStack(spacing: 12) {
            Button(action: onTap) {
                HStack(spacing: 12) {
                    Image(systemName: isDone ? "checkmark.circle.fill" : "circle")
                        .font(.title2)
                        .foregroundStyle(isDone ? .green : .secondary)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.name)
                            .foregroundStyle(.primary)
                        Text(item.prescription)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        SwiftUI.ProgressView(value: min(Double(reps) / Double(max(item.dailyTarget, 1)), 1))
                            .tint(isDone ? .green : .accentColor)
                    }
                    Text("\(reps)/\(item.dailyTarget)")
                        .font(.subheadline)
                        .monospacedDigit()
                        .foregroundStyle(.secondary)
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            Button("+\(item.quickAddAmount)", action: onQuickAdd)
                .buttonStyle(.bordered)
                .font(.subheadline.monospacedDigit())
                .accessibilityLabel("Log \(item.quickAddAmount) \(item.name)")
        }
        .padding(.vertical, 4)
    }
}

/// Set today's exact rep count for one item (for corrections or bigger chunks).
private struct DailyWorkLogSheet: View {
    @Environment(\.dismiss) private var dismiss
    let item: DailyWorkItem
    let onSave: (Int) -> Void
    @State private var reps: Int

    init(item: DailyWorkItem, initialReps: Int, onSave: @escaping (Int) -> Void) {
        self.item = item
        self.onSave = onSave
        _reps = State(initialValue: initialReps)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Stepper(value: $reps, in: 0...10_000) {
                        LabeledContent("Reps today") {
                            TextField("0", value: $reps, format: .number)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.trailing)
                                .frame(maxWidth: 80)
                        }
                    }
                } footer: {
                    Text("Target: \(item.prescription)")
                }
                Section {
                    HStack {
                        ForEach([1, 5, 10, item.quickAddAmount].uniqued(), id: \.self) { amount in
                            Button("+\(amount)") { reps += amount }
                                .buttonStyle(.bordered)
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
            }
            .navigationTitle(item.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { onSave(reps); dismiss() }.fontWeight(.semibold)
                }
            }
        }
        .presentationDetents([.medium])
    }
}

private extension Array where Element: Hashable {
    func uniqued() -> [Element] {
        var seen = Set<Element>()
        return filter { seen.insert($0).inserted }
    }
}
