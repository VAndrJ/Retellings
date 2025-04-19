//
//  PlayerReducer.swift
//  Retellings
//
//  Created by VAndrJ on 4/19/25.
//

import Foundation
import TCAComposer
import ComposableArchitecture

@Composer
struct PlayerReducer {
    struct State: Equatable {
        var isPlaying = false
    }

    enum Actions: Equatable {
        enum View: Equatable {
            case playPause
        }

        enum Effect: Equatable {
            case load(URL)
        }
    }

    @ComposeBodyActionCase
    func view(state: inout State, action: Actions.View) -> EffectOf<Self> {
        switch action {
        case .playPause:
            assertionFailure("implement")

            return .none
        }
    }

    @ComposeBodyActionCase
    func effect(state: inout State, action: Actions.Effect) -> EffectOf<Self> {
        switch action {
        case let .load(url):
            assertionFailure("implement")

            return .none
        }
    }
}
