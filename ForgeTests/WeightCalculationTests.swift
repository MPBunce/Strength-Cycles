//
//  WeightCalculationTests.swift
//  ForgeTests
//
//  Training-max programs must produce loadable weights in the lifter's own unit:
//  exact percentage, rounded down to a pair of their smallest plates, never below the bar.
//

import Foundation
import Testing
@testable import Forge

struct WeightCalculationTests {

    /// Settings with maxes entered in the lifter's unit (stored internally in lbs).
    private func settings(kg: Bool, max: Double, plate: Double, bar: Double) -> Settings {
        let settings = Settings.defaultSettings
        settings.usesKilograms = kg
        settings.updateSquatMax(from: max)
        settings.updateBenchPressMax(from: max)
        settings.updateDeadliftMax(from: max)
        settings.updateOverheadPressMax(from: max)
        if kg {
            settings.smallestPlateKg = plate
            settings.barbellKg = bar
        } else {
            settings.smallestPlateLbs = plate
            settings.barbellLbs = bar
        }
        return settings
    }

    private func template(_ type: ProgramType) -> Template {
        Template.loadTemplates().first { $0.programType == type }!
    }

    /// Weights of the main lift (first exercise) on the first day, in set order.
    private func firstDayMainLift(_ cycle: Cycles) -> [Double] {
        let day = cycle.trainingDays.min { $0.dayIndex < $1.dayIndex }!
        let main = day.day.min { $0.exerciseIndex < $1.exerciseIndex }!
        return main.orderedSets.compactMap(\.weight)
    }

    @Test func roundingUsesPairOfSmallestPlatesAndBar() {
        let kg = WeightRounding(smallestPlate: 1.25, barbell: 20)
        #expect(kg.round(65) == 65)
        #expect(kg.round(66.4) == 65)
        #expect(kg.round(67.5) == 67.5)
        #expect(kg.round(84.99999999) == 85)   // float noise must not drop a jump
        #expect(kg.round(12) == 20)            // never below the bar

        let lbsMicro = WeightRounding(smallestPlate: 1.25, barbell: 45)
        #expect(lbsMicro.round(143.7) == 142.5)
        let lbsFive = WeightRounding(smallestPlate: 2.5, barbell: 45)
        #expect(lbsFive.round(143.7) == 140)
    }

    @Test func fiveThreeOneKilogramsMatchPercentages() {
        // 100 kg TM, week 1 = 65/75/85%. The old lbs-first maths gave 62.5 for the 65% set.
        let cycle = template(.fiveThreeOneBasicProgram)
            .createCycle(with: UserSettings(from: settings(kg: true, max: 100, plate: 1.25, bar: 20)))
        #expect(cycle.usesKilograms)
        #expect(firstDayMainLift(cycle) == [65, 75, 85])
    }

    @Test func nSunsKilogramsMatchPercentages() {
        // nSuns 4-day day 1 bench: 60,70,75,75,75,70,70,65,60%.
        let cycle = template(.nSuns4Days)
            .createCycle(with: UserSettings(from: settings(kg: true, max: 100, plate: 1.25, bar: 20)))
        #expect(firstDayMainLift(cycle) == [60, 70, 75, 75, 75, 70, 70, 65, 60])
    }

    @Test func poundsRespectSmallestPlate() {
        // 225 lb TM, 65% = 146.25: 2.5 lb plates -> 145, 1.25 lb plates -> 145 too; 75% = 168.75 -> 165 / 167.5.
        let fives = template(.fiveThreeOneBasicProgram)
            .createCycle(with: UserSettings(from: settings(kg: false, max: 225, plate: 2.5, bar: 45)))
        #expect(firstDayMainLift(fives) == [145, 165, 190])

        let micro = template(.fiveThreeOneBasicProgram)
            .createCycle(with: UserSettings(from: settings(kg: false, max: 225, plate: 1.25, bar: 45)))
        #expect(firstDayMainLift(micro) == [145, 167.5, 190])
    }

    @Test func lightTrainingMaxNeverGoesBelowBar() {
        // 40% of a 30 kg TM is 12 kg: load the empty 20 kg bar instead.
        let cycle = template(.fiveThreeOneBBBProgram)
            .createCycle(with: UserSettings(from: settings(kg: true, max: 30, plate: 1.25, bar: 20)))
        let allWeights = cycle.trainingDays.flatMap(\.day).flatMap(\.sets).compactMap(\.weight)
        #expect(!allWeights.isEmpty)
        #expect(allWeights.allSatisfy { $0 >= 20 })
    }

    @Test func everyCalculatedKilogramWeightIsLoadable() {
        // Across every training-max program and an awkward TM, each weight is a multiple of 2.5 kg.
        let types: [ProgramType] = [.fiveThreeOneBasicProgram, .fiveThreeOneBBBProgram,
                                    .nSuns4Days, .nSuns5Days, .nSuns6DaysSquat, .nSuns6DaysDeadlift]
        for type in types {
            let cycle = template(type)
                .createCycle(with: UserSettings(from: settings(kg: true, max: 117.5, plate: 1.25, bar: 20)))
            for weight in cycle.trainingDays.flatMap(\.day).flatMap(\.sets).compactMap(\.weight) {
                let steps = weight / 2.5
                #expect(abs(steps - steps.rounded()) < 1e-9, "\(type): \(weight) kg isn't loadable")
            }
        }
    }
}

struct WeightFormatTests {
    @Test func keepsMeaningfulDecimals() {
        #expect(WeightConverter.format(65) == "65")
        #expect(WeightConverter.format(67.5) == "67.5")
        #expect(WeightConverter.format(1.25) == "1.25")
        #expect(WeightConverter.format(142.5) == "142.5")
        #expect(WeightConverter.format(1000) == "1000")
    }
}
