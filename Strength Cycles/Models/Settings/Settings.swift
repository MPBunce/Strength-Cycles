//
//  Settings.swift
//  Strength Cycles
//
//  Created by Matthew Bunce on 2025-05-31.
//
import Foundation
import SwiftData

@Model
class Settings {

    var units: String
    
    init(){
        self.units = "lbs"
    }
    
}
