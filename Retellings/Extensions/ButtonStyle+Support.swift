//
//  ButtonStyle+Support.swift
//  Retellings
//
//  Created by VAndrJ on 4/18/25.
//

import SwiftUI

extension ButtonStyle where Self == PlaybackButtonStyle {
    @MainActor @preconcurrency static var playback: PlaybackButtonStyle { .init() }
}

struct PlaybackButtonStyle: ButtonStyle {
    @Environment(\.isEnabled)
    private var isEnabled: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(isEnabled ? Color.primary : .gray.opacity(0.4))
            .opacity(configuration.isPressed ? 0.6 : 1)
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            .background(configuration.isPressed ? Color.primary.opacity(0.1) : .clear)
    }
}
