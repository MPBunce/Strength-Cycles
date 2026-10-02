//
//  RaceResult.swift
//  Forge
//
//  Logged race results (5K, 10K, half and full marathon) and the time goals for each.
//

import Foundation
import SwiftData

enum RaceDistance: String, Codable, CaseIterable, Identifiable {
    case fiveK, tenK, half, marathon

    var id: Self { self }

    var name: String {
        switch self {
        case .fiveK: return "5K"
        case .tenK: return "10K"
        case .half: return "Half Marathon"
        case .marathon: return "Marathon"
        }
    }

    var kilometres: Double {
        switch self {
        case .fiveK: return 5
        case .tenK: return 10
        case .half: return 21.0975
        case .marathon: return 42.195
        }
    }

    /// Rough top-5% finish time across all finishers in large public race results.
    /// Real cut-offs vary a lot by age, sex and course, so the user can change it.
    var defaultTopFivePercentSeconds: Int {
        switch self {
        case .fiveK: return 21 * 60
        case .tenK: return 44 * 60
        case .half: return 96 * 60
        case .marathon: return 200 * 60
        }
    }

    /// UserDefaults key for the user's own target time.
    var targetKey: String { "raceTarget.\(rawValue)" }
}

@Model
class RaceResult {
    var distanceRaw: String = RaceDistance.fiveK.rawValue
    var seconds: Int = 0
    var date: Date = Date()
    var name: String = ""

    init(distance: RaceDistance, seconds: Int, date: Date, name: String = "") {
        self.distanceRaw = distance.rawValue
        self.seconds = seconds
        self.date = date
        self.name = name
    }

    var distance: RaceDistance {
        get { RaceDistance(rawValue: distanceRaw) ?? .fiveK }
        set { distanceRaw = newValue.rawValue }
    }

    /// Minutes and seconds per kilometre, e.g. "5:12 /km".
    var pace: String {
        let perKm = Double(seconds) / distance.kilometres
        let total = Int(perKm.rounded())
        return String(format: "%d:%02d /km", total / 60, total % 60)
    }
}

enum RaceTime {
    /// "21:30" or "1:36:00".
    static func format(_ seconds: Int) -> String {
        let h = seconds / 3600, m = (seconds % 3600) / 60, s = seconds % 60
        return h > 0 ? String(format: "%d:%02d:%02d", h, m, s) : String(format: "%d:%02d", m, s)
    }
}
