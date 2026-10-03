//
//  ForgePlusView.swift
//  Forge
//
//  What Forge Plus includes, with buying and restoring it.
//

import SwiftUI

struct ForgePlusView: View {
    @Bindable private var plus = ForgePlus.shared
    @Bindable private var store = PlusStore.shared

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
                    if plus.isActive {
                        Text("Unlocked")
                            .font(.caption.weight(.semibold))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Capsule().fill(.quaternary))
                            .padding(.top, 4)
                    }
                }
                .padding(.vertical, 8)
            }

            if !plus.isActive {
                Section {
                    Button {
                        Task { await store.purchase() }
                    } label: {
                        HStack {
                            Text(store.product.map { "Unlock Forge Plus for \($0.displayPrice)" } ?? "Unlock Forge Plus")
                                .fontWeight(.semibold)
                            Spacer()
                            if store.isPurchasing { ProgressView() }
                        }
                    }
                    .disabled(store.isPurchasing || store.isRestoring)

                    Button {
                        Task { await store.restore() }
                    } label: {
                        HStack {
                            Text("Restore Purchases")
                            Spacer()
                            if store.isRestoring { ProgressView() }
                        }
                    }
                    .disabled(store.isPurchasing || store.isRestoring)
                } footer: {
                    Text("A one-time purchase, not a subscription. It works on all your devices signed in with the same Apple Account.")
                }
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
                Text("Only in development builds. Unlocks Plus without buying it.")
            }
            #endif
        }
        .navigationTitle("Forge Plus")
        .navigationBarTitleDisplayMode(.inline)
        .task { await store.loadProduct() }
        .alert("Forge Plus", isPresented: Binding(
            get: { store.errorMessage != nil },
            set: { if !$0 { store.errorMessage = nil } }
        )) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(store.errorMessage ?? "")
        }
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
