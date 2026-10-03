//
//  ForgeTests.swift
//  ForgeTests
//
//  Created by Matthew Bunce on 2025-05-28.
//

import Testing
@testable import Forge

struct ForgeTests {

    @Test func example() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    }

}

struct ExerciseSwapTests {
    @Test func swapsRenameEveryDayAndKeepSuffixes() {
        let settings = UserSettings(from: Settings.defaultSettings)
        let template = Template.loadTemplates().first { $0.programType == .fiveThreeOneBBBProgram }!
        let cycle = template.createCycle(with: settings, swaps: ["Squat": "Front Squat"])
        let names = cycle.trainingDays.flatMap(\.day).map(\.name)
        #expect(!names.contains("Squat"))
        #expect(names.contains("Front Squat"))
        #expect(names.contains("Front Squat (BBB)"))
        #expect(names.contains("Bench Press"))
    }

    @Test func liftsListEachLiftOnce() {
        let settings = UserSettings(from: Settings.defaultSettings)
        let days = ProgramType.greySkull.createProgram(with: settings).generateDays(with: settings)
        let lifts = ExerciseSwaps.lifts(in: days)
        #expect(lifts.first == "Bench Press")
        #expect(Set(lifts).count == lifts.count)
        #expect(ExerciseSwaps.alternatives(for: "Squat").contains("Front Squat"))
    }
}
