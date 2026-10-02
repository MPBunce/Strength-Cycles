//
//  Stretching.swift
//  Forge
//
//  Built-in stretching routines the user can add to their Today tab.
//

import Foundation
import SwiftData

struct Stretch: Hashable {
    let name: String
    /// e.g. "30 sec each side"
    let hold: String
}

struct StretchRoutine: Identifiable, Hashable {
    let id: String
    let name: String
    let summary: String
    let minutes: Int
    let stretches: [Stretch]

    static let all: [StretchRoutine] = [
        StretchRoutine(
            id: "morning-mobility",
            name: "Morning Mobility",
            summary: "A quick full-body wake-up",
            minutes: 5,
            stretches: [
                Stretch(name: "Cat-Cow", hold: "10 slow reps"),
                Stretch(name: "World's Greatest Stretch", hold: "5 reps each side"),
                Stretch(name: "Standing Forward Fold", hold: "30 sec"),
                Stretch(name: "Arm Circles", hold: "10 each direction"),
                Stretch(name: "Neck Rolls", hold: "5 each direction")
            ]
        ),
        StretchRoutine(
            id: "lower-body",
            name: "Lower Body Stretch",
            summary: "Hips, hamstrings and calves after squats or deadlifts",
            minutes: 10,
            stretches: [
                Stretch(name: "Hip Flexor Lunge Stretch", hold: "45 sec each side"),
                Stretch(name: "Pigeon Pose", hold: "45 sec each side"),
                Stretch(name: "Seated Hamstring Stretch", hold: "45 sec each side"),
                Stretch(name: "Deep Squat Hold", hold: "60 sec"),
                Stretch(name: "Wall Calf Stretch", hold: "30 sec each side")
            ]
        ),
        StretchRoutine(
            id: "upper-body",
            name: "Upper Body Stretch",
            summary: "Chest, shoulders and back after pressing days",
            minutes: 8,
            stretches: [
                Stretch(name: "Doorway Chest Stretch", hold: "45 sec"),
                Stretch(name: "Cross-Body Shoulder Stretch", hold: "30 sec each side"),
                Stretch(name: "Overhead Triceps Stretch", hold: "30 sec each side"),
                Stretch(name: "Child's Pose", hold: "60 sec"),
                Stretch(name: "Thread the Needle", hold: "30 sec each side")
            ]
        )
    ]

    static func routine(id: String) -> StretchRoutine? {
        all.first { $0.id == id }
    }
}

/// Marks a routine as done on one calendar day.
@Model
class StretchEntry {
    var routineID: String = ""
    var day: Date = Date()

    init(routineID: String, day: Date) {
        self.routineID = routineID
        self.day = Calendar.current.startOfDay(for: day)
    }
}
