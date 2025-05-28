//
//  Item.swift
//  Strength Cycles
//
//  Created by Matthew Bunce on 2025-05-28.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
