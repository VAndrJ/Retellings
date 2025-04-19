//
//  PlayerControlsView.swift
//  Retellings
//
//  Created by VAndrJ on 4/19/25.
//

import ComposableArchitecture
import SwiftUI

@ViewAction(for: ListeningReducer.self)
struct PlayerControlsView: View {
    @Bindable var store: StoreOf<ListeningReducer>

    var body: some View {
        HStack {
            PlayerControlButton(control: .previous) {
                send(.previous)
            }
            .disabled(!store.isPreviousAvailable)
            PlayerControlButton(control: .seekBackward) {
                send(.seekBackward)
            }
            PlayerControlButton(control: store.isPlaying ? .pause : .play) {
                send(.playPause)
            }
            PlayerControlButton(control: .seekForward) {
                send(.seekForward)
            }
            PlayerControlButton(control: .next) {
                send(.next)
            }
            .disabled(!store.isNextAvailable)
        }
    }
}

#Preview {
    PlayerControlsView(store: Store(initialState: .init()) {
        ListeningReducer()
    })
}
