//
//  RunPlanTests.swift
//  ForgeTests
//

import Foundation
import Testing
@testable import Forge

struct RunPlanTests {
    @Test func couchTo5KMatchesTheNHSPlan() {
        let sessions = RunPlanTemplate.couchTo5K.makeSessions()
        #expect(sessions.count == 27)                        // 9 weeks × 3 runs
        let allTimed = sessions.allSatisfy(\.isTimed)
        let allWarmAndCool = sessions.allSatisfy { $0.segments.first == .warmUp && $0.segments.last == .coolDown }
        #expect(allTimed)
        #expect(allWarmAndCool)

        let first = sessions[0]
        #expect(first.summary == "Run 60 sec / walk 90 sec × 8")
        #expect(first.totalSeconds == 5 * 60 + 8 * 150 + 5 * 60)   // 30 minutes

        let last = sessions[26]
        #expect(last.week == 9 && last.number == 3)
        #expect(last.summary == "Run 30 min")
    }

    @Test func halfMarathonEndsWithRaceDay() {
        let sessions = RunPlanTemplate.halfMarathon.makeSessions()
        #expect(sessions.count == 36)
        let allDistance = sessions.allSatisfy { !$0.isTimed }
        #expect(allDistance)
        #expect(sessions.last?.runningKilometres == 21.1)
        #expect(sessions.last?.summary == "Run 21.1 km")
    }

    @Test func nextSessionAdvancesAsRunsAreTicked() {
        let plan = RunPlanTemplate.fiveToTenK.createPlan()
        let first = plan.nextSession!
        #expect(first.week == 1 && first.number == 1)
        plan.setCompleted(first.id, on: Date())
        #expect(plan.nextSession?.number == 2)
        #expect(plan.completedCount == 1)
        plan.setCompleted(first.id, on: nil)
        #expect(plan.nextSession?.id == first.id)
    }
}

struct RunDistanceTests {
    @Test func coveredDistanceUsesLoggedThenPlanned() {
        let plan = RunPlanTemplate.halfMarathon.createPlan()
        let first = plan.orderedSessions[0]           // easy 4 km
        #expect(plan.coveredKilometres == 0)          // nothing done yet

        plan.setCompleted(first.id, on: Date())
        #expect(plan.coveredKilometres == 4)          // planned distance by default

        plan.setDistance(first.id, kilometres: 5.2)
        #expect(plan.coveredKilometres == 5.2)        // what was actually run

        let timed = RunPlanTemplate.couchTo5K.createPlan()
        let run = timed.orderedSessions[0]
        timed.setCompleted(run.id, on: Date())
        #expect(timed.coveredKilometres == 0)         // timed runs need a logged distance
        timed.setDistance(run.id, kilometres: 3.1)
        #expect(timed.coveredKilometres == 3.1)
    }

    @Test func raceTimesAndPace() {
        #expect(RaceTime.format(21 * 60) == "21:00")
        #expect(RaceTime.format(96 * 60) == "1:36:00")
        #expect(RaceTime.format(3 * 3600 + 5 * 60 + 9) == "3:05:09")

        let race = RaceResult(distance: .fiveK, seconds: 25 * 60, date: Date())
        #expect(race.pace == "5:00 /km")
    }

    @Test func raceDaySessionsKnowTheirDistance() {
        let half = RunPlanTemplate.halfMarathon.makeSessions()
        #expect(half.last?.raceDistance == .half)
        #expect(half.first?.raceDistance == nil)
        let tenK = RunPlanTemplate.fiveToTenK.makeSessions()
        #expect(tenK.last?.raceDistance == .tenK)
    }
}

struct CustomRunPlanTests {
    @Test func customPlanGroupsRunsIntoWeeks() {
        var intervals = CustomRun()
        intervals.kind = .intervals
        intervals.runSeconds = 60
        intervals.walkSeconds = 90
        intervals.repeats = 8
        var steady = CustomRun()
        steady.kind = .steady
        steady.minutes = 20
        var distance = CustomRun()
        distance.kind = .distance
        distance.kilometres = 5

        let custom = CustomRunPlan(name: "Mine", runsPerWeek: 2, runs: [intervals, steady, distance])
        #expect(custom.weekCount == 2)

        let plan = custom.createPlan()
        let sessions = plan.orderedSessions
        #expect(sessions.count == 3)
        #expect(sessions[0].week == 1 && sessions[0].number == 1)
        #expect(sessions[1].week == 1 && sessions[1].number == 2)
        #expect(sessions[2].week == 2 && sessions[2].number == 1)
        #expect(sessions[0].summary == "Run 60 sec / walk 90 sec × 8")
        #expect(sessions[1].summary == "Run 20 min")
        #expect(sessions[2].summary == "Run 5 km")
        #expect(sessions[2].runningKilometres == 5)
    }
}
