//
//  GuidedRunView.swift
//  Forge
//
//  Full-screen interval timer for timed runs: shows the current segment and
//  speaks/vibrates at each change ("Run", "Walk").
//

import SwiftUI
import AVFoundation
import UIKit

struct GuidedRunView: View {
    @Environment(\.dismiss) private var dismiss
    let session: RunSession
    let onFinish: () -> Void

    @State private var startDate: Date?
    @State private var pausedAt: Date?
    @State private var pausedTotal: TimeInterval = 0
    @State private var announcedIndex: Int = -1
    @State private var speech = AVSpeechSynthesizer()

    private var segments: [RunSegment] { session.segments }
    private var total: Int { session.totalSeconds }

    var body: some View {
        NavigationStack {
            TimelineView(.periodic(from: .now, by: 0.25)) { context in
                let elapsed = elapsedSeconds(at: context.date)
                let position = segmentPosition(at: elapsed)
                content(elapsed: elapsed, position: position)
                    .onChange(of: position?.index ?? segments.count) { _, index in
                        announce(index)
                    }
            }
            .navigationTitle(session.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
        .onAppear { UIApplication.shared.isIdleTimerDisabled = true }
        .onDisappear { UIApplication.shared.isIdleTimerDisabled = false }
    }

    @ViewBuilder
    private func content(elapsed: Int, position: (index: Int, remaining: Int)?) -> some View {
        VStack(spacing: 24) {
            Spacer()

            if let position {
                let segment = segments[position.index]
                Text(segment.kind.title.uppercased())
                    .font(.system(.title, design: .rounded, weight: .heavy))
                    .foregroundStyle(segment.kind.isRunning ? Color.orange : Color.green)
                Text(clock(position.remaining))
                    .font(.system(size: 88, weight: .bold, design: .rounded))
                    .monospacedDigit()
                if position.index + 1 < segments.count {
                    Text("Next: \(segments[position.index + 1].label)")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }
            } else {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(.green)
                Text("Run complete")
                    .font(.title.bold())
            }

            SwiftUI.ProgressView(value: Double(min(elapsed, total)), total: Double(max(total, 1)))
                .tint(.orange)
                .padding(.horizontal)
            Text("\(clock(min(elapsed, total))) of \(clock(total))")
                .font(.subheadline.monospacedDigit())
                .foregroundStyle(.secondary)

            Spacer()

            controls(isFinished: position == nil)
        }
        .padding()
    }

    @ViewBuilder
    private func controls(isFinished: Bool) -> some View {
        if isFinished {
            Button {
                onFinish()
                dismiss()
            } label: {
                Text("Mark Run Complete").frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        } else if startDate == nil {
            Button {
                startDate = Date()
                announce(0)
            } label: {
                Text("Start").frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        } else {
            HStack {
                Button {
                    if let pausedAt {
                        pausedTotal += Date().timeIntervalSince(pausedAt)
                        self.pausedAt = nil
                    } else {
                        pausedAt = Date()
                    }
                } label: {
                    Text(pausedAt == nil ? "Pause" : "Resume").frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)

                Button(role: .destructive) {
                    startDate = nil
                    pausedAt = nil
                    pausedTotal = 0
                    announcedIndex = -1
                } label: {
                    Text("Restart").frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }
            .controlSize(.large)
        }
    }

    // MARK: - Timing

    private func elapsedSeconds(at now: Date) -> Int {
        guard let startDate else { return 0 }
        let end = pausedAt ?? now
        return max(0, Int(end.timeIntervalSince(startDate) - pausedTotal))
    }

    /// Current segment and seconds left in it; nil once the run is over.
    private func segmentPosition(at elapsed: Int) -> (index: Int, remaining: Int)? {
        var start = 0
        for (index, segment) in segments.enumerated() {
            let length = segment.seconds ?? 0
            if elapsed < start + length { return (index, start + length - elapsed) }
            start += length
        }
        return nil
    }

    private func announce(_ index: Int) {
        guard startDate != nil, index != announcedIndex else { return }
        announcedIndex = index
        let phrase: String
        if index < segments.count {
            let segment = segments[index]
            phrase = "\(segment.kind.title) for \(RunSegment.formatDuration(segment.seconds ?? 0).replacingOccurrences(of: "sec", with: "seconds").replacingOccurrences(of: "min", with: "minutes"))"
        } else {
            phrase = "Run complete. Great work."
        }
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        speech.speak(AVSpeechUtterance(string: phrase))
    }

    private func clock(_ seconds: Int) -> String {
        String(format: "%d:%02d", seconds / 60, seconds % 60)
    }
}
