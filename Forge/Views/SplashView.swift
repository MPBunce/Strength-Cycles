//
//  SplashView.swift
//  Forge
//
//  Shown briefly on launch: a marble statue and the quote the app is named for.
//

import SwiftUI
import UIKit

struct SplashView: View {
    /// Farnese Hercules, marble copy (CC0, Wikimedia Commons). Falls back to a figure icon if the asset is missing.
    private static let statueImageName = "SplashStatue"

    @State private var appeared = false

    var body: some View {
        ZStack {
            // Pure black so the photo's dark museum backdrop blends in.
            Color.black.ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer(minLength: 0)

                statue
                    .frame(maxHeight: 480)
                    .scaleEffect(appeared ? 1 : 0.96)

                VStack(spacing: 12) {
                    Text("“Man cannot remake himself without suffering, for he is both the marble and the sculptor.”")
                        .font(.system(.title3, design: .serif))
                        .italic()
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color(white: 0.92))
                    Text("Alexis Carrel")
                        .font(.system(.subheadline, design: .serif))
                        .foregroundStyle(Color(white: 0.6))
                }
                .padding(.horizontal, 32)

                Spacer()

                Text("FORGE")
                    .font(.system(.headline, design: .serif))
                    .tracking(8)
                    .foregroundStyle(Color(white: 0.75))
                    .padding(.bottom, 24)
            }
            .opacity(appeared ? 1 : 0)
        }
        .accessibilityElement(children: .combine)
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) { appeared = true }
        }
    }

    @ViewBuilder
    private var statue: some View {
        if UIImage(named: Self.statueImageName) != nil {
            Image(Self.statueImageName)
                .resizable()
                .scaledToFit()
                // Fade every edge so the photo's backdrop melts into the black screen
                // (nested masks multiply: vertical fade × horizontal fade).
                .mask {
                    LinearGradient(
                        stops: [.init(color: .clear, location: 0), .init(color: .black, location: 0.08),
                                .init(color: .black, location: 0.8), .init(color: .clear, location: 1)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .mask {
                        LinearGradient(
                            stops: [.init(color: .clear, location: 0), .init(color: .black, location: 0.18),
                                    .init(color: .black, location: 0.82), .init(color: .clear, location: 1)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    }
                }
                .accessibilityLabel("Marble statue of the Farnese Hercules")
        } else {
            // Placeholder until a statue image is added: a marble-toned lifter figure.
            Image(systemName: "figure.strengthtraining.traditional")
                .resizable()
                .scaledToFit()
                .padding(48)
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color(white: 0.95), Color(white: 0.7), Color(white: 0.88)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: .black.opacity(0.6), radius: 12, y: 8)
                .accessibilityLabel("Statue")
        }
    }
}

#Preview {
    SplashView()
}
