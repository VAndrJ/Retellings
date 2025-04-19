//
//  SpeedControlView.swift
//  Retellings
//
//  Created by VAndrJ on 4/18/25.
//

import SwiftUI

struct SpeedControlView: View {
    @Binding var speed: Float
    var range: ClosedRange<Float> = 0.2...2.5
    var step: Float = 0.1

    @State private var isSliderVisible = false
    @State private var hideTask: Task<Void, Never>?
    @Namespace private var control

    var body: some View {
        HStack(spacing: 0) {
            if isSliderVisible {
                Slider(value: $speed, in: range) { editing in
                    if editing == false {
                        scheduleHide()
                    } else {
                        cancelHide()
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
                    Text(String(format: "x%.1f", speed))
                        .contentTransition(.numericText())
                        .monospaced()
                        .animation(.linear(duration: 0.1), value: speed)
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
    @Previewable @State var speed: Float = 1.0

    SpeedControlView(speed: $speed)
}
