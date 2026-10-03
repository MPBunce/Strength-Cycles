//
//  PlusStoreTests.swift
//  ForgeTests
//
//  Buys Forge Plus against a local StoreKit configuration (no real App Store).
//

import StoreKitTest
import Testing
@testable import Forge

@MainActor
@Suite(.serialized)
struct PlusStoreTests {
    @Test func purchaseUnlocksPlus() async throws {
        let session = try SKTestSession(configurationFileNamed: "ForgePlus")
        session.resetToDefaultState()
        session.clearTransactions()
        session.disableDialogs = true

        ForgePlus.shared.isActive = false
        let store = PlusStore.shared
        await store.loadProduct()
        #expect(store.product?.id == PlusStore.productID)

        await store.purchase()
        #expect(store.errorMessage == nil)
        #expect(ForgePlus.shared.isActive)

        // A fresh entitlement check still finds the purchase.
        ForgePlus.shared.isActive = false
        await store.refreshEntitlement()
        #expect(ForgePlus.shared.isActive)
    }
}
