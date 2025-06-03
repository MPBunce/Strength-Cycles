//
//  ProgressView.swift
//  Strength Cycles
//
//  Created by Matthew Bunce on 2025-05-28.
//
import SwiftUI

struct ProgressView: View {
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
