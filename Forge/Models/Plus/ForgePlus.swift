//
//  ForgePlus.swift
//  Forge
//
//  Whether Forge Plus is unlocked. `PlusStore` sets this from App Store purchases.
//

import Foundation
import Observation

@Observable
final class ForgePlus {
    static let shared = ForgePlus()

    private static let key = "forgePlusActive"

    /// Whether Plus features are unlocked: set by `PlusStore`, or the developer switch in debug builds.
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
