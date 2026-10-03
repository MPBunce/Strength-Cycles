//
//  ForgePlusView.swift
//  Forge
//
//  What Forge Plus includes. Purchases come later; development builds can preview it.
//

import SwiftUI

struct ForgePlusView: View {
    @Bindable private var plus = ForgePlus.shared

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 10) {
                    Image(systemName: "dumbbell.fill")
                        .font(.system(size: 30, weight: .light))
                    Text("Forge Plus")
                        .font(.largeTitle.weight(.light))
                    Text("Build your own programs: strength templates and running plans made the way you train.")
                        .foregroundStyle(.secondary)
                    Text(plus.isActive ? "Unlocked" : "Coming soon")
                        .font(.caption.weight(.semibold))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Capsule().fill(.quaternary))
                        .padding(.top, 4)
                }
                .padding(.vertical, 8)
            }

            Section("Included") {
                Label("Create your own strength templates", systemImage: "figure.strengthtraining.traditional")
                Label("Create your own running plans", systemImage: "figure.run")
                Label("Everything to come", systemImage: "plus.circle")
            }

            Section("Free forever") {
                Label("Every built-in strength program and running plan", systemImage: "checkmark")
                Label("Guided runs, races and running goals", systemImage: "checkmark")
                Label("Daily work, stretching, steps and challenges", systemImage: "checkmark")
                Label("Activity grids, badges, charts and goals", systemImage: "checkmark")
            }

            #if DEBUG
            Section {
                Toggle("Preview Plus features", isOn: $plus.isActive)
            } header: {
                Text("Developer")
            } footer: {
                Text("Only in development builds. Unlocks Plus so you can test it before purchases exist.")
            }
            #endif
        }
        .navigationTitle("Forge Plus")
        .navigationBarTitleDisplayMode(.inline)
    }
}

/// A small "Plus" tag for locked features.
struct PlusBadge: View {
    var body: some View {
        Text("Plus")
            .font(.caption2.weight(.semibold))
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(Capsule().fill(.quaternary))
            .accessibilityLabel("Forge Plus")
    }
}
