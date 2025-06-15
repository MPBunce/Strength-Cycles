//
//  ExerciseDetailView.swift
//  Strength Cycles
//
//  Created by Matthew Bunce on 2025-06-10.
//

import SwiftUI
import SwiftData

// MARK: - Main Exercise Detail View
struct ExerciseDetailView: View {
    let cycle: Cycles
    let dayIndex: Int
    let exerciseIndex: Int
    
    @Environment(\.dismiss) private var dismiss
    @State private var editingSets: [ExerciseSet]
    @State private var showingAddSetSheet = false
    @State private var showingEditSetSheet = false
    @State private var editingSetIndex: Int? = nil
    
    private var exercise: Exercise {
        cycle.trainingDays
            .first(where: { $0.dayIndex == dayIndex })?
            .day.first(where: { $0.exerciseIndex == exerciseIndex }) ?? Exercise(exerciseIndex: 0, name: "", sets: [])
    }

    init(cycle: Cycles, dayIndex: Int, exerciseIndex: Int) {
        self.cycle = cycle
        self.dayIndex = dayIndex
        self.exerciseIndex = exerciseIndex

        let exercise = cycle.trainingDays
            .first(where: { $0.dayIndex == dayIndex })?
            .day.first(where: { $0.exerciseIndex == exerciseIndex }) ?? Exercise(exerciseIndex: 0, name: "", sets: [])

        self._editingSets = State(initialValue: exercise.sets.sorted(by: { $0.setIndex < $1.setIndex }))
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                //ExerciseStatsHeader(editingSets: editingSets)
                ExerciseSetsSection(
                    editingSets: $editingSets,
                    showingAddSetSheet: $showingAddSetSheet,
                    canAlterSets: exercise.canAlterSets,
                    onDeleteSet: { index in deleteSet(at: index) },
                    onEditSet: { index in editSet(at: index) }
                )
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(exercise.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ExerciseDetailToolbar(
                onSave: { saveChanges(); dismiss() },
                isSaveDisabled: false
            )
        }
        .sheet(isPresented: $showingAddSetSheet) {
            AddSetView { weight, reps in
                addSet(weight: weight, reps: reps)
            }
        }
        .sheet(isPresented: $showingEditSetSheet) {
            if let editingIndex = editingSetIndex, editingIndex >= 0 && editingIndex < editingSets.count {
                let currentSet = editingSets[editingIndex]
                EditSetSheetView(
                    set: currentSet,
                    setIndex: editingIndex,
                    onUpdateAmrap: updateAmrapSet,
                    onUpdateRegular: updateRegularSet,
                    onCancel: {
                        editingSetIndex = nil
                        showingEditSetSheet = false
                    }
                )
            } else {
                ErrorSheetView {
                    editingSetIndex = nil
                    showingEditSetSheet = false
                }
            }
        }

    }

    private func addSet(weight: Double?, reps: Int?) {
        guard exercise.canAlterSets else { return }
        
        let nextIndex = (editingSets.map { $0.setIndex }.max() ?? -1) + 1
        let newSet = ExerciseSet(
            setIndex: nextIndex,
            weight: weight,
            reps: reps,
            isEditable: true,
            completionStatus: .notStarted
        )
        withAnimation(.spring()) {
            editingSets.append(newSet)
        }
    }
    
    private func editSet(at index: Int) {
        // Validate index bounds
        guard index >= 0 && index < editingSets.count else {
            print("❌ Invalid index: \(index), count: \(editingSets.count)")
            return
        }
        
        let set = editingSets[index]
        // Allow editing if the set is editable OR if it's an AMRAP (for reps editing)
        guard set.isEditable || set.isAmrap else {
            print("❌ Set not editable: isEditable=\(set.isEditable), isAmrap=\(set.isAmrap)")
            return
        }
        
        print("✅ Setting editingSetIndex to \(index)")
        print("✅ Set data: weight=\(set.weight?.description ?? "nil"), reps=\(set.reps?.description ?? "nil"), isAmrap=\(set.isAmrap)")
        
        // Set the index first, then show the sheet after a brief delay to ensure state is updated
        editingSetIndex = index
        
        // Use a small delay to ensure the state update has been processed
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            print("✅ Showing edit sheet for index \(index)")
            showingEditSetSheet = true
        }
    }
    
    private func deleteSet(at index: Int) {
        guard exercise.canAlterSets else { return }
        
        withAnimation(.spring()) {
            editingSets.remove(at: index)
            
            // Reindex remaining sets
            for (i, set) in editingSets.enumerated() {
                set.setIndex = i
            }
        }
    }

    private func saveChanges() {
        guard let day = cycle.trainingDays.first(where: { $0.dayIndex == dayIndex }) else { return }
        guard let exercise = day.day.first(where: { $0.exerciseIndex == exerciseIndex }) else { return }
        exercise.sets = editingSets
    }
    
    private func updateAmrapSet(at index: Int, reps: Int?) {
        guard index >= 0 && index < editingSets.count else { return }
        
        withAnimation(.spring()) {
            editingSets[index].reps = reps
        }
        editingSetIndex = nil
        showingEditSetSheet = false
    }

    private func updateRegularSet(at index: Int, weight: Double?, reps: Int?) {
        guard index >= 0 && index < editingSets.count else { return }
        
        withAnimation(.spring()) {
            editingSets[index].weight = weight
            editingSets[index].reps = reps
        }
        editingSetIndex = nil
        showingEditSetSheet = false
    }
}

// MARK: - Error Sheet View
struct ErrorSheetView: View {
    let onDismiss: () -> Void
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "exclamationmark.triangle")
                    .font(.largeTitle)
                    .foregroundColor(.orange)
                
                Text("Unable to Edit Set")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("There was an issue loading the set data. Please try again.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                Button("Close") {
                    onDismiss()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
}

// MARK: - Toolbar Component
struct ExerciseDetailToolbar: ToolbarContent {
    let onSave: () -> Void
    let isSaveDisabled: Bool
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button("Save") {
                onSave()
            }
            .fontWeight(.semibold)
            .disabled(isSaveDisabled)
        }
    }
}
