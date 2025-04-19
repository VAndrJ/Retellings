//
//  PlayerControlButton.swift
//  Retellings
//
//  Created by VAndrJ on 4/18/25.
//

import SwiftUI

struct PlayerControlButton: View {
    enum Control: String, CaseIterable {
        case previous = "backward.end"
        case next = "forward.end"
        case seekBackward = "gobackward.5"
        case seekForward = "goforward.10"
        case pause = "pause.fill"
        case play = "play.fill"
    }

    let control: Control
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: control.rawValue)
                .dynamicFont(.inter, size: 24)
                .frame(same: 48)
        }
        .clipShape(.circle)
        .contentShape(.circle)
        .buttonStyle(.playback)
        .clampingDynamicTypeSize()
    }
}

#Preview {
    HStack {
        VStack {
            ForEach(PlayerControlButton.Control.allCases, id: \.rawValue) {
                PlayerControlButton(control: $0) {}
            }
        }
        VStack {
            ForEach(PlayerControlButton.Control.allCases, id: \.rawValue) {
                PlayerControlButton(control: $0) {}
                    .disabled(true)
            }
        }
    }
}
