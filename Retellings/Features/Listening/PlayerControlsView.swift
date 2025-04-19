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
            .disabled(!store.state.isPreviousAvailable)
            PlayerControlButton(control: .seekBackward) {
                send(.seekBackward)
            }
            PlayerControlButton(control: store.state.isPlaying ? .pause : .play) {
                send(.playPause)
            }
            PlayerControlButton(control: .seekForward) {
                send(.seekForward)
            }
            PlayerControlButton(control: .next) {
                send(.next)
            }
            .disabled(!store.state.isNextAvailable)
        }
    }
}

#Preview {
    PlayerControlsView(store: Store(initialState: .init()) {
        ListeningReducer()
    })
}
