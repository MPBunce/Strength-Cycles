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
    /// e.g. "60 sec" or "10 each leg"
    let hold: String
    /// How to do it, shown on the routine's detail screen.
    var detail: String = ""
}

struct StretchRoutine: Identifiable, Hashable {
    let id: String
    let name: String
    let summary: String
    let minutes: Int
    let stretches: [Stretch]
    /// Where the routine comes from, shown under its stretch list.
    var source: String = ""

    static let all: [StretchRoutine] = [agile8, fiveStretches] + StartingStretching.levels

    /// Routines offered on their own, outside the Starting Stretching level group.
    static let standalone: [StretchRoutine] = [agile8, fiveStretches]

    static func routine(id: String) -> StretchRoutine? {
        all.first { $0.id == id }
    }

    /// Joe DeFranco's lower-body mobility warm-up.
    static let agile8 = StretchRoutine(
        id: "defranco-agile-8",
        name: "DeFranco's Agile 8",
        summary: "Lower-body warm-up for hips and legs",
        minutes: 10,
        stretches: [
            Stretch(name: "Foam Roll IT Band", hold: "10–15 passes each leg",
                    detail: "Lie on your side on the roller and roll from hip to just above the knee."),
            Stretch(name: "Foam Roll Adductors", hold: "10–15 passes each leg",
                    detail: "Lie face down with one leg out to the side over the roller and roll the inner thigh."),
            Stretch(name: "Glute Ball Release", hold: "30–60 sec each side",
                    detail: "Sit on a lacrosse or tennis ball and work it around the glute, pausing on tight spots."),
            Stretch(name: "Rectus Femoris Stretch", hold: "3 × 30 sec each leg",
                    detail: "Back knee on the floor against a wall or bench with the foot up behind you; squeeze the glute and stay tall."),
            Stretch(name: "Glute Bridge", hold: "12 reps, 3 sec hold",
                    detail: "On your back, knees bent, drive through the heels and squeeze the glutes at the top."),
            Stretch(name: "Fire Hydrant Circles", hold: "10 each direction, each leg",
                    detail: "On hands and knees, lift the knee out to the side and draw big circles from the hip."),
            Stretch(name: "Mountain Climbers", hold: "10 each leg",
                    detail: "From a push-up position, bring one foot up beside the hand and sink the hips."),
            Stretch(name: "Grok Squat", hold: "2 × 30 sec",
                    detail: "Hold the bottom of a deep squat, heels down, elbows pushing the knees out.")
        ],
        source: "Joe DeFranco's Agile 8."
    )

    /// From MovementbyDavid's "Literally 5 Stretches is all you Need" (youtube.com/watch?v=QaKuVOhikaY).
    static let fiveStretches = StretchRoutine(
        id: "movementbydavid-5",
        name: "5 Stretches",
        summary: "Daily: hips, hamstrings, chest and lats",
        minutes: 5,
        stretches: [
            Stretch(name: "Pancake Stretch", hold: "30 sec",
                    detail: "Sit with the legs wide and hinge forward from the hips with a flat back."),
            Stretch(name: "Figure Four Stretch", hold: "30 sec each side",
                    detail: "Cross one ankle over the opposite knee and draw the legs in to open the hip."),
            Stretch(name: "Hip Flexor Stretch", hold: "30 sec each side",
                    detail: "Half-kneeling lunge; squeeze the back glute and shift the hips forward."),
            Stretch(name: "Chest Opening Stretch", hold: "30 sec",
                    detail: "Open the arms back against a wall or doorway and let the chest stretch."),
            Stretch(name: "Lat Stretch", hold: "30 sec each side",
                    detail: "Reach overhead onto a support and sink the hips back to lengthen the side of the back.")
        ],
        source: "From MovementbyDavid's video \"Literally 5 Stretches is all you Need\". Hold each for 30 seconds and do it every day. Watch the video for form."
    )
}

/// "Starting Stretching" (phrakture.github.io/starting-stretching.html): nine stretches,
/// 60 seconds each, with a beginner, intermediate and advanced version of every one.
enum StartingStretching {
    enum Level: String, CaseIterable {
        case beginner = "Beginner", intermediate = "Intermediate", advanced = "Advanced"
    }

    /// (name, beginner, intermediate, advanced)
    private static let stretches: [(String, String, String, String)] = [
        ("Shoulder Extension",
         "Hands on something overhead, arms straight, palms down; push the head and chest through.",
         "Elbows on the object with the hands together as if praying; push the head and chest through.",
         "Palms facing up (a stick helps), or a dead hang from a bar with a chin-up grip."),
        ("Underarm Shoulder Stretch",
         "Seated, hands behind you on the floor about shoulder width, fingers pointing away; slide the hips forward.",
         "Seated, hands behind you held narrower than shoulder width with a stick or band; slide the hips forward.",
         "German hang: hang from a bar with the arms behind you."),
        ("Rear Hand Clasp",
         "One hand overhead, one behind the lower back; use a towel or strap to bring them together. Both sides.",
         "Grab the opposite fingers or hands behind your back. Both sides.",
         "Grab the opposite wrists behind your back. Both sides."),
        ("Full Squat",
         "Heels down, squat as deep as you can with the arms inside the knees pressing out, and hold.",
         "Heels down, squat as deep as you can with the arms pressing the knees out; sit up tall, chest and head high.",
         "Heels down in a deep squat, sitting up vertically with the toes pointing forward."),
        ("Standing Pike",
         "Hinge forward with a flat back, reaching for the floor 1–2 feet in front of your toes. Bend the knees to come up.",
         "Once below parallel with a flat back, grab the calves and pull your chest towards your knees.",
         "Bring your chest to your knees without pulling with the arms."),
        ("Kneeling Lunge",
         "Back knee down, front shin vertical; squeeze the glutes and press the hips forward with hands on the front leg. Both sides.",
         "Back knee down, front shin vertical; squeeze the glutes and press the hips forward with hands at your sides, palms forward, shoulders back. Both sides.",
         "Raise the rear foot up to the glutes and hold it with both arms. Both sides."),
        ("Butterfly",
         "Seated, soles together, hold the feet and press the knees towards the floor using strength alone.",
         "Lean forward slightly with a flat back and press the knees down with your elbows.",
         "Lean forward with a flat back, aiming chest to legs and knees to the floor."),
        ("Backbend",
         "Glute bridge: on your back, feet near the glutes, squeeze the glutes and press the hips up.",
         "Camel: kneeling, toes tucked, hold your heels and push the hips forward, looking up.",
         "Bridge (wheel): hands by your head, press up onto the head, then straighten the arms. Stop if the lower back pinches."),
        ("Lying Twist",
         "On your back, arms out, bring a bent knee across the body with shoulders down; press with the arm. Both sides.",
         "On your back, arms out, bring a straight, locked leg across the body with shoulders down; press with the arm. Both sides.",
         "On your back, arms out, bring a straight leg across the body with shoulders down and hold it with muscle alone, no arm. Both sides.")
    ]

    static let levels: [StretchRoutine] = Level.allCases.map(routine)

    static func isLevel(_ id: String) -> Bool {
        levels.contains { $0.id == id }
    }

    static func routine(_ level: Level) -> StretchRoutine {
        StretchRoutine(
            id: "starting-stretching-\(level.rawValue.lowercased())",
            name: "Starting Stretching: \(level.rawValue)",
            summary: "9 full-body stretches, 60 sec each",
            minutes: 15,
            stretches: stretches.map { name, beginner, intermediate, advanced in
                let detail: String
                switch level {
                case .beginner: detail = beginner
                case .intermediate: detail = intermediate
                case .advanced: detail = advanced
                }
                return Stretch(name: name, hold: "60 sec", detail: detail)
            },
            source: "From Starting Stretching. Hold each for 60 seconds in total (split into rests of no less than 20 seconds if needed). Stop if anything hurts."
        )
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
