//
//  ForgePlus.swift
//  Forge
//
//  What's free and what's part of Forge Plus. Purchases aren't wired up yet; when they are,
//  they only need to set `ForgePlus.isActive`.
//

import Foundation
import Observation

@Observable
final class ForgePlus {
    static let shared = ForgePlus()

    private static let key = "forgePlusActive"

    /// Whether Plus features are unlocked. Set by purchases later, or the debug switch for now.
    var isActive: Bool {
        didSet { UserDefaults.standard.set(isActive, forKey: Self.key) }
    }

    private init() {
        #if DEBUG
        // Development builds (installed from Xcode) are full access unless switched off.
        isActive = UserDefaults.standard.object(forKey: Self.key) as? Bool ?? true
        #else
        isActive = UserDefaults.standard.bool(forKey: Self.key)
        #endif
    }
}
