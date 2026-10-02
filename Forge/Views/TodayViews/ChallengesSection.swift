//
//  ChallengesSection.swift
//  Forge
//

import SwiftUI
import SwiftData

struct ChallengesSection: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Challenge.createdAt) private var challenges: [Challenge]
    @State private var showingNewChallenge = false
    @State private var showCompleted = false

    private var active: [Challenge] { challenges.filter { !$0.isCompleted } }
    private var completed: [Challenge] {
        challenges.filter(\.isCompleted).sorted { ($0.completedAt ?? .distantPast) > ($1.completedAt ?? .distantPast) }
    }

    var body: some View {
        Section {
            if active.isEmpty {
                Text(completed.isEmpty
                     ? "Set yourself a challenge, like 100 burpees in 5 minutes, and tick it off when you've done it."
                     : "No active challenges. Add another?")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            ForEach(active) { challenge in
                ChallengeRow(challenge: challenge)
            }
            .onDelete { delete(active, at: $0) }

            if !completed.isEmpty {
                DisclosureGroup("Completed (\(completed.count))", isExpanded: $showCompleted) {
                    ForEach(completed) { challenge in
                        ChallengeRow(challenge: challenge)
                    }
                    .onDelete { delete(completed, at: $0) }
                }
            }
        } header: {
            HStack {
                Text("Challenges")
                Spacer()
                // A plain button: Menus in list headers don't open.
                Button {
                    showingNewChallenge = true
                } label: {
                    Label("Add", systemImage: "plus")
                        .font(.subheadline)
                }
                .textCase(nil)
            }
            .sheet(isPresented: $showingNewChallenge) {
                NewChallengeSheet()
            }
        }
    }

    private func delete(_ list: [Challenge], at offsets: IndexSet) {
        for index in offsets { context.delete(list[index]) }
    }
}

private struct ChallengeRow: View {
    let challenge: Challenge

    var body: some View {
        Button {
            withAnimation {
                challenge.completedAt = challenge.isCompleted ? nil : Date()
            }
        } label: {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: challenge.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundStyle(challenge.isCompleted ? .green : .secondary)
                VStack(alignment: .leading, spacing: 4) {
                    Text(challenge.title)
                        .foregroundStyle(challenge.isCompleted ? .secondary : .primary)
                        .strikethrough(challenge.isCompleted)
                    if !challenge.details.isEmpty {
                        Text(challenge.details)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    if let completedAt = challenge.completedAt {
                        Text("Completed \(completedAt.formatted(date: .abbreviated, time: .omitted))")
                            .font(.caption)
                            .foregroundStyle(.green)
                    }
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityHint(challenge.isCompleted ? "Marks as not done" : "Marks as completed")
    }
}

private struct NewChallengeSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @State private var title = ""
    @State private var details = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Your own") {
                    TextField("Challenge", text: $title)
                    TextField("Details (optional)", text: $details, axis: .vertical)
                        .lineLimit(3...6)
                }
                Section("Or pick one") {
                    ForEach(Challenge.presets, id: \.title) { preset in
                        Button {
                            context.insert(Challenge(title: preset.title, details: preset.details))
                            dismiss()
                        } label: {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(preset.title)
                                Text(preset.details)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .tint(.primary)
                    }
                }
            }
            .navigationTitle("New Challenge")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        context.insert(Challenge(
                            title: title.trimmingCharacters(in: .whitespaces),
                            details: details.trimmingCharacters(in: .whitespacesAndNewlines)
                        ))
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}
