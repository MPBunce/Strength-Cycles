//
//  PlusStore.swift
//  Forge
//
//  Buys and restores Forge Plus, a one-time (non-consumable) in-app purchase,
//  and keeps `ForgePlus.isActive` in step with what the App Store says you own.
//

import Foundation
import Observation
import StoreKit

@MainActor
@Observable
final class PlusStore {
    static let shared = PlusStore()

    /// Must match the in-app purchase set up in App Store Connect.
    static let productID = "mpbunce.forge.plus"

    private(set) var product: Product?
    private(set) var isPurchasing = false
    private(set) var isRestoring = false
    /// Set when loading, buying or restoring fails, for the Plus screen to show.
    var errorMessage: String?

    private var updates: Task<Void, Never>?

    /// Loads the product, checks what's owned, and listens for purchases made elsewhere
    /// (another device, Ask to Buy approvals, refunds).
    func start() {
        guard updates == nil else { return }
        updates = Task { [weak self] in
            for await result in Transaction.updates {
                await self?.handle(result)
            }
        }
        Task {
            await loadProduct()
            await refreshEntitlement()
        }
    }

    func loadProduct() async {
        guard product == nil else { return }
        do {
            product = try await Product.products(for: [Self.productID]).first
        } catch {
            errorMessage = "Couldn't reach the App Store. Check your connection and try again."
        }
    }

    func purchase() async {
        if product == nil { await loadProduct() }
        guard let product else {
            errorMessage = "Forge Plus isn't available right now. Try again later."
            return
        }
        isPurchasing = true
        defer { isPurchasing = false }
        do {
            switch try await product.purchase() {
            case .success(let result):
                await handle(result)
            case .pending:
                // Ask to Buy or a payment check; Transaction.updates delivers it later.
                errorMessage = "Your purchase is waiting for approval."
            case .userCancelled:
                break
            @unknown default:
                break
            }
        } catch {
            errorMessage = "The purchase didn't go through. You haven't been charged."
        }
    }

    /// Restore Purchases: syncs with the App Store (may ask the user to sign in).
    func restore() async {
        isRestoring = true
        defer { isRestoring = false }
        do {
            try await AppStore.sync()
        } catch {
            errorMessage = "Couldn't restore purchases. Check your connection and try again."
        }
        await refreshEntitlement()
        if !ForgePlus.shared.isActive {
            errorMessage = "No Forge Plus purchase was found for this Apple Account."
        }
    }

    /// Unlocks Plus if a verified, unrefunded purchase exists. Release builds also lock it
    /// again when there isn't one (for example after a refund).
    func refreshEntitlement() async {
        var owned = false
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result,
               transaction.productID == Self.productID,
               transaction.revocationDate == nil {
                owned = true
            }
        }
        apply(owned: owned)
    }

    private func handle(_ result: VerificationResult<Transaction>) async {
        guard case .verified(let transaction) = result else { return }
        await transaction.finish()
        if transaction.productID == Self.productID {
            await refreshEntitlement()
        }
    }

    private func apply(owned: Bool) {
        #if DEBUG
        // Keep the developer preview switch working when nothing has been bought.
        if owned { ForgePlus.shared.isActive = true }
        #else
        ForgePlus.shared.isActive = owned
        #endif
    }
}
