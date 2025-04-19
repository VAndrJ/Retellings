//
//  SpeedControlView.swift
//  Retellings
//
//  Created by VAndrJ on 4/18/25.
//

import SwiftUI

struct SpeedControlView: View {
    var speed: Float
    var range: ClosedRange<Float> = 0.2...2.5
    var step: Float = 0.1
    let onSeek: (Float) -> Void

    @State private var isSliderVisible = false
    @State private var hideTask: Task<Void, Never>?
    @Namespace private var control
    @State private var isDragging = false
    @State private var dragValue: Float
    @State private var debounceId = UUID()

    init(
        speed: Float,
        range: ClosedRange<Float> = 0.2...2.5,
        step: Float = 0.1,
        onSeek: @escaping (Float) -> Void
    ) {
        self.speed = speed
        self.range = range
        self.step = step
        self.onSeek = onSeek
        self.dragValue = speed
    }

    var body: some View {
        HStack(spacing: 0) {
            if isSliderVisible {
                Slider(
                    value: Binding(
                        get: {
                            isDragging ? dragValue : speed
                        },
                        set: { newValue in
                            dragValue = newValue
                            debounceId = UUID()
                        }
                    ),
                    in: range,
                    step: step
                ) { editing in
                    isDragging = editing
                    if editing {
                        cancelHide()
                    } else {
                        scheduleHide()
                        if speed != dragValue {
                            onSeek(dragValue)
                        }
                    }
                }
                .padding(.leading, 12)
                .frame(width: 176)
                .transition(.opacity)
                .matchedGeometryEffect(
                    id: control,
                    in: control,
                    properties: [.position],
                    anchor: .trailing
                )
                .onAppear {
                    scheduleHide()
                }
            }
            Button {
                withAnimation {
                    isSliderVisible.toggle()
                }
            } label: {
                HStack {
                    if !isSliderVisible {
                        Text("Speed")
                            .matchedGeometryEffect(
                                id: control,
                                in: control,
                                properties: [.position],
                                anchor: .leading
                            )
                    }
                    Text(String(format: "x%.1f", isDragging ? dragValue : speed))
                        .contentTransition(.numericText())
                        .monospaced()
                        .animation(.linear(duration: 0.1), value: dragValue)
                }
                .dynamicFont(.inter, size: 14, weight: .bold)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .frame(minHeight: 44)
            }
            .foregroundStyle(.primary)
            .disabled(isSliderVisible)
        }
        .background(Color(.systemGray6))
        .clipShape(.rect(cornerRadius: 12))
        .contentShape(.rect(cornerRadius: 12))
        .clampingDynamicTypeSize()
        .task(id: debounceId) {
            guard isDragging, dragValue != speed else { return }

            try? await Task.sleep(for: .milliseconds(300))
            guard !Task.isCancelled else { return }

            onSeek(dragValue)
        }
    }

    private func scheduleHide() {
        cancelHide()
        hideTask = Task {
            try? await Task.sleep(for: .seconds(3))
            guard !Task.isCancelled else { return }

            withAnimation {
                isSliderVisible = false
            }
        }
    }

    private func cancelHide() {
        hideTask?.cancel()
        hideTask = nil
    }
}

#Preview {
    @Previewable var speed: Float = 1.0

    SpeedControlView(speed: speed) {
        print($0)
    }
}
