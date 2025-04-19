//
//  PlayerTimeControlView.swift
//  Retellings
//
//  Created by VAndrJ on 4/19/25.
//

import SwiftUI

struct TimeControlView: View {
    let currentTime: TimeInterval
    let duration: TimeInterval
    let onSeek: (TimeInterval) -> Void

    @State private var isDragging = false
    @State private var dragValue: Double = 0
    @State private var debounceId = UUID()

    var body: some View {
        HStack(spacing: 8) {
            Text(formatTime(isDragging ? dragValue : currentTime))
                .dynamicFont(.inter, size: 12)
                .foregroundStyle(.secondary)
                .monospacedDigit()
            Slider(
                value: Binding(
                    get: {
                        isDragging ? dragValue : currentTime
                    },
                    set: { newValue in
                        dragValue = newValue
                        debounceId = UUID()
                    }
                ),
                in: 0...max(duration, 1)
            ) { editing in
                isDragging = editing
                if !editing, dragValue != currentTime {
                    onSeek(dragValue)
                }
            }
            Text(formatTime(duration))
                .dynamicFont(.inter, size: 12)
                .foregroundStyle(.secondary)
                .monospacedDigit()
        }
        .clampingDynamicTypeSize(upperBound: .xLarge)
        .task(id: debounceId) {
            guard isDragging, dragValue != currentTime else { return }

            try? await Task.sleep(for: .milliseconds(50))
            guard !Task.isCancelled else { return }

            onSeek(dragValue)
        }
    }

    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time / 60)
        let seconds = Int(time.truncatingRemainder(dividingBy: 60))

        return String(format: "%d:%02d", minutes, seconds)
    }
}

#Preview {
    TimeControlView(currentTime: 10, duration: 42) { newTime in
        print("Seek to \(newTime)")
    }
    .padding()
}
