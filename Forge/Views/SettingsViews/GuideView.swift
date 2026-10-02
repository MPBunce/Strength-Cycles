//
//  GuideView.swift
//  Forge
//
//  "How Forge Works": a short guide to each part of the app, reached from About.
//

import SwiftUI

struct GuideTopic: Identifiable {
    let id: String
    let title: String
    let icon: String
    let sections: [(heading: String, body: String)]

    static let all: [GuideTopic] = [
        GuideTopic(id: "today", title: "Today", icon: "sun.max", sections: [
            ("Steps", "Your step count is read from Apple Health and compared with your daily goal (set it in Settings › Steps). Forge only reads steps; it never writes to Health. If it stays at zero, allow Forge to read Steps in the Health app under Sharing › Apps."),
            ("Daily Work", "Bodyweight exercises you do every day. Each one uses a method: Total reps (hit a number spread through the day), Ladder (1, 2, 3 … up to a peak rung) or Sets (a fixed number of sets). Use the + button to log reps quickly, or tap an exercise to set an exact count. Counts reset each day."),
            ("Stretching", "Choose routines to do each day: DeFranco's Agile 8, David's 5 Stretches (30 seconds each, daily), or Starting Stretching at one of three levels. Tap a routine to see how to do each stretch, and tick it off when done."),
            ("Challenges", "One-off goals you tick off when you've done them. Pick a preset or write your own. Completed challenges move to the Completed list with their date.")
        ]),
        GuideTopic(id: "strength", title: "Strength Training", icon: "figure.strengthtraining.traditional", sections: [
            ("Starting a cycle", "Go to Training › Strength and tap +. Pick a built-in program or one of your own templates. 5/3/1 and nSuns calculate working weights from your training maxes; other programs leave weights blank for you to fill in."),
            ("Logging sets", "Open a training day, then an exercise. Tap a set once to mark it done, again to mark it failed, and a third time to reset. AMRAP sets (as many reps as possible) open a sheet where you enter the reps you hit. Changes save straight away."),
            ("Finishing a day", "Mark the day complete from the day screen. Completed days count as workouts on the Activity grid and feed the strength charts."),
            ("Custom templates", "Tap Create Template when starting a cycle. Add named days, then exercises with sets × reps and an optional AMRAP last set. Swipe a template to edit or delete it.")
        ]),
        GuideTopic(id: "running", title: "Running", icon: "figure.run", sections: [
            ("Plans", "Training › Running › + starts Couch to 5K, 5K to 10K or a Half Marathon plan. Runs are listed by week; the next one is marked. Tick a run off when you've done it."),
            ("Guided runs", "Interval runs (like Couch to 5K) have a guided timer that shows the current segment and speaks each change: \"Run for 60 seconds\", \"Walk for 90 seconds\". Keep Forge open on screen during the run."),
            ("Distance and time", "After a run, enter how far you went so it counts towards your distance badges. Distance runs also have a time field, and Forge shows your pace."),
            ("Single runs", "Use Log a Run for any run outside a plan: enter the date, distance and, optionally, your time."),
            ("Races", "Use Log a Race to record a 5K, 10K, half or full marathon finish time. Your fastest at each distance is marked PB. Races also count as runs.")
        ]),
        GuideTopic(id: "progress", title: "Progress", icon: "chart.bar", sections: [
            ("Activity", "Each habit has a grid of the last 16 weeks, one square per day, filled in on days you did it: Worked Out, Ran, Step Goal, Daily Work and Stretching. Tap a card for its full history, stats and badges."),
            ("Badges", "Workouts and step-goal days are counted per calendar year. Running badges count kilometres run this year. Daily Work and Stretching badges are for unbroken streaks. Yearly counts reset on January 1."),
            ("Charts", "Estimated one-rep max over time, from sets marked done on completed training days. Tap Lifts to choose which lifts are charted, from the Greyskull LP exercise index."),
            ("Goals", "Strength goals like a 225 lb bench tick themselves off when you log a completed set at the target weight. Running goals tick off when you finish each distance, and when you run a fixed top-5% time: 5K in 21:00, 10K in 44:00, half in 1:36:00, marathon in 3:20:00.")
        ]),
        GuideTopic(id: "settings", title: "Settings & Weights", icon: "gear", sections: [
            ("Training maxes", "Used to work out weights when you start a 5/3/1 or nSuns cycle. Changing them only affects new cycles."),
            ("Units", "Choose lbs or kg. Each cycle keeps the unit it was created in, so switching doesn't change existing numbers."),
            ("Equipment", "Set your barbell and smallest plate. Calculated weights round down to two of your smallest plates (one per side) and never go below the empty bar."),
            ("Appearance", "Follow the system setting, or always use Light or Dark.")
        ])
    ]
}

struct GuideView: View {
    var body: some View {
        List(GuideTopic.all) { topic in
            NavigationLink {
                GuideTopicView(topic: topic)
            } label: {
                Label(topic.title, systemImage: topic.icon)
            }
        }
        .navigationTitle("How Forge Works")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct GuideTopicView: View {
    let topic: GuideTopic

    var body: some View {
        List {
            ForEach(topic.sections, id: \.heading) { section in
                Section(section.heading) {
                    Text(section.body)
                        .font(.callout)
                        .padding(.vertical, 2)
                }
            }
        }
        .navigationTitle(topic.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
