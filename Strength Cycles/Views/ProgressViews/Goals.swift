//
//  Goals.swift
//  Strength Cycles
//
//  Created by Matthew Bunce on 2025-06-08.
//

import SwiftUI
import SwiftData

struct GoalsView: View {
    @Environment(\.modelContext) var context
    @Query(sort: \Cycles.dateStarted, order: .reverse) var cycles: [Cycles]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Goals content here
            }
            .padding()
        }
    }
}
