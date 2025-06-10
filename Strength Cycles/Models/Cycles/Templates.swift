import Foundation
import SwiftData


// MARK: - Program Protocol
protocol ProgramProtocol {
    func copyTrainingDays() -> [TrainingDay]
    func generateDays(with maxes: TrainingMaxes) -> [TrainingDay]
}

// MARK: - Default Implementation
extension ProgramProtocol {
    func generateDays(with maxes: TrainingMaxes) -> [TrainingDay] {
        // Default implementation just returns copied days
        // Override this method in programs that need to use training maxes
        return copyTrainingDays()
    }
}

// MARK: - Training Maxes
struct TrainingMaxes {
    let squat: Double
    let bench: Double
    let deadlift: Double
    let press: Double
    
    init(from settings: Settings) {
        self.squat = settings.squatMax
        self.bench = settings.benchPressMax
        self.deadlift = settings.deadliftMax
        self.press = settings.overheadPressMax
    }
}

// MARK: - Template Structure
struct Template: Identifiable {
    let id: String
    let name: String
    let description: String
    let duration: String
    let programType: ProgramType
    
    func createCycle(with maxes: TrainingMaxes, startDate: Date = Date()) -> Cycles {
        let program = programType.createProgram(with: maxes)
        let trainingDays = program.generateDays(with: maxes)
        
        return Cycles(
            startDate: startDate,
            template: name,
            trainingDays: trainingDays
        )
    }
}

// MARK: - Program Types
enum ProgramType {
    case menzer
    case pushPullLegs
    case upperLower
    case nSuns4Days
    
    func createProgram(with maxes: TrainingMaxes) -> ProgramProtocol {
        switch self {
        case .menzer:
            return MenzerProgram()
        case .pushPullLegs:
            return PPLProgram()
        case .upperLower:
            return UpperLowerProgram()
        case .nSuns4Days:
            return nSunsFourDayProgram(benchTM: maxes.bench, squatTM: maxes.squat, deadliftTM: maxes.deadlift, ohpTM: maxes.press)
        }
    }
}

// MARK: - Template Loading
extension Template {
    static func loadTemplates() -> [Template] {
        return [
            Template(
                id: "classic-menzer",
                name: "Classic Menzer Cycle",
                description: "High-intensity training with extended rest periods",
                duration: "4 days",
                programType: .menzer
            ),
            Template(
                id: "ppl",
                name: "Push Pull Legs",
                description: "Split training focusing on movement patterns",
                duration: "3 days",
                programType: .pushPullLegs
            ),
            Template(
                id: "upper_lower",
                name: "Upper Lower Split",
                description: "4-day split alternating upper and lower body",
                duration: "4 days",
                programType: .upperLower
            ),
            Template(
                id: "nSuns",
                name: "nSuns 4 Day",
                description: "4-day nSuns Program",
                duration: "4 days",
                programType: .nSuns4Days
            )
        ]
    }
}
