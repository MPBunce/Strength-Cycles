//
//  ProgressView.swift
//  Strength Cycles
//
//  Created by Matthew Bunce on 2025-05-28.
//
import SwiftUI
import SwiftData

struct ProgressView: View {
    
    @Environment(\.modelContext) var context
    @Query(sort: \Cycles.dateStarted, order: .reverse) var cycles: [Cycles]
    
    var body: some View {
        Text("Progress")
            .toolbar {
                Button("About") {
                    print("About tapped!")
                }
            }
    }
    
}

struct Progress_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView()
    }
}
