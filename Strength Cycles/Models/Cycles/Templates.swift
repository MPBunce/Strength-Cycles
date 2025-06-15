import Foundation
import SwiftData


// MARK: - Program Protocol
protocol ProgramProtocol {
    func copyTrainingDays() -> [TrainingDay]
    func generateDays(with settings: UserSettings) -> [TrainingDay]
}

// MARK: - Default Implementation
extension ProgramProtocol {
    func generateDays(with settings: UserSettings) -> [TrainingDay] {
        // Default implementation just returns copied days
        // Override this method in programs that need to use training maxes
        return copyTrainingDays()
    }
}

// MARK: - Training Maxes
struct UserSettings {
    let squat: Double
    let bench: Double
    let deadlift: Double
    let press: Double
    let useKilograms: Bool
    
    init(from settings: Settings) {
        self.squat = settings.squatMax
        self.bench = settings.benchPressMax
        self.deadlift = settings.deadliftMax
        self.press = settings.overheadPressMax
        self.useKilograms = settings.usesKilograms
    }
}

// MARK: - Template Structure
struct Template: Identifiable {
    let id: String
    let name: String
    let description: String
    let duration: String
    let programType: ProgramType
    
    func createCycle(with settings: UserSettings, startDate: Date = Date()) -> Cycles {
        let program = programType.createProgram(with: settings)
        let trainingDays = program.generateDays(with: settings)
        
        return Cycles(
            startDate: startDate,
            template: name,
            usesKilograms: settings.useKilograms,
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
    case nSuns5Days
    case nSuns6DaysSquat
    case nSuns6DaysDeadlift
    
    func createProgram(with settings: UserSettings) -> ProgramProtocol {
        switch self {
        case .menzer:
            return MenzerProgram()
        case .pushPullLegs:
            return PPLProgram()
        case .upperLower:
            return UpperLowerProgram()
        case .nSuns4Days:
            return nSunsFourDayProgram(benchTM: settings.bench, squatTM: settings.squat, deadliftTM: settings.deadlift, ohpTM: settings.press)
        case .nSuns5Days:
            return nSunsFiveDayProgram(benchTM: settings.bench, squatTM: settings.squat, deadliftTM: settings.deadlift, ohpTM: settings.press)
        case .nSuns6DaysSquat:
            return nSunsSixDaySquatProgram(benchTM: settings.bench, squatTM: settings.squat, deadliftTM: settings.deadlift, ohpTM: settings.press)
        case .nSuns6DaysDeadlift:
            return nSunsSixDayDeadliftProgram(benchTM: settings.bench, squatTM: settings.squat, deadliftTM: settings.deadlift, ohpTM: settings.press)
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
                id: "nSuns4Day",
                name: "nSuns 4 Day",
                description: "4-day nSuns Program",
                duration: "4 days",
                programType: .nSuns4Days
            ),
            Template(
                id: "nSuns5Day",
                name: "nSuns 5 Day",
                description: "5-day nSuns Program",
                duration: "5 days",
                programType: .nSuns5Days
            ),
            Template(
                id: "nSuns6DaySquat",
                name: "nSuns 6 Day Squat",
                description: "6-day nSuns Squat Program",
                duration: "4 days",
                programType: .nSuns6DaysSquat
            ),
            Template(
                id: "nSuns6DayDeadlift",
                name: "nSuns 6 Day",
                description: "6-day nSuns Deadlift Program",
                duration: "6 days",
                programType: .nSuns6DaysDeadlift
            )
        ]
    }
}
